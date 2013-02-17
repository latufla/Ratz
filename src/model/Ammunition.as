/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:31
 * To change this template use File | Settings | File Templates.
 */
package model {
public class Ammunition {

    private var _shots:uint = 5;
    private var _boost:uint = 5;
    private var _traps:uint = 5;

    private var _health:int = 100;

    public function Ammunition() {
    }


    public function get shots():uint {
        return _shots;
    }

    public function set shots(value:uint):void {
        _shots = value;
    }

    public function get boost():uint {
        return _boost;
    }

    public function set boost(value:uint):void {
        _boost = value;
    }

    public function get traps():uint {
        return _traps;
    }

    public function set traps(value:uint):void {
        _traps = value;
    }

    public function get health():int {
        return _health;
    }

    public function set health(value:int):void {
        _health = value > 0 ? value : 0;
    }
}
}
