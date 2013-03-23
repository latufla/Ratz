package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import ratz.behaviors.control.ControlBehavior;
import flash.geom.Point;
import core.model.ObjectBase;

public class MoveBehavior extends BehaviorBase{

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

        if(controlBehavior.turnRight)
            applyTurnRight(obj);

        if(controlBehavior.turnLeft)
            applyTurnLeft(obj);

        obj.applyTerrainFriction(0.2, 0.01);
    }

    private function applyRun(obj:ObjectBase):void{
        obj.applyImpulse(new Point(0, -10));
    }

    private function applyTurnLeft(obj:ObjectBase):void{
        obj.applyAngularImpulse(-150);
    }

    private function applyTurnRight(obj:ObjectBase):void{
        obj.applyAngularImpulse(150);
    }
}
}
