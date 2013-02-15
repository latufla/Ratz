/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:47
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import model.ObjectBase;

import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;

import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.space.Space;
import nape.util.BitmapDebug;

public class PhysEngineConnector {

    private var _spaces:Dictionary;
    private var _physObjects:Dictionary; // key RObjectBase, value Body
    private var _handlers:Dictionary;

    private var _border:Body;

    private static var _instance:PhysEngineConnector;

    public function PhysEngineConnector() {
        init();
    }

    public static function get instance():PhysEngineConnector {
        _instance ||= new PhysEngineConnector();
        return _instance;
    }

    private function init():void {
        _spaces = new Dictionary();
        _physObjects = new Dictionary();
        _handlers = new Dictionary();
    }

    // TODO: more secure
    // TODO: fix this dirt with space when no needed
    public function initField(f:Field, bd:BitmapData):void{
        var space:Space = Config.space;
        if(_spaces[f])
            return;

        _spaces[f] = space;//new Space();

        _border = NapeUtil.bodyFromBitmapData(bd);
        _border.type = BodyType.STATIC;
        _border.position = new Vec2(bd.width / 2, bd.height / 2);
        _border.space = space;

        var sensorListener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR,
                CbType.ANY_BODY, CbType.ANY_BODY, interactionHandler);
        space.listeners.add(sensorListener);
    }

    public function initObject(obj:ObjectBase):void{
        _physObjects[obj] ||= new Body(BodyType.DYNAMIC);
    }

    public function addObjectToField(f:Field, o:ObjectBase):void{
        _physObjects[o].space = _spaces[f];
    }

    public function removeObjectFromField(o:ObjectBase):void{
        _physObjects[o].space = null;
    }

    public function destroyObject(o:ObjectBase):void{
        removeObjectFromField(o);
        delete _physObjects[o];
    }

    private var _stubPos:Point = new Point();
    public function getPosition(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        _stubPos.x = physObj.position.x;
        _stubPos.y = physObj.position.y;
        return _stubPos;
    }

    public function setPosition(obj:ObjectBase, pos:Point):void{
        var physObj:Body = _physObjects[obj];
        physObj.position.setxy(pos.x, pos.y);
    }

    private var _stubVel:Point = new Point();
    public function getVelocity(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        _stubVel.x = physObj.position.x;
        _stubVel.y = physObj.position.y;
        return _stubVel;
    }

    public function setVelocity(obj:ObjectBase, vel:Point):void{
        var physObj:Body = _physObjects[obj];
        physObj.velocity = Vec2.fromPoint(vel);
    }

    public function getRotation(obj:ObjectBase):Number{
        var physObj:Body = _physObjects[obj];
        return physObj.rotation;
    }

    public function setShapes(obj:ObjectBase, shapes:Vector.<RShape>):void{
        var physObj:Body = _physObjects[obj];
        physObj.shapes.clear();
        for each(var p:RShape in shapes){
            physObj.shapes.add(p.toPhysEngineObj());
        }
        physObj.align();
    }

    public function setMaterial(obj:ObjectBase, material:RMaterial):void{
        var physObj:Body = _physObjects[obj];
        physObj.setShapeMaterials(material.toPhysEngineObj());
    }

    // TODO: use for all shapes
    public function setPseudo(obj:ObjectBase):void{
        var physObj:Body = _physObjects[obj];
        physObj.shapes.at(0).filter.collisionGroup = 2;
        physObj.shapes.at(0).sensorEnabled = true;
    }

    public function applyImpulse(obj:ObjectBase, imp:Point):void{
        var physObj:Body = _physObjects[obj];
        var napeV:Vec2 = Vec2.fromPoint(imp)
        physObj.applyImpulse(physObj.localVectorToWorld(napeV));
    }

    public function localPointToGlobal(obj:ObjectBase, lp:Point):Point{
        var physObj:Body = _physObjects[obj];
        var napeV:Vec2 = Vec2.fromPoint(lp);

        return physObj.localPointToWorld(napeV).toPoint();
    }

    public function localVecToGlobal(obj:ObjectBase, v:Point):Point{
        var physObj:Body = _physObjects[obj];
        var napeV:Vec2 = Vec2.fromPoint(v);

        return physObj.localVectorToWorld(napeV).toPoint();
    }

    public function getBounds(obj:ObjectBase):Rectangle{
        var physObj:Body = _physObjects[obj];
        return physObj.bounds.toRect();
    }

    public function applyAngularImpulse(obj:ObjectBase, aImp:int):void{
        var physObj:Body = _physObjects[obj];
        physObj.applyAngularImpulse(aImp);
    }

    // TODO: fix fps usage
    private var _pw:Number = 1 / Config.fps;
    public function applyTerrainFriction(obj:ObjectBase, k:Number = 0.2, angularK:Number = 0.1):void{
        var physObj:Body = _physObjects[obj];
        physObj.velocity.muleq(Math.pow(k, _pw));
        physObj.angularVel *= Math.pow(angularK, _pw);
    }

    public function simulateStep(f:Field, step:Number, debugView:BitmapDebug = null):void{
        var space:Space = _spaces[f];
        space.step(step);

        if(!debugView)
            return;

        debugView.clear();
        debugView.draw(space);
        debugView.flush();
    }

    public function addInteractionListener(obj:ObjectBase, handler:Function):void{
        var body:Body = _physObjects[obj];
        if(!body)
            return;

        _handlers[obj] = handler;
    }


    public function removeInteractionListener(obj:ObjectBase, handler:Function):void{
        delete _handlers[obj];
    }

    private function interactionHandler(cb:InteractionCallback):void{
        var obj1:ObjectBase =  getObjBy(cb.int1.castBody);
        var obj2:ObjectBase =  getObjBy(cb.int2.castBody);

        if(!obj1 || !obj2)
            return;

        var handler:Function = _handlers[obj1];
        if(handler)
            handler(obj1, obj2);

        handler = _handlers[obj2];
        if(handler)
            handler(obj2, obj1);
    }

    private function getObjBy(b:Body):ObjectBase{
        for (var p:* in _physObjects){
            if(b == _physObjects[p])
                return p;
        }

        return null;
    }

}
}
