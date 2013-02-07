/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:28
 * To change this template use File | Settings | File Templates.
 */
package behaviors {
import controller.ControllerBase;

public class BehaviorBase {

    protected var _controller:ControllerBase;
    protected var _enabled:Boolean = true;

    public function BehaviorBase() {
    }

    public function start(c:ControllerBase):void{
        _controller = c;
    }

    public function stop():void{
        _controller = null;
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        _enabled = value;
    }
}
}
