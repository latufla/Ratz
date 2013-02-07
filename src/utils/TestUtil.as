/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 18:09
 * To change this template use File | Settings | File Templates.
 */
package utils {
import behaviors.BoostBehavior;
import behaviors.gamepad.GamepadBehavior;
import behaviors.ShootItemBehavior;
import behaviors.TrapItemBehavior;

import controller.ControllerBase;

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
        trace("behaviors: ", ratC.behaviors);
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
