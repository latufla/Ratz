/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 25.02.13
 * Time: 20:08
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gameplay {
import behaviors.BehaviorBase;
import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.Config;

import utils.nape.PhysEngineConnector;

public class WallItemBehavior extends BehaviorBase{
    public function WallItemBehavior() {
        super();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        PhysEngineConnector.instance.addInteractionListener(_controller.object, onBeginInteraction);
    }

    override public function stop():void{
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onBeginInteraction);

        super.stop();
    }

    override protected function onBeginInteraction(wall:ObjectBase, obj:ObjectBase):void{
        var c:ControllerBase = Config.field.getControllerByObject(obj);
        if(c.isRat){
            trace(obj.name + " just pushed the wall");
        }
    }
}
}
