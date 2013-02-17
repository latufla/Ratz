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

import utils.GuiUtil;

import utils.PhysEngineConnector;

public class MedkitItemBehavior extends BehaviorBase{
    public function MedkitItemBehavior() {
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

    private function onInteraction(medkit:ObjectBase, target:ObjectBase):void{
        target.ammunition.health += medkit.ammunition.health;

        var pos:Point = medkit.position;
        GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "+" + medkit.ammunition.health);
    }
}
}