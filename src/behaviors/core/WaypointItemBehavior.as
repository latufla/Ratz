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

import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.Config;
import utils.GuiUtil;
import utils.nape.PhysEngineConnector;
import utils.VectorUtil;

public class WaypointItemBehavior extends BehaviorBase {

    private var _onBeginInteraction:Function;
    private var _onGoingInteraction:Function;
    private var _onEndInteraction:Function;

    private var _registeredList:Vector.<String>;

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
        _registeredList = new Vector.<String>();
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
        _registeredList.push(obj.name);

        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 350), name, 30, 0x0000FF);
//        trace(name, obj.name);
    }

    public function unregister(obj:ObjectBase):void{
        VectorUtil.removeElement(_registeredList, obj.name);
    }

    public function unregisterAll():void{
        _registeredList = new Vector.<String>();
    }

    public function isRegistered(obj:ObjectBase):Boolean{
        return _registeredList.indexOf(obj.name) != -1;
    }

    override protected function onBeginInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(_onBeginInteraction)
            _onBeginInteraction(waypoint, target);
    }

    override protected function onGoingInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(_onGoingInteraction)
            _onGoingInteraction(waypoint, target);
    }

    override protected function onEndInteraction(waypoint:ObjectBase, target:ObjectBase):void{
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
}
}
