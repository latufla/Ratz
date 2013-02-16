/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 06.02.13
 * Time: 22:06
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.*;
import behaviors.control.ControlBehavior;

import controller.ControllerBase;

import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import model.ObjectBase;

import utils.Config;
import utils.RMaterial;

import utils.RPolygon;
import utils.RShape;

public class TrapBehavior extends BehaviorBase{

    private var _timeout:int = 1000;
    private var _timeoutId:uint;

    public function TrapBehavior() {
        super();
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior || !controlBehavior.trap)
            return;

        applyTrap(_controller.object);
    }

    private function applyTrap(obj:ObjectBase):void {
        var pos:Point = obj.localToField(new Point(0, 41));
        var trap:ObjectBase = ObjectBase.create(pos, new <RShape>[new RPolygon(0, 0, 20, 20)], new RMaterial(), 1);
        trap.ammunition.health = 30;

        var trapController:ControllerBase = ControllerBase.create(trap, new <BehaviorBase>[new TrapItemBehavior()]);
        trapController.startBehaviors();
        Config.field.add(trapController);

        _enabled = false;
        _timeoutId = setTimeout(function():void{_enabled = true; clearTimeout(_timeoutId)},_timeout);
    }
}
}
