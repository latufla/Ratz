/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:48
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.control.ai {
import ratz.behaviors.control.ControlBehavior;

import core.controller.ControllerBase;

import core.event.CustomEvent;

import flash.geom.Point;
import ratz.managers.WaypointManager;

import core.model.ObjectBase;

import core.utils.MathUtil;

public class AIControlBehavior extends ControlBehavior{

    private var _run:Boolean;
    private var _turnLeft:Boolean;
    private var _turnRight:Boolean;

    public function AIControlBehavior() {
        super();
    }

    override public function stop():void{
        super.stop();
        _run = _turnLeft = _turnRight = false;
    }

    override public function doStep():void{
        if(!_enabled)
            return;

        _run = true; // use raycast to define if wall is close
        resolveGeneralRoute();
        resolveDodgeRoute();
        resolveOptionalActions();
    }

    // resolve main route as it`s kinematic
    private function resolveGeneralRoute():void {
        var directionToRotate:Point = WaypointManager.instance.getActualDirection(_controller.object);
        if(!directionToRotate)
            return;

        var curRotationVector:Point = MathUtil.vectorFromAngle(_controller.object.rotation);
        var angleDiff:Number = MathUtil.getAngleBetween(directionToRotate, curRotationVector);
        if(Math.abs(angleDiff) > 0.06){
            _turnLeft = angleDiff > 0;
            _turnRight = angleDiff < 0;
        } else{
            _turnLeft = _turnRight = false;
        }
    }

    // dodge from traps and other rats (all, what is behind)
    private function resolveDodgeRoute():void {

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
