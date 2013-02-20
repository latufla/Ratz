/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:23
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.Config;

import utils.GuiUtil;

import utils.PhysEngineConnector;

public class TrapItemBehavior extends BehaviorBase{
    public function TrapItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        _controller.object.isPseudo = true;

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onInteraction);
    }

    override public function stop():void{
        _controller.object.isPseudo = false;
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onInteraction);

        super.stop();
    }

    private function onInteraction(trap:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;

        obj.ammunition.health -= trap.ammunition.health;

        var pos:Point = trap.position;
        GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "-" + trap.ammunition.health, 20, 0xFF0000);

        Config.field.remove(trap.controller);
    }
}
}
