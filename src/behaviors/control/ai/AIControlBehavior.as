/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:48
 * To change this template use File | Settings | File Templates.
 */
package behaviors.control.ai {
import behaviors.control.ControlBehavior;

import controller.ControllerBase;

import event.CustomEvent;

import flash.geom.Point;

import flash.utils.setInterval;

import managers.WaypointManager;

import model.ObjectBase;

import utils.NapeUtil;

public class AIControlBehavior extends ControlBehavior{

    private var _run:Boolean;
    private var _turnLeft:Boolean;
    private var _turnRight:Boolean;

    private var _rotateTo:Number;

    public function AIControlBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        WaypointManager.instance.addEventListener(CustomEvent.WAYPOINT_VISIT, onWaypointVisit);
    }

    override public function stop():void{
        WaypointManager.instance.removeEventListener(CustomEvent.WAYPOINT_VISIT, onWaypointVisit);
        super.stop();
    }

    override public function doStep():void{
        if(!_enabled)
            return;

        _run = true;
        resolveRotation();
    }

    private function resolveRotation():void {
        var rotationDiff:Number = _rotateTo - _controller.object.rotation + 2 * Math.PI;
        if(Math.abs(_rotateTo - (_controller.object.rotation + 2*Math.PI)) > 0.06){
            _turnLeft = _rotateTo - (_controller.object.rotation + 2*Math.PI) < 0;
            _turnRight = _rotateTo - (_controller.object.rotation + 2*Math.PI) > 0;
        } else{
            _turnLeft = _turnRight = false;
        }
    }

    private function resolveOptionalActions():void{
        resolveShoot();
        resolveBoost();
        resolveTrap();
    }

    private function resolveShoot():void {

    }

    private function resolveTrap():void {

    }

    private function resolveBoost():void {

    }

    private function onWaypointVisit(e:CustomEvent):void {
        var justVisitedWp:ObjectBase = e.data.waypoint;
        var nextToVisitWp:ObjectBase = e.data.nextToVisitWaypoint;
        var dir:Point = justVisitedWp.getDirectionTo(nextToVisitWp);
        _rotateTo = NapeUtil.angleFromVector(dir);
    }

    override public function get turnLeft():Boolean{
        return _turnLeft;
    }

    override public function get turnRight():Boolean{
        return _turnRight;
    }

    override public function get run():Boolean{
        return _run;
    }

//    override public function get trap():Boolean{
//        return ;
//    }
//
//    override public function get boost():Boolean{
//        return ;
//    }
//
//    override public function get shoot():Boolean{
//        return ;
//    }
}
}
