/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package model {
import controller.ControllerBase;

import flash.utils.Dictionary;

import utils.PhysEngineConnector;

public class Field {

    private var _controllers:Vector.<ControllerBase>;
    public function Field() {
        init();
    }

    private function init():void {
        _controllers = new Vector.<ControllerBase>();
        PhysEngineConnector.instance.initField(this);
    }

    public function add(c:ControllerBase):void{
        PhysEngineConnector.instance.addObjectToField(this, c.object);
        _controllers.push(c);

        trace(this, c.object);
    }

    public function simulateStep(step:Number, debugView:* = null):void{
        PhysEngineConnector.instance.simulateStep(this, step, debugView);
    }
}
}
