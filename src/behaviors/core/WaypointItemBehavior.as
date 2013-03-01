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

    public static const TOP_SIDE:uint = 0;
    public static const LEFT_SIDE:uint = 1;
    public static const BOTTOM_SIDE:uint = 2;
    public static const RIGHT_SIDE:uint = 3;

    private var _onBeginInteraction:Function;
    private var _onGoingInteraction:Function;
    private var _onEndInteraction:Function;

    private var _containedObjectNames:Vector.<String>;
    private var _registeredObjectNames:Vector.<String>;

    private var _inSide:Line = new Line(new Point(), new Point());
    private var _outSide:Line = new Line(new Point(), new Point());

    private var _turnPoint:Point;
    private var _directionToNext:Point;

    public function WaypointItemBehavior(onBeginInteraction:Function, onGoingInteraction:Function = null, onEndInteraction:Function = null) {
        super();

        _onBeginInteraction = onBeginInteraction;
        _onGoingInteraction = onGoingInteraction;
        _onEndInteraction = onEndInteraction;

        init();
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

    public function get directionToNext():Point {
        return _directionToNext;
    }

    public function set directionToNext(value:Point):void {
        _directionToNext = value;
    }

    public function get turnPoint():Point {
        return _turnPoint;
    }

    public function set turnPoint(value:Point):void {
        _turnPoint = value;
    }

    public function get containedObjectNames():Vector.<String> {
        return _containedObjectNames;
    }

    public function get inSide():Line {
        return _inSide;
    }

    public function set inSide(value:Line):void {
        _inSide = value;
    }

    public function get outSide():Line {
        return _outSide;
    }

    public function set outSide(value:Line):void {
        _outSide = value;
    }
}
}
