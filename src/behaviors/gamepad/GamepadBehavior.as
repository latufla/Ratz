/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:48
 * To change this template use File | Settings | File Templates.
 */
package behaviors.gamepad {
import behaviors.*;
import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.display.Stage;
import flash.events.KeyboardEvent;

public class GamepadBehavior extends BehaviorBase{
    // default keys
    private static const LEFT_KEY:uint = 37;
    private static const RIGHT_KEY:uint = 39;
    private static const RUN_KEY:uint = 16;
    private static const TRAP_KEY:uint = 67;
    private static const BOOST_KEY:uint = 88;
    private static const SHOOT_KEY:uint = 90;

    private var _keysLib:Array;
    private var _activeKeys:Array;

    public function GamepadBehavior() {
        init();
    }

    private function init():void {
        _keysLib = [LEFT_KEY, RIGHT_KEY, RUN_KEY, TRAP_KEY];
        _activeKeys = [];
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var stage:Stage = Ratz.STAGE;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    override public function stop():void{
        super.stop();

        var stage:Stage = Ratz.STAGE;
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    private function onKeyDown(e:KeyboardEvent):void {
        var key:uint = e.keyCode;
        if(_keysLib[key] == -1)
            return;

        _activeKeys[key] = true;
    }

    private function onKeyUp(e:KeyboardEvent):void {
        var key:uint = e.keyCode;
        if(_keysLib[key] == -1)
            return;

        _activeKeys[key] = false;
    }

    public function get leftKeyPressed():Boolean{
        return _activeKeys[LEFT_KEY];
    }

    public function get rightKeyPressed():Boolean{
        return _activeKeys[RIGHT_KEY];
    }

    public function get runKeyPressed():Boolean{
        return _activeKeys[RUN_KEY];
    }

    public function get trapKeyPressed():Boolean{
        return _activeKeys[TRAP_KEY];
    }

    public function get boostKeyPressed():Boolean{
        return _activeKeys[BOOST_KEY];
    }

    public function get shootKeyPressed():Boolean{
        return _activeKeys[SHOOT_KEY];
    }
}
}
