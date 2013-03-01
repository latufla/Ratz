/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 18:19
 * To change this template use File | Settings | File Templates.
 */
package behaviors.core {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.GuiUtil;
import utils.geom.Line;
import utils.nape.PhysEngineConnector;
import utils.VectorUtil;

public class WaypointItemBehavior extends BehaviorBase {

    private const MAX_TURN_POINTS_COUNT:uint = 4;

    private var _onBeginInteraction:Function;
    private var _onGoingInteraction:Function;
    private var _onEndInteraction:Function;

    private var _inSide:Line;
    private var _outSide:Line;

    private var _containedObjectNames:Vector.<String>;
    private var _registeredObjectNames:Vector.<String>;

    private var _directionToNext:Point;

    public function WaypointItemBehavior() {
        super();
        init();
    }

    public static function create(inSide:Line, outSide:Line, callbacks:Vector.<Function>):WaypointItemBehavior{
        var wIB:WaypointItemBehavior = new WaypointItemBehavior();
        wIB.setSides(inSide, outSide);
        wIB.setCallbacks(callbacks[0], callbacks[1], callbacks[2]);
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
        PhysEngineConnector.instance.addInteractionListener(_controller.object, onBeginInteraction, onGoingInteraction, onEndInteraction);
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
        _inSide = inSide;
        _outSide = outSide;
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

    public function get directionToNext():Point {
        return _directionToNext;
    }

    public function set directionToNext(value:Point):void {
        _directionToNext = value;
    }

    // id: 0 to MAX_TURN_POINTS_COUNT - 1
    public function getTurnPoint(id:uint):Point {
        if(!_inSide || id >= MAX_TURN_POINTS_COUNT)
            return null;

        var tPts:Vector.<Point> = _inSide.getEvenDistributedPoints(MAX_TURN_POINTS_COUNT + 2);
        return tPts[id];
    }

    public function containsObject(obj:ObjectBase):Boolean{
        return _containedObjectNames.indexOf(obj.name) != -1;
    }

    public function get containedObjectNames():Vector.<String> {
        return _containedObjectNames;
    }

    public function get inSide():Line {
        return _inSide;
    }

    public function get outSide():Line {
        return _outSide;
    }

    override protected function onBeginInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(!target.controller.isRat)
            return;

        if(_containedObjectNames.indexOf(target.name) == -1)
            _containedObjectNames.push(target.name);

        if(_onBeginInteraction)
            _onBeginInteraction(waypoint, target);
    }

    override protected function onGoingInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(!target.controller.isRat)
            return;

        if(_onGoingInteraction)
            _onGoingInteraction(waypoint, target);
    }

    override protected function onEndInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(!target.controller.isRat)
            return;

        VectorUtil.removeElement(_containedObjectNames, target.name);

        if(_onEndInteraction)
            _onEndInteraction(waypoint, target);
    }
}
}
