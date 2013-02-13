/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 06.02.13
 * Time: 22:06
 * To change this template use File | Settings | File Templates.
 */
package behaviors {
import behaviors.control.ControlBehavior;

import controller.ControllerBase;

import flash.display.Stage;

import flash.events.Event;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import model.ObjectBase;

import utils.RPolygon;
import utils.RShape;

public class TrapBehavior extends BehaviorBase{

    private var _timeout:int = 1000;
    private var _timeoutId:uint;

    public function TrapBehavior() {
        super();
    }

    // use timer or starling Enter Frame
    override public function doStep():void {
        if(!_enabled)
            return;

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior || !controlBehavior.trap)
            return;

        applyTrap(_controller.object);
    }

    private function applyTrap(obj:ObjectBase):void {
        var trap:ObjectBase = new ObjectBase();
        trap.shapes = new <RShape>[new RPolygon(0, 0, 20, 20)];
        trap.position = obj.localToField(new Point(0, 41));
        trap.ammunition.health = 30;

        var trapController:ControllerBase = new ControllerBase();
        trapController.object = trap;
        trapController.addBehavior(new TrapItemBehavior());
        trapController.startBehaviors();
        Config.field.add(trapController);

        _enabled = false;
        _timeoutId = setTimeout(function():void{_enabled = true; clearTimeout(_timeoutId)},_timeout);
    }
}
}
