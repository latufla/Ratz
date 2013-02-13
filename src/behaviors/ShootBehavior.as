/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 07.02.13
 * Time: 13:19
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

import model.RObjectBase;

import utils.RPolygon;

import utils.RShape;

public class ShootBehavior extends BehaviorBase {

    private var _timeout:int = 1000;
    private var _timeoutId:uint;

    public function ShootBehavior() {
    }

    // use timer or starling Enter Frame
    private function onEFApplyBehavior(e:Event):void {
        if(!_enabled)
            return;

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        if(controlBehavior.shoot)
            applyShoot(_controller.object);
    }

    private function applyShoot(obj:RObjectBase):void {
        var shot:RObjectBase = new RObjectBase();
        shot.shapes = new <RShape>[new RPolygon(0, 0, 6, 12)];
        shot.position = obj.localToField(new Point(0, -41));
        shot.ammunition.health = 20;
        shot.velocity = obj.localVecToField(new Point(0, -500));

        var shotController:ControllerBase = new ControllerBase();
        shotController.object = shot;
        shotController.addBehavior(new ShootItemBehavior());
        shotController.startBehaviors();
        Config.field.add(shotController);

        _enabled = false;
        _timeoutId = setTimeout(function():void{_enabled = true; clearTimeout(_timeoutId)},_timeout);
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var stage:Stage = Ratz.STAGE;
        stage.addEventListener(Event.ENTER_FRAME, onEFApplyBehavior);
    }

    override public function stop():void{
        super.stop();

        var stage:Stage = Ratz.STAGE;
        stage.removeEventListener(Event.ENTER_FRAME, onEFApplyBehavior);
    }
}
}
