/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;
import core.utils.GuiUtil;
import core.utils.nape.PhysEngineConnector;

import flash.geom.Point;

import ratz.Ratz;
import ratz.utils.Config;

public class ShootItemBehavior extends BehaviorBase{
    public function ShootItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onBeginInteraction);
    }

    override public function stop():void{
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onBeginInteraction);

        super.stop();
    }

    override protected function onBeginInteraction(shot:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(ratC.isRat){
            obj.ammunition.health -= shot.ammunition.health;
            var pos:Point = shot.position;
            GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "-" + shot.ammunition.health, 30, 0xFF0000);
        }

        if(!obj.isPseudo)
            Config.fieldController.remove(shot.controller);
    }
}
}
