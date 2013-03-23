/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 18:09
 * To change this template use File | Settings | File Templates.
 */
package ratz.utils {
import core.controller.ControllerBase;

import ratz.behaviors.gamepad.GamepadBehavior;
import ratz.behaviors.gameplay.BoostBehavior;
import ratz.behaviors.gameplay.ShootItemBehavior;
import ratz.behaviors.gameplay.TrapItemBehavior;

public class TestUtil {
    public function TestUtil() {
    }

    public static function startControllerTest():void{
        var ratC:ControllerBase = new ControllerBase();
        var gamepad:GamepadBehavior = new GamepadBehavior();
        ratC.addBehavior(new BoostBehavior());
        ratC.addBehavior(new ShootItemBehavior());
        ratC.addBehavior(new TrapItemBehavior());
        ratC.addBehavior(gamepad);

        trace("-------------");
        trace("startControllerTest");
        trace("-------------");
        trace("ratz.behaviors: ", ratC.behaviors);
        trace("-------------");
        trace("getBehaviorByClass: ", ratC.getBehaviorByClass(BoostBehavior));
        trace("-------------");
        ratC.startBehaviors();
        trace("-------------");
        ratC.removeBehavior(gamepad);
        trace("-------------");
        ratC.stopBehaviors();
    }
}
}
