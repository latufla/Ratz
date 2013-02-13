/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package {
import controller.ControllerBase;

import flash.display.BitmapData;

import flash.events.Event;
import flash.geom.Point;

import utils.PhysEngineConnector;

public class Field {

    private var _position:Point;
    private var _controllers:Vector.<ControllerBase>;
    public function Field(position:Point, border:BitmapData) {
        _position = position.clone();

        init(border);
    }

    private function init(border:BitmapData):void {
        _controllers = new Vector.<ControllerBase>();
        PhysEngineConnector.instance.initField(this, border);

        Ratz.STAGE.addEventListener(Event.ENTER_FRAME, onEFDoBehaviorsStep);
    }

    private function onEFDoBehaviorsStep(e:Event):void {
        for each(var p:ControllerBase in _controllers){
            p.doBehaviorsStep();
        }
    }

    public function add(c:ControllerBase):void{
        PhysEngineConnector.instance.addObjectToField(this, c.object);
        _controllers.push(c);

        trace(this, c.object);
    }

    public function simulateStep(step:Number, debugView:* = null):void{
        PhysEngineConnector.instance.simulateStep(this, step, debugView);
    }

    public function get position():Point {
        return _position;
    }
}
}
