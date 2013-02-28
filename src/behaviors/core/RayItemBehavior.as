/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 27.02.13
 * Time: 22:54
 * To change this template use File | Settings | File Templates.
 */
package behaviors.core {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import model.ObjectBase;

import utils.nape.PhysEngineConnector;

public class RayItemBehavior extends BehaviorBase{
    public function RayItemBehavior() {
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

    override protected function onInteraction(ray:ObjectBase, obj:ObjectBase):void{
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;

    }

}
}
