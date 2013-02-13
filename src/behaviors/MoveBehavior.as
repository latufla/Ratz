/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:17
 * To change this template use File | Settings | File Templates.
 */
package behaviors {
import behaviors.control.ControlBehavior;
import behaviors.gamepad.GamepadBehavior;
import behaviors.control.user.UserControlBehavior;

import controller.ControllerBase;

import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;

import model.ObjectBase;

public class MoveBehavior extends BehaviorBase{
    public function MoveBehavior() {
    }

    override public function doStep():void{
        if(!_enabled)
            return;

        super.doStep();

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        if(controlBehavior.run)
            applyRun(_controller.object);

        if(controlBehavior.turnRight)
            applyTurnRight(_controller.object);

        if(controlBehavior.turnLeft)
            applyTurnLeft(_controller.object);
    }

    private function applyRun(obj:ObjectBase):void{
        obj.applyImpulse(new Point(0, -10));
    }

    private function applyTurnLeft(obj:ObjectBase):void{
        var velocity:Point = obj.velocity;
        if((Math.abs(velocity.x) > 10 || Math.abs(velocity.y) > 10))
            obj.applyAngularImpulse(-150);
    }

    private function applyTurnRight(obj:ObjectBase):void{
        var velocity:Point = obj.velocity;
        if((Math.abs(velocity.x) > 10 || Math.abs(velocity.y) > 10))
            obj.applyAngularImpulse(150);
    }
}
}
