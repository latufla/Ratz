/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package behaviors {
import controller.ControllerBase;

import model.ObjectBase;

import utils.PhysEngineConnector;

public class ShootItemBehavior extends BehaviorBase{
    public function ShootItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onInteraction);
    }

    override public function stop():void{
        super.stop();

        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onInteraction);
    }

    private function onInteraction(shotItem:ObjectBase, target:ObjectBase):void{
        target.ammunition.health -= shotItem.ammunition.health;
    }
}
}
