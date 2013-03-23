/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:31
 * To change this template use File | Settings | File Templates.
 */
package core.model {
public class Ammunition {

    private var _shots:int = 2;
    private var _boost:int = 2;
    private var _traps:int = 2;

    private var _health:int = 100;

    public function Ammunition() {
    }


    public function get shots():int {
        return _shots;
    }

    public function set shots(value:int):void {
        _shots = value > 0 ? value : 0;
    }

    public function get boost():int {
        return _boost;
    }

    public function set boost(value:int):void {
        _boost = value > 0 ? value : 0;
    }

    public function get traps():int {
        return _traps;
    }

    public function set traps(value:int):void {
        _traps = value > 0 ? value : 0;
    }

    public function get health():int {
        return _health;
    }

    public function set health(value:int):void {
        _health = value > 0 ? value : 0;
    }
}
}
