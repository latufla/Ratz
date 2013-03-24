/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.03.13
 * Time: 15:21
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;

import flash.geom.Point;

import ratz.RFieldController;
import ratz.Ratz;

import ratz.utils.Config;

public class CameraBehavior extends BehaviorBase{
    public function CameraBehavior() {
        super();
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        super.doStep();

        if(_controller)
            applyFocus(_controller as RFieldController);
    }

    private function applyFocus(c:RFieldController):void {
        var playerRatC:ControllerBase = c.playerRatController;
        if(!playerRatC)
            return;

        var pos:Point = playerRatC.object.position;
        Config.sceneController.view.x = Ratz.STAGE.stageWidth / 2 - pos.x;
        Config.sceneController.view.y = Ratz.STAGE.stageHeight / 2 - pos.y;

        Config.fieldController.view.x = Ratz.STAGE.stageWidth / 2 - pos.x;
        Config.fieldController.view.y = Ratz.STAGE.stageHeight / 2 - pos.y;
    }

}
}
