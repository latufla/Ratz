/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 20.02.13
 * Time: 13:14
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors {
import core.behaviors.BehaviorBase;

import ratz.model.RObjectBase;
import ratz.utils.Config;

public class StatDisplayBehavior extends BehaviorBase{
    public function StatDisplayBehavior() {
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        super.doStep();

        Config.ammunitionPanel.data = (_controller.object as RObjectBase).ammunition;
    }
}
}
