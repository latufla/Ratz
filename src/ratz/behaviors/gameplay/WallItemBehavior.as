/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 25.02.13
 * Time: 20:08
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.gameplay {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;
import core.utils.nape.PhysEngineConnector;

import ratz.utils.Config;

public class WallItemBehavior extends BehaviorBase{
    public function WallItemBehavior() {
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

    override protected function onBeginInteraction(wall:ObjectBase, obj:ObjectBase):void{
        var c:ControllerBase = Config.fieldController.getControllerByObject(obj);
        if(c.isRat){
            trace(obj.name + " just pushed the wall");
        }
    }
}
}
