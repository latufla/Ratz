/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:46
 * To change this template use File | Settings | File Templates.
 */
package model {
import controller.ControllerBase;

import flash.geom.Point;
import flash.geom.Point;
import flash.geom.Rectangle;

import utils.Config;

import utils.nape.PhysEngineConnector;

import utils.nape.RMaterial;
import utils.nape.RPolygon;
import utils.nape.RShape;

public class ObjectBase {
    private var _name:String = "dummy";

    protected static const DEFAULT_SHAPE:RPolygon = new RPolygon(0, 0, 30, 60);
    protected static const DEFAULT_POSITION:Point = new Point(0, 0);

    private var _shapes:Vector.<RShape>;
    private var _material:RMaterial;

    private var _interactionGroup:int = 1;

    private var _ammunition:Ammunition;

    public function ObjectBase() {
        init();
    }

    private function init():void {
        PhysEngineConnector.instance.initObject(this);
        PhysEngineConnector.instance.setShapes(this, new <RShape>[DEFAULT_SHAPE]);
        PhysEngineConnector.instance.setMaterial(this, new RMaterial());
        PhysEngineConnector.instance.setPosition(this, DEFAULT_POSITION);

        _ammunition = new Ammunition();
    }

    public static function create(pos:Point, shapes:Vector.<RShape>, material:RMaterial, interactionGroup:int):ObjectBase{
        var obj:ObjectBase = new ObjectBase();
        obj.shapes = shapes;
        obj.material = material;
        obj.position = pos;
        obj.interactionGroup = interactionGroup;

        return obj;
     }

    public function applyImpulse(imp:Point):void{
        PhysEngineConnector.instance.applyImpulse(this, imp);
    }

    public function applyAngularImpulse(aImp:int):void{
        PhysEngineConnector.instance.applyAngularImpulse(this, aImp);
    }

    public function applyTerrainFriction(k:Number = 0.2, angK:Number = 0.1):void{
        PhysEngineConnector.instance.applyTerrainFriction(this, k, angK);
    }

    public function set isPseudo(value:Boolean):void{
        PhysEngineConnector.instance.setPseudo(this);
    }

    public function get isPseudo():Boolean{
        return PhysEngineConnector.instance.getPseudo(this);
    }

    public function get position():Point {
        return PhysEngineConnector.instance.getPosition(this);
    }

    public function set position(value:Point):void {
        PhysEngineConnector.instance.setPosition(this, value);
    }

    public function get rotation():Number {
        return PhysEngineConnector.instance.getRotation(this);
    }

    public function set rotation(value:Number):void {
        PhysEngineConnector.instance.setRotation(this, value);
    }

    public function get velocity():Point {
        return PhysEngineConnector.instance.getVelocity(this);
    }

    public function set velocity(value:Point):void {
        PhysEngineConnector.instance.setVelocity(this, value);
    }

    public function get shapes():Vector.<RShape> {
        return _shapes;
    }

    public function set shapes(value:Vector.<RShape>):void {
        _shapes = value;
        PhysEngineConnector.instance.setShapes(this, _shapes);

        if(_material)
            PhysEngineConnector.instance.setMaterial(this, _material);
    }

    public function get material():RMaterial {
        return _material;
    }

    public function set material(value:RMaterial):void {
        _material = value;
        PhysEngineConnector.instance.setMaterial(this, _material);
    }

    public function localToField(p:Point):Point{
        return PhysEngineConnector.instance.localPointToGlobal(this, p);
    }

    public function localVecToField(v:Point):Point{
        return PhysEngineConnector.instance.localVecToGlobal(this, v);
    }

    public function get bounds():Rectangle{
        return PhysEngineConnector.instance.getBounds(this);
    }

    public function get ammunition():Ammunition {
        return _ammunition;
    }

    public function set ammunition(value:Ammunition):void {
        _ammunition = value;
    }

    public function get interactionGroup():int {
        return _interactionGroup;
    }

    public function set interactionGroup(value:int):void {
        _interactionGroup = value;
    }

    public function getDirectionTo(obj:ObjectBase):Point{
        var toP:Rectangle = obj.bounds;
        var fromP:Rectangle = bounds;

        var dir:Point = new Point(toP.x - fromP.x, toP.y - fromP.y);
        dir.normalize(1);
        return dir;
    }

    // TODO: get COM, not fake center
    public function getDirectionToPoint(toP:Point):Point{
        var fromP:Point = center;

        var dir:Point = new Point(toP.x - fromP.x, toP.y - fromP.y);
        dir.normalize(1);
        return dir;
    }

    // fake center
    public function get center():Point{
        var b:Rectangle = bounds;
        return new Point(b.x + b.width / 2, b.y + b.height / 2);
    }

    public function addInteractionListener(onBeginInteraction:Function, onGoingInteraction:Function = null, onEndInteraction = null):void{
        PhysEngineConnector.instance.addInteractionListener(this, onBeginInteraction, onGoingInteraction, onEndInteraction);
    }

    public function removeInteractionListener(onInteraction:Function):void{
        PhysEngineConnector.instance.removeInteractionListener(this, removeInteractionListener);
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function set visible(value:Boolean):void{
        PhysEngineConnector.instance.setVisible(this, value);
    }

    public function get controller():ControllerBase{
        return Config.field.getControllerByObject(this);
    }
}
}
