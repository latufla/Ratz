/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 20:48
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors.control.user {
import core.behaviors.BehaviorBase;
import ratz.behaviors.control.ControlBehavior;
import ratz.behaviors.gamepad.GamepadBehavior;

import core.controller.ControllerBase;

public class UserControlBehavior extends ControlBehavior{

    private var _gamepad:GamepadBehavior;

    public function UserControlBehavior() {
        init();
    }

    private function init():void {
        _gamepad = new GamepadBehavior();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);
        _gamepad.start(c);
    }

    override public function stop():void{
        super.stop();
        _gamepad.stop();
    }

    override public function get turnLeft():Boolean{
        return _gamepad.leftKeyPressed;
    }

    override public function get turnRight():Boolean{
        return _gamepad.rightKeyPressed;
    }

    override public function get run():Boolean{
        return _gamepad.runKeyPressed;
    }

    override public function get trap():Boolean{
        return _gamepad.trapKeyPressed;
    }

    override public function get boost():Boolean{
        return _gamepad.boostKeyPressed;
    }

    override public function get shoot():Boolean{
        return _gamepad.shootKeyPressed;
    }
}
}
