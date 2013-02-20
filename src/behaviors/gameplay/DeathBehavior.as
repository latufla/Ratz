/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 20.02.13
 * Time: 14:15
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;
import controller.ControllerBase;

import flash.utils.clearTimeout;

import flash.utils.setTimeout;

import model.ObjectBase;

import utils.Config;

public class DeathBehavior extends BehaviorBase{

    private var _recoverTimeout:Number = 1000;
    private var _recoverId:uint;

    public function DeathBehavior() {
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        super.doStep();

        var obj:ObjectBase = _controller.object;
        if(obj.ammunition.health <=0 && obj.controller)
            applyDeath(obj);
    }

    // TODO: think about standart clone
    private function applyDeath(obj:ObjectBase):void {
        var recoveryObj:ObjectBase = ObjectBase.create(obj.position, obj.shapes, obj.material, obj.interactionGroup);
        recoveryObj.name = obj.name;
        recoveryObj.ammunition = obj.ammunition;
        var recoveryC:ControllerBase = ControllerBase.create(recoveryObj, obj.controller.behaviors);
        Config.field.remove(obj.controller);

        _recoverId = setTimeout(function ():void{
            clearTimeout(_recoverId);

            obj.ammunition.health = 100;
            Config.field.add(recoveryC);
        }, _recoverTimeout);
    }
}
}
