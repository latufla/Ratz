/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 15:46
 * To change this template use File | Settings | File Templates.
 */
package core.model {

import core.controller.ControllerBase;
import core.utils.nape.CustomMaterial;
import core.utils.nape.CustomPolygon;
import core.utils.nape.CustomShape;
import core.utils.nape.PhysEngineConnector;

import flash.geom.Point;
import flash.geom.Rectangle;

import ratz.utils.Config;

public class ObjectBase {
    protected var _name:String = "dummy";
    protected var _libDesc:String = "";

    protected static const DEFAULT_SHAPE:CustomPolygon = new CustomPolygon(0, 0, 30, 60);
    protected static const DEFAULT_POSITION:Point = new Point(0, 0);

    protected var _shapes:Vector.<CustomShape>;
    protected var _material:CustomMaterial;

    protected var _interactionGroup:int = 1;

    public function ObjectBase() {
        init();
    }

    protected function init():void {
        PhysEngineConnector.instance.initObject(this);
        PhysEngineConnector.instance.setShapes(this, new <CustomShape>[DEFAULT_SHAPE]);
        PhysEngineConnector.instance.setMaterial(this, new CustomMaterial());
        PhysEngineConnector.instance.setPosition(this, DEFAULT_POSITION);
    }

    public static function create(pos:Point, shapes:Vector.<CustomShape>, material:CustomMaterial, interactionGroup:int):ObjectBase{
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

    public function get shapes():Vector.<CustomShape> {
        return _shapes;
    }

    public function set shapes(value:Vector.<CustomShape>):void {
        _shapes = value;
        PhysEngineConnector.instance.setShapes(this, _shapes);

        if(_material)
            PhysEngineConnector.instance.setMaterial(this, _material);
    }

    public function get material():CustomMaterial {
        return _material;
    }

    public function set material(value:CustomMaterial):void {
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

    public function get interactionGroup():int {
        return _interactionGroup;
    }

    public function set interactionGroup(value:int):void {
        _interactionGroup = value;
    }

    public function getDirectionTo(obj:ObjectBase):Point{
        var dir:Point = getVectorTo(obj);
        dir.normalize(1);
        return dir;
    }

    public function getVectorTo(obj:ObjectBase):Point{
        var toP:Point = obj.position;
        var fromP:Point = position;
        var v:Point = new Point(toP.x - fromP.x, toP.y - fromP.y);
        return v;
    }

    // TODO: get COM, not fake center
    public function getDirectionToPoint(toP:Point):Point{
        var dir:Point = getVectorToPoint(toP);
        dir.normalize(1);
        return dir;
    }

    public function getVectorToPoint(toP:Point):Point{
        var fromP:Point = center;
        var v:Point = new Point(toP.x - fromP.x, toP.y - fromP.y);
        return v;
    }

    // fake center
    public function get center():Point{
        var b:Rectangle = bounds;
        return new Point(b.x + b.width / 2, b.y + b.height / 2);
    }

    public function addInteractionListeners(onBeginInteraction:Function, onGoingInteraction:Function = null, onEndInteraction:Function = null):void{
        PhysEngineConnector.instance.addInteractionHandlers(this, onBeginInteraction, onGoingInteraction, onEndInteraction);
    }

    public function removeInteractionListeners():void{
        PhysEngineConnector.instance.removeInteractionHandlers(this);
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
        return Config.fieldController.getControllerByObject(this);
    }

    public function get libDesc():String {
        return _libDesc;
    }

    public function set libDesc(value:String):void {
        _libDesc = value;
    }

    public function createAsset():*{
        return null;
    }
}
}
