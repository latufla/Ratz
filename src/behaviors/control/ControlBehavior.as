/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 13.01.13
 * Time: 12:45
 * To change this template use File | Settings | File Templates.
 */
package behaviors.control {
import behaviors.BehaviorBase;

public class ControlBehavior extends BehaviorBase {
    public function ControlBehavior() {
    }

    public function get turnLeft():Boolean{
        return false;
    }

    public function get turnRight():Boolean{
        return false;
    }

    public function get run():Boolean{
        return false;
    }

    public function get trap():Boolean{
        return false;
    }

    public function get boost():Boolean{
        return false;
    }
}
}
