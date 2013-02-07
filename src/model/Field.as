/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package model {
import utils.PhysEngineConnector;

public class Field {

    public function Field() {
        init();
    }

    private function init():void {
        PhysEngineConnector.instance.initField(this);
    }

    public function add(obj:RObjectBase):void{
        PhysEngineConnector.instance.addObjectToField(this, obj);
        trace(this, obj);
    }

    public function simulateStep(step:Number, debugView:* = null):void{
        PhysEngineConnector.instance.simulateStep(this, step, debugView);
    }
}
}
