/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:23
 * To change this template use File | Settings | File Templates.
 */
package behaviors {
import controller.ControllerBase;

import model.RObjectBase;

import utils.PhysEngineConnector;

public class TrapBehavior extends BehaviorBase{
    public function TrapBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        _controller.object.isPseudo = true;

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onInteraction);
    }

    override public function stop():void{
        super.stop();
        _controller.object.isPseudo = false;

        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onInteraction);
    }

    private function onInteraction(trap:RObjectBase, target:RObjectBase):void{
        target.ammunition.health -= trap.ammunition.health;
    }
}
}
