/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:17
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import core.model.ObjectBase;

import flash.geom.Point;

import ratz.behaviors.control.ControlBehavior;

// note this is a rat
public class RatMoveBehavior extends BehaviorBase{

    public static const STOPPAGE_MIN_VEL:int = 50;
    public static const IDLE_ROTATION:Number = Math.PI / 30;

    public function RatMoveBehavior() {
        super();
    }

    override public function doStep(step:Number):void {
        if(!_enabled)
            return;

        super.doStep(step);

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        var obj:ObjectBase = _controller.object;
        if(controlBehavior.run)
            applyRun(obj, step);
        else
            applyStoppage(obj);

        if(controlBehavior.turnRight)
            applyTurnRight(obj, step, controlBehavior.run);

        if(controlBehavior.turnLeft)
            applyTurnLeft(obj, step, controlBehavior.run);
    }

    private function applyRun(obj:ObjectBase, step:Number):void{
        obj.applyImpulse(new Point(0, -590 * step));
    }

    private function applyStoppage(obj:ObjectBase):void {
        var velM:int = obj.velocity.length; // whatever is small
        if(velM > 0 && !velocitySufficient(obj))
            obj.velocity = new Point();
    }

    private function applyTurnLeft(obj:ObjectBase, step:Number, run:Boolean):void{
        if(run || velocitySufficient(obj)){
            obj.applyAngularImpulse(-9000 * step);
        } else {
            obj.rotation -= IDLE_ROTATION; // TODO: make correction when Math.PI/2 close
        }
    }

    private function applyTurnRight(obj:ObjectBase, step:Number, run:Boolean):void{
        if(run || velocitySufficient(obj)){
            obj.applyAngularImpulse(9000 * step);
        } else {
            obj.rotation += IDLE_ROTATION;
        }
    }

    private function velocitySufficient(obj:ObjectBase):Boolean{
        return obj.velocity.length >= STOPPAGE_MIN_VEL;
    }
}
}
