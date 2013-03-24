/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:47
 * To change this template use File | Settings | File Templates.
 */
package core.utils.nape {
import core.controller.FieldController;
import core.model.ObjectBase;
import core.utils.ObjectUtil;

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

public class PhysEngineConnector {

    private var _spaces:Dictionary;
    private var _physObjects:Dictionary; // key RObjectBase, value Body
    private var _handlers:Dictionary;

    private var _frictionStep:Number = 1 / 60;

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

    public function initField(f:FieldController):void {
        _spaces[f] ||= new Space();
        initEventListeners(_spaces[f]);
    }

    public function createBorders(f:ObjectBase, bd:BitmapData):void {
        var body:Body = NapeUtil.bodyFromBitmapData(bd);
        body.type = BodyType.STATIC;
        body.position = new Vec2(bd.width / 2, bd.height / 2);
        _physObjects[f] = body;
    }

    public function initObject(obj:ObjectBase):void{
        _physObjects[obj] ||= new Body(BodyType.DYNAMIC);
    }

    public function addObjectToField(f:FieldController, o:ObjectBase):void {
        _physObjects[o].space = _spaces[f];
    }

    public function removeObjectFromField(o:ObjectBase):void{
        _physObjects[o].space = null;
    }

    public function destroyObject(o:ObjectBase):void{
        removeObjectFromField(o);
        removeInteractionHandlers(o);
        delete _physObjects[o];
    }

    public function destroyField(f:FieldController):void{
        trace("PhysEngineConnector destroyField:");
        trace("objects:");
        ObjectUtil.debugTrace(_physObjects);

        trace("obj interaction handlers:");
        ObjectUtil.debugTrace(_handlers);

        var space:Space = _spaces[f];
        removeEventListeners(space);
        trace("space listeners:", space.listeners);
        trace("space bodies:", space.bodies);
        space.clear();
        delete _spaces[f];
        trace("spaces:");
        ObjectUtil.debugTrace(_spaces);

    }

    public function getPosition(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        return physObj.position.toPoint();
    }

    public function setPosition(obj:ObjectBase, pos:Point):void{
        var physObj:Body = _physObjects[obj];
        physObj.position.setxy(pos.x, pos.y);
    }

    public function getVelocity(obj:ObjectBase):Point{
        var physObj:Body = _physObjects[obj];
        return physObj.velocity.toPoint();
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
    public function applyTerrainFriction(obj:ObjectBase, k:Number = 0.2, angularK:Number = 0.1, step:Number = 1 / 60):void{
        var physObj:Body = _physObjects[obj];
        physObj.velocity.muleq(Math.pow(k, step));
        physObj.angularVel *= Math.pow(angularK, step);
    }

    public function doStep(f:FieldController, step:Number, debugView:BitmapDebug = null):void {
        var space:Space = _spaces[f];
        if(space)
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

    public function addInteractionHandlers(obj:ObjectBase, beginHandler:Function, onGoingHandler:Function = null, endHandler:Function = null):void{
        var body:Body = _physObjects[obj];
        if(!body)
            return;

        _handlers[obj] = new Dictionary();
        _handlers[obj][CbEvent.BEGIN] = beginHandler;
        _handlers[obj][CbEvent.ONGOING] = onGoingHandler;
        _handlers[obj][CbEvent.END] = endHandler;
    }

    public function removeInteractionHandlers(obj:ObjectBase):void{
        delete _handlers[obj];
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

    private function removeEventListeners(space:Space):void {
        space.listeners.clear();
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
