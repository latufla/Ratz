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

import flash.utils.setTimeout;

import managers.WaypointManager;

import model.ObjectBase;

import utils.NapeUtil;

public class AIControlBehavior extends ControlBehavior{

    private var _run:Boolean;
    private var _turnLeft:Boolean;
    public function AIControlBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        WaypointManager.instance.addEventListener(CustomEvent.WAYPOINT_VISIT, onWaypointVisit);
        setInterval(function():void{_turnLeft = false;}, 3000);
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
        setTimeout(function():void{
            var justVisitedWp:ObjectBase = e.data.waypoint;
            var nextToVisitWp:ObjectBase = e.data.nextToVisitWaypoint;
            var dir:Point = justVisitedWp.getDirectionTo(nextToVisitWp);
            e.data.object.rotation = NapeUtil.angleFromVector(dir);
        }, 200);
    }

    override public function get turnLeft():Boolean{
        return _turnLeft;
    }

//
//    override public function get turnRight():Boolean{
//        return ;
//    }

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
