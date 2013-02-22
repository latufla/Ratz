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

import utils.nape.PhysEngineConnector;

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

    private function onInteraction(shot:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(ratC.isRat)
            obj.ammunition.health -= shot.ammunition.health;

        if(!obj.isPseudo)
            Config.field.remove(shot.controller);
    }
}
}
