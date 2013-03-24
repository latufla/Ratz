/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:20
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;

import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ratz.behaviors.control.ControlBehavior;
import ratz.model.RObjectBase;

public class BoostBehavior extends BehaviorBase{

    private var _applyTime:int = 2000;
    private var _applyTimeoutId:uint;
    private var _applying:Boolean = false;

    private var _timeout:int = 3000;
    private var _timeoutId:uint;

    public function BoostBehavior() {
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        super.doStep();

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        var obj:RObjectBase = _controller.object as RObjectBase;
        if(_applying || (controlBehavior.boost && obj.ammunition.boost > 0))
            applyBoost(obj);
    }

    private function applyBoost(obj:RObjectBase):void {
        obj.applyImpulse(new Point(0, -10));

        if(_applying)
            return;

        obj.ammunition.boost--;

        // TODO: find better decision
        _applying = true;
        _applyTimeoutId = setTimeout(function():void{
            _applying = false;
            clearTimeout(_applyTimeoutId);

            _enabled = false;
            _timeoutId = setTimeout(function():void{_enabled = true; clearTimeout(_timeoutId)},_timeout);
        },_applyTime);
    }
}
}
