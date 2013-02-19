/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:17
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;
import behaviors.control.ControlBehavior;
import behaviors.gamepad.GamepadBehavior;
import behaviors.control.user.UserControlBehavior;

import controller.ControllerBase;

import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;

import model.ObjectBase;

public class MoveBehavior extends BehaviorBase{

    private static const STOPPAGE_MIN_VEL:int = 40;
    private static const NULL_VELOCITY:Point = new Point();
    public function MoveBehavior() {
        super();
    }

    override public function doStep():void{
        if(!_enabled)
            return;

        super.doStep();

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        var obj:ObjectBase = _controller.object;
        if(controlBehavior.run)
            applyRun(obj);
        else
            applyStoppage(obj);

        if(controlBehavior.turnRight)
            applyTurnRight(obj);

        if(controlBehavior.turnLeft)
            applyTurnLeft(obj);

        obj.applyTerrainFriction(0.2, 0.01);
    }

    private function applyRun(obj:ObjectBase):void{
        obj.applyImpulse(new Point(0, -10));
    }

    private function applyStoppage(obj:ObjectBase):void {
        if(shouldNullVelocity(obj))
            obj.velocity = new Point(0, 0);
    }

    private function applyTurnLeft(obj:ObjectBase):void{
        obj.applyAngularImpulse(-200);
    }

    private function applyTurnRight(obj:ObjectBase):void{
        obj.applyAngularImpulse(200);
    }

    private var _nullVel:Point = new Point();
    private function shouldNullVelocity(obj:ObjectBase):Boolean{
        var vel:Point = obj.velocity;
        return !vel.equals(NULL_VELOCITY) && Math.abs(vel.x) < STOPPAGE_MIN_VEL && Math.abs(vel.y) < STOPPAGE_MIN_VEL;
    }
}
}
