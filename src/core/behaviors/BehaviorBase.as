/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:28
 * To change this template use File | Settings | File Templates.
 */
package core.behaviors {
import core.controller.ControllerBase;

import core.model.ObjectBase;

public class BehaviorBase{

    private var _id:int;
    private var _name:String;

    protected var _controller:ControllerBase;
    protected var _enabled:Boolean = false;

    public function BehaviorBase() {
    }

    public function start(c:ControllerBase):void{
        _controller = c;
        _enabled = true;
    }

    public function stop():void{
        _controller = null;
        _enabled = false;
    }

    // override if there is some EF behavior
    public function doStep():void{

    }

    // override if there is some ratz.event behavior
    protected function onBeginInteraction(obj:ObjectBase, target:ObjectBase):void{

    }

    protected function onGoingInteraction(obj:ObjectBase, target:ObjectBase):void{

    }

    protected function onEndInteraction(obj:ObjectBase, target:ObjectBase):void{

    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get id():int {
        return _id;
    }

    public function set id(value:int):void {
        _id = value;
    }

    public function toString():String{
        return "{ id: " + _id + ", name: " + _name + " }";
    }
}
}
