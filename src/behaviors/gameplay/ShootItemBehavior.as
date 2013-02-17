/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import model.ObjectBase;

import utils.Config;

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
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onInteraction);

        super.stop();
    }

    private function onInteraction(shot:ObjectBase, rat:ObjectBase):void{
        var ratC:ControllerBase = Config.field.getControllerByObject(rat);
        if(!ratC.isRat)
            return;

        rat.ammunition.health -= shot.ammunition.health;
        Config.field.remove(Config.field.getControllerByObject(shot));
    }
}
}
