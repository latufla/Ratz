/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:23
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;

import core.controller.ControllerBase;

import flash.geom.Point;

import core.model.ObjectBase;

import ratz.Ratz;

import ratz.utils.Config;

import core.utils.GuiUtil;

import core.utils.nape.PhysEngineConnector;

public class TrapItemBehavior extends BehaviorBase{
    public function TrapItemBehavior() {
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

    override protected function onBeginInteraction(trap:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;

        obj.ammunition.health -= trap.ammunition.health;

        var pos:Point = trap.position;
        GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "-" + trap.ammunition.health, 30, 0xFF0000);

        Config.fieldController.remove(trap.controller);
    }
}
}
