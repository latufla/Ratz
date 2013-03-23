/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 18:19
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;
import core.utils.GuiUtil;
import core.utils.VectorUtil;
import core.utils.geom.Line;
import core.utils.nape.PhysEngineConnector;

import flash.geom.Point;

import ratz.Ratz;

public class WaypointItemBehavior extends BehaviorBase {

    private const CLOSEST_TO_CORNER:uint = 0;
    private const LEFT_FROM_CENTER:uint = 1;
    private const RIGHT_FROM_CENTER:uint = 2;
    private const FARTHEST_FROM_CORNER:uint = 3;

    private const MAX_TURN_POINTS_COUNT:uint = 4;

    private var _onBeginInteraction:Function;
    private var _onGoingInteraction:Function;
    private var _onEndInteraction:Function;

    private var _inLine:Line;
    private var _outLine:Line;

    private var _isFinish:Boolean;

    private var _containedObjectNames:Vector.<String>;
    private var _registeredObjectNames:Vector.<String>;

    private var _vectorToNext:Point;
    private var _distanceToFinishWaypoint:int;

    public function WaypointItemBehavior() {
        super();
        init();
    }

    public static function create(inSide:Line, outSide:Line, callbacks:Vector.<Function>, isFinish:Boolean):WaypointItemBehavior{
        var wIB:WaypointItemBehavior = new WaypointItemBehavior();
        wIB.setSides(inSide, outSide);
        wIB.setCallbacks(callbacks[0], callbacks[1], callbacks[2]);
        wIB.isFinish = isFinish;
        return wIB;
    }

    private function init():void {
        _containedObjectNames = new Vector.<String>();
        _registeredObjectNames = new Vector.<String>();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var obj:ObjectBase = _controller.object;
        obj.isPseudo = true;
//        obj.visible = false;

        if(isFinish)
            PhysEngineConnector.instance.addInteractionListener(_controller.object, onEndInteraction, null, null);
        else
            PhysEngineConnector.instance.addInteractionListener(_controller.object, onBeginInteraction, null, onEndInteraction);
    }

    override public function stop():void{
        var obj:ObjectBase = _controller.object;
        obj.isPseudo = false;
        obj.visible = true;
        PhysEngineConnector.instance.removeInteractionListener(_controller.object);

        super.stop();
    }

    public function setCallbacks(onBeginInteraction:Function, onGoingInteraction:Function = null, onEndInteraction:Function = null):void{
        _onBeginInteraction = onBeginInteraction;
        _onGoingInteraction = onGoingInteraction;
        _onEndInteraction = onEndInteraction;
    }

    public function setSides(inSide:Line, outSide:Line):void{
        _inLine = inSide;
        _outLine = outSide;
    }

    public function register(obj:ObjectBase):void{
        _registeredObjectNames.push(obj.name);

        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 350), name, 30, 0x0000FF);
    }

    public function unregister(obj:ObjectBase):void{
        VectorUtil.removeElement(_registeredObjectNames, obj.name);
    }

    public function unregisterAll():void{
        _registeredObjectNames = new Vector.<String>();
    }

    public function isRegistered(obj:ObjectBase):Boolean{
        return _registeredObjectNames.indexOf(obj.name) != -1;
    }

    // id: 0 to MAX_TURN_POINTS_COUNT - 1
    public function getTurnPoint(id:uint = CLOSEST_TO_CORNER):Point {
        if(!_inLine || id >= MAX_TURN_POINTS_COUNT || _isFinish)
            return null;

        var tPts:Vector.<Point> = _inLine.getEvenDistributedPoints(MAX_TURN_POINTS_COUNT + 2);
        tPts = sortByDistanceFromCorner(tPts);
        tPts.shift(); // no need them, cause it`s begin and end
        tPts.pop();
        return tPts[id];
    }

    public function get cornerPoint():Point{
        if(_inLine.begin.equals(_outLine.end) || _inLine.end.equals(_outLine.end))
            return _outLine.end;

        return _outLine.begin;
    }

    public function getProjectionToInLine(p:Point):Point{
        return _inLine.getPointProjection(p);
    }

    public function getProjectionToOutLine(p:Point):Point{
        return _outLine.getPointProjection(p);
    }

    private function sortByDistanceFromCorner(rotatePts:Vector.<Point>):Vector.<Point>{
        var pt:Point = cornerPoint;

        if(rotatePts[rotatePts.length - 1].equals(pt))
            rotatePts = rotatePts.reverse();

        return rotatePts;
    }

    public function containsObject(obj:ObjectBase):Boolean{
        return _containedObjectNames.indexOf(obj.name) != -1;
    }

    override protected function onBeginInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(!target.controller.isRat)
            return;

        if(_containedObjectNames.indexOf(target.name) == -1)
            _containedObjectNames.push(target.name);

        if(_onBeginInteraction)
            _onBeginInteraction(waypoint, target);
    }

//    override protected function onGoingInteraction(waypoint:ObjectBase, target:ObjectBase):void{
//        if(!target.controller.isRat)
//            return;
//
//        if(_onGoingInteraction)
//            _onGoingInteraction(waypoint, target);
//    }

    override protected function onEndInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(!target.controller.isRat)
            return;

        VectorUtil.removeElement(_containedObjectNames, target.name);

        if(_onEndInteraction)
            _onEndInteraction(waypoint, target);
    }

    public function get isFinish():Boolean {
        return _isFinish;
    }

    public function set isFinish(value:Boolean):void {
        _isFinish = value;
    }

    public function get vectorToNext():Point {
        return _vectorToNext;
    }

    public function set vectorToNext(value:Point):void {
        _vectorToNext = value;
    }

    public function get directionToNext():Point {
        var dir:Point = _vectorToNext.clone();
        dir.normalize(1);
        return dir;
    }

    public function get distanceToNext():int{
        return _vectorToNext.length;
    }

    public function get distanceToFinishWaypoint():int {
        return _distanceToFinishWaypoint;
    }

    public function set distanceToFinishWaypoint(value:int):void {
        _distanceToFinishWaypoint = value;
    }
}
}
