/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 27.02.13
 * Time: 22:54
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;
import core.utils.nape.PhysEngineConnector;

public class RayItemBehavior extends BehaviorBase{
    public function RayItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var obj:ObjectBase = _controller.object;
        obj.isPseudo = true;
        obj.addInteractionListeners(onBeginInteraction);
    }

    override public function stop():void{
        var obj:ObjectBase = _controller.object;
        obj.isPseudo = false;
        obj.removeInteractionListeners();

        super.stop();
    }

    override protected function onBeginInteraction(ray:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;
    }

}
}
