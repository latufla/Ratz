/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 20.02.13
 * Time: 13:14
 * To change this template use File | Settings | File Templates.
 */
package behaviors.core {
import behaviors.BehaviorBase;
import behaviors.control.ControlBehavior;

import utils.Config;

public class StatDisplayBehavior extends BehaviorBase{
    public function StatDisplayBehavior() {
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        Config.ammunitionPanel.data = _controller.object.ammunition;
    }
}
}
