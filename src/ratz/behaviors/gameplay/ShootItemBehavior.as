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

import flash.geom.Point;

import ratz.Ratz;
import ratz.model.RObjectBase;
import ratz.utils.Config;

public class ShootItemBehavior extends BehaviorBase{
    public function ShootItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        _controller.object.addInteractionListeners(onBeginInteraction);
    }

    override public function stop():void{
        _controller.object.removeInteractionListeners();

        super.stop();
    }

    override protected function onBeginInteraction(shot:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(ratC.isRat){
            var o:RObjectBase = obj as RObjectBase;
            var s:RObjectBase = shot as RObjectBase;
            o.ammunition.health -= s.ammunition.health;
            var pos:Point = shot.position;
            GuiUtil.showPopupText(Ratz.STAGE, new Point(pos.x, pos.y), "-" + s.ammunition.health, 30, 0xFF0000);
        }

        if(!obj.isPseudo)
            Config.fieldController.remove(shot.controller);
    }
}
}
