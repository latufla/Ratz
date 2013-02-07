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

    public var _controller:ControllerBase;
    public function BehaviorBase() {
    }

    public function start(c:ControllerBase):void{
        _controller = c;
        trace("start ", this);
    }

    public function stop():void{
        _controller = null;
        trace("stop ", this);
    }
}
}
