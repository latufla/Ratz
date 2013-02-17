/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:20
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;
import behaviors.control.ControlBehavior;

import controller.ControllerBase;

import flash.display.Stage;

import flash.events.Event;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import model.ObjectBase;

public class BoostBehavior extends BehaviorBase{

    private var _applyInterval:int = 2000;
    private var _applyTimeoutId:uint;
    private var _applying:Boolean = false;

    private var _timeout:int = 3000;
    private var _timeoutId:uint;

    public function BoostBehavior() {
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        if((controlBehavior.boost && _controller.object.ammunition.boost > 0) || _applying)
            applyBoost(_controller.object);
    }

    private function applyBoost(obj:ObjectBase):void {
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
        },_applyInterval);
    }
}
}
