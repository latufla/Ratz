/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:47
 * To change this template use File | Settings | File Templates.
 */
package core.utils.nape {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

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

import ratz.Field;
import ratz.behaviors.gameplay.WallItemBehavior;
import ratz.utils.*;

public class PhysEngineConnector {

    private var _spaces:Dictionary;
    private var _physObjects:Dictionary; // key RObjectBase, value Body
    private var _handlers:Dictionary;

    private var _eventsLib:Dictionary;

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
        _eventsLib = new Dictionary();
    }

    // TODO: more secure
    // TODO: fix this dirt with space when no needed
    public function initField(f:Field, bd:BitmapData):void{
        var space:Space = Config.space;
        if(_spaces[f])
            return;

        _spaces[f] = space;//new Space();
        createBorder(f, bd);
        initEventListeners(space);
    }

    // TODO: fix this dirt
    private function createBorder(f:Field, bd:BitmapData):void{
        _border = NapeUtil.bodyFromBitmapData(bd);
        _border.type = BodyType.STATIC;
        _border.position = new Vec2(bd.width / 2, bd.height / 2);
        _border.space = _spaces[f];

        var obj:ObjectBase = new ObjectBase();
        _physObjects[obj] = _border;
        obj.material = new CustomMaterial(10, 0, 0, 1.5, 0.01);
        var borderC:ControllerBase = ControllerBase.create(obj, new <BehaviorBase>[new WallItemBehavior()]);
        Config.field.add(borderC);
    }


    private function initEventListeners(space:Space):void {
        var listener:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.ANY,
                CbType.ANY_BODY, CbType.ANY_BODY, interactionHandler);
        space.listeners.add(listener);

        listener = new InteractionListener(CbEvent.ONGOING, InteractionType.ANY,
                CbType.ANY_BODY, CbType.ANY_BODY, interactionHandler);
        space.listeners.add(listener);

        listener = new InteractionListener(CbEvent.END, InteractionType.ANY,
                CbType.ANY_BODY, CbType.ANY_BODY, interactionHandler);
        space.listeners.add(listener);
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

    public function getPosition(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        return physObj.position.toPoint();
    }

    public function setPosition(obj:ObjectBase, pos:Point):void{
        var physObj:Body = _physObjects[obj];
        physObj.position.setxy(pos.x, pos.y);
    }

    private var _stubVel:Point = new Point();
    public function getVelocity(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        _stubVel.x = physObj.velocity.x;
        _stubVel.y = physObj.velocity.y;
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

    public function setRotation(obj:ObjectBase, value:Number):void {
        var physObj:Body = _physObjects[obj];
        physObj.rotation = value;
    }

    public function setShapes(obj:ObjectBase, shapes:Vector.<CustomShape>):void{
        var physObj:Body = _physObjects[obj];
        physObj.shapes.clear();
        for each(var p:CustomShape in shapes){
            physObj.shapes.add(p.toPhysEngineObj());
        }
        physObj.align();
    }

    public function setMaterial(obj:ObjectBase, material:CustomMaterial):void{
        var physObj:Body = _physObjects[obj];
        physObj.setShapeMaterials(material.toPhysEngineObj());
    }

    // TODO: use for all shapes
    public function setPseudo(obj:ObjectBase):void{
        var physObj:Body = _physObjects[obj];
        physObj.shapes.at(0).filter.collisionGroup = 2;
        physObj.shapes.at(0).sensorEnabled = true;
    }

    public function getPseudo(obj:ObjectBase):Boolean{
        var physObj:Body = _physObjects[obj];
        return physObj.shapes.at(0).sensorEnabled;
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

    public function doStep(f:Field, step:Number, debugView:BitmapDebug = null):void{
        var space:Space = _spaces[f];
        space.step(step);

        if(!debugView)
            return;

        debugView.clear();
        debugView.draw(space);
        debugView.flush();
    }

    public function setVisible(obj:ObjectBase, value:Boolean):void{
        var physObj:Body = _physObjects[obj];
        physObj.debugDraw = value;
    }

    public function addInteractionListener(obj:ObjectBase, beginHandler:Function, onGoingHandler:Function = null, endHandler:Function = null):void{
        var body:Body = _physObjects[obj];
        if(!body)
            return;

        _handlers[obj] = new Dictionary();
        _handlers[obj][CbEvent.BEGIN] = beginHandler;
        _handlers[obj][CbEvent.ONGOING] = onGoingHandler;
        _handlers[obj][CbEvent.END] = endHandler;
    }


    public function removeInteractionListener(obj:ObjectBase, handler:Function = null):void{
        delete _handlers[obj];
    }

    private function interactionHandler(cb:InteractionCallback):void{
        var obj1:ObjectBase =  getObjBy(cb.int1.castBody);
        var obj2:ObjectBase =  getObjBy(cb.int2.castBody);

        if(!obj1 || !obj2)
            return;

        var evt:CbEvent = cb.event;
        var handlers:Dictionary = _handlers[obj1];
        if(handlers && handlers[evt])
            handlers[evt](obj1, obj2);

        handlers = _handlers[obj2];
        if(handlers && handlers[evt])
            handlers[evt](obj2, obj1);
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
