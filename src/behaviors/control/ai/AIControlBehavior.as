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
import managers.WaypointManager;

import model.ObjectBase;

import utils.MathUtil;

public class AIControlBehavior extends ControlBehavior{

    private var _run:Boolean;
    private var _turnLeft:Boolean;
    private var _turnRight:Boolean;

    private var _rotateToVector:Point;

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
        if(!_rotateToVector)
            return;

        var curRotationVector:Point = MathUtil.vectorFromAngle(_controller.object.rotation);
        var angleDiff:Number = MathUtil.getAngleBetween(_rotateToVector, curRotationVector);
        if(Math.abs(angleDiff) > 0.06){
            _turnLeft = angleDiff > 0;
            _turnRight = angleDiff < 0;
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
        _rotateToVector = justVisitedWp.getDirectionTo(nextToVisitWp);
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
