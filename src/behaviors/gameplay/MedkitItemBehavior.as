/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:58
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.Config;

import utils.GuiUtil;

import utils.nape.PhysEngineConnector;

public class MedkitItemBehavior extends BehaviorBase{
    public function MedkitItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        _controller.object.isPseudo = true;

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onBeginInteraction);
    }

    override public function stop():void{
        _controller.object.isPseudo = false;
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onBeginInteraction);

        super.stop();
    }

    override protected function onBeginInteraction(medkit:ObjectBase, rat:ObjectBase):void{
        var ratC:ControllerBase = rat.controller;
        if(!ratC.isRat)
            return;

        rat.ammunition.health += medkit.ammunition.health;

        var pos:Point = medkit.position;
        GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "+" + medkit.ammunition.health);

        Config.field.remove(medkit.controller);
    }
}
}
