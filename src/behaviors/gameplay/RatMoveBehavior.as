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

// note this is a rat
public class RatMoveBehavior extends BehaviorBase{

    public static const STOPPAGE_MIN_VEL:int = 50;
    public static const IDLE_ROTATION:Number = Math.PI / 30;

    public function RatMoveBehavior() {
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
            applyTurnRight(obj, controlBehavior.run);

        if(controlBehavior.turnLeft)
            applyTurnLeft(obj, controlBehavior.run);
    }

    private function applyRun(obj:ObjectBase):void{
        obj.applyImpulse(new Point(0, -10));
    }

    private function applyStoppage(obj:ObjectBase):void {
        var velM:int = obj.velocity.length; // whatever is small
        if(velM > 0 && !velocitySufficient(obj))
            obj.velocity = new Point();
    }

    private function applyTurnLeft(obj:ObjectBase, run:Boolean):void{
        if(run || velocitySufficient(obj)){
            obj.applyAngularImpulse(-150);
        } else {
            obj.rotation -= IDLE_ROTATION; // TODO: make correction when Math.PI/2 close
        }
    }

    private function applyTurnRight(obj:ObjectBase, run:Boolean):void{
        if(run || velocitySufficient(obj)){
            obj.applyAngularImpulse(150);
        } else {
            obj.rotation += IDLE_ROTATION;
        }
    }

    private function velocitySufficient(obj:ObjectBase):Boolean{
        return obj.velocity.length >= STOPPAGE_MIN_VEL;
    }
}
}
