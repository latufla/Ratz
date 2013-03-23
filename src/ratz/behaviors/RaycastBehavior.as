/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 27.02.13
 * Time: 22:22
 * To change this template use File | Settings | File Templates.
 */
package ratz.behaviors {
import core.behaviors.BehaviorBase;

public class RaycastBehavior extends BehaviorBase{

    private static const RAY_LENGTH:uint = 200;
    private var _objAppearsCb:Function;

    public function RaycastBehavior(objAppearsCb:Function) {
        super();
        _objAppearsCb = objAppearsCb;
    }


    override public function doStep():void{
        if(!_enabled)
            return;

        super.doStep();
    }
}
}
