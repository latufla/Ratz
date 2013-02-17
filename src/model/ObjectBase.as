/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:46
 * To change this template use File | Settings | File Templates.
 */
package model {
import flash.geom.Point;
import flash.geom.Point;
import flash.geom.Rectangle;

import utils.PhysEngineConnector;

import utils.RMaterial;
import utils.RPolygon;
import utils.RShape;

public class ObjectBase {
    protected static const DEFAULT_SHAPE:RPolygon = new RPolygon(0, 0, 30, 60);
    protected static const DEFAULT_POSITION:Point = new Point(0, 0);

    private var _shapes:Vector.<RShape>;
    private var _material:RMaterial;

    private var _interactionGroup:int = 1;

    private var _ammunition:Ammunition;

    private var _name:String = "dummy";

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

    public function get position():Point {
        return PhysEngineConnector.instance.getPosition(this);
    }

    public function set position(value:Point):void {
        PhysEngineConnector.instance.setPosition(this, value);
    }

    public function get rotation():Number {
        return PhysEngineConnector.instance.getRotation(this);
    }

    public function get velocity():Point {
        return PhysEngineConnector.instance.getVelocity(this);
    }

    public function set velocity(value:Point):void {
        PhysEngineConnector.instance.setVelocity(this, value);
    }

    public function set shapes(value:Vector.<RShape>):void {
        _shapes = value;
        PhysEngineConnector.instance.setShapes(this, _shapes);

        if(_material)
            PhysEngineConnector.instance.setMaterial(this, _material);
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
        var b1:Rectangle = obj.bounds;
        var b2:Rectangle = bounds;

        var dir:Point = new Point(b1.x - b2.x, b1.y - b2.y);
        dir.normalize(1);
        return dir;
    }

    public function addInteractionListener(onInteraction:Function):void{
        PhysEngineConnector.instance.addInteractionListener(this, onInteraction);
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
}
}
