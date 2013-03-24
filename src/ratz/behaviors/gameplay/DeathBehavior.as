/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 20.02.13
 * Time: 14:15
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import core.utils.GuiUtil;

import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ratz.Ratz;
import ratz.controller.RControllerBase;
import ratz.managers.WaypointManager;
import ratz.model.RObjectBase;
import ratz.utils.Config;

public class DeathBehavior extends BehaviorBase{

    private var _recoverTimeout:Number = 1000;
    private var _recoverId:uint;

    public function DeathBehavior() {
    }

    override public function doStep(step:Number):void {
        if(!_enabled)
            return;

        super.doStep(step);

        var obj:RObjectBase = _controller.object as RObjectBase;
        if(obj.ammunition.health <=0 && obj.controller)
            applyDeath(obj);
    }

    // TODO: think about standart clone
    private function applyDeath(obj:RObjectBase):void {
        var pos:Point = obj.position;
        GuiUtil.showStaticText(Ratz.STAGE, new Point(pos.x, pos.y), "BAAAAANG!!!", 30, 0xFF0000);

        var recoveryObj:RObjectBase = RObjectBase.create(obj.libDesc, obj.position, obj.shapes, obj.material, obj.interactionGroup);
        recoveryObj.name = obj.name;
        recoveryObj.ammunition = obj.ammunition;
        var recoveryC:RControllerBase = RControllerBase.create(recoveryObj, obj.controller.behaviors);
        Config.fieldController.remove(obj.controller);

        _recoverId = setTimeout(function ():void{
            clearTimeout(_recoverId);

            WaypointManager.instance.correctToNextWaypointWhenRespawn(recoveryObj);
            obj.ammunition.health = 100;
            Config.fieldController.add(recoveryC);
        }, _recoverTimeout);
    }

}
}
