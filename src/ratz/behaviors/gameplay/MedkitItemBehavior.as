/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:58
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

public class MedkitItemBehavior extends BehaviorBase{
    public function MedkitItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var obj:ObjectBase = _controller.object;
        obj.isPseudo = true;
        obj.addInteractionListeners(onBeginInteraction);
    }

    override public function stop():void{
        var obj:ObjectBase = _controller.object;
        obj.isPseudo = false;
        obj.removeInteractionListeners();

        super.stop();
    }

    override protected function onBeginInteraction(medkit:ObjectBase, rat:ObjectBase):void{
        var ratC:ControllerBase = rat.controller;
        if(!ratC.isRat)
            return;

        rat.ammunition.health += medkit.ammunition.health;

        var pos:Point = medkit.position;
        GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "+" + medkit.ammunition.health);

        Config.fieldController.remove(medkit.controller);
    }
}
}
