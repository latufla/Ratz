/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 07.02.13
 * Time: 13:19
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.utils.nape.CustomMaterial;
import core.utils.nape.CustomPolygon;
import core.utils.nape.CustomShape;

import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ratz.behaviors.control.ControlBehavior;
import ratz.model.RObjectBase;
import ratz.utils.Config;

public class ShootBehavior extends BehaviorBase {

    private var _timeout:int = 1000;
    private var _timeoutId:uint;

    public function ShootBehavior() {
    }

    override public function doStep(step:Number):void {
        if(!_enabled)
            return;

        super.doStep(step);

        var controlBehavior:ControlBehavior = _controller.getBehaviorByClass(ControlBehavior) as ControlBehavior;
        if(!controlBehavior)
            return;

        var obj:RObjectBase = _controller.object as RObjectBase;
        if(controlBehavior.shoot && obj.ammunition.shots > 0)
            applyShoot(obj);
    }

    private function applyShoot(obj:RObjectBase):void {
        obj.ammunition.shots--;

        var pos:Point = obj.localToField(new Point(0, -41));
        var shot:RObjectBase = RObjectBase.create("", pos, new <CustomShape>[new CustomPolygon(0, 0, 6, 6)], new CustomMaterial(), 1);
        shot.ammunition.health = 20;
        shot.velocity = obj.localVecToField(new Point(0, -500));

        var shotController:ControllerBase = ControllerBase.create(shot, new <BehaviorBase>[new ShootItemBehavior()]);
        Config.fieldController.add(shotController);

        _enabled = false;
        _timeoutId = setTimeout(function():void{_enabled = true; clearTimeout(_timeoutId)},_timeout);
    }
}
}
