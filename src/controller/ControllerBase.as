/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:27
 * To change this template use File | Settings | File Templates.
 */
package controller {
import behaviors.BehaviorBase;

import model.ObjectBase;

import view.ViewBase;

public class ControllerBase {

    protected var _view:ViewBase
    protected var _object:ObjectBase;

    protected var _behaviors:Vector.<BehaviorBase>;

    public function ControllerBase() {
        init();
    }

    private function init():void {
        _behaviors ||= new Vector.<BehaviorBase>();
    }

    public function addBehavior(b:BehaviorBase):void{
        if(!b)
            throw new Error("can`t add behavior: null");

        _behaviors.push(b);
    }

    public function removeBehavior(b:BehaviorBase):void{
        var i:int = _behaviors.indexOf(b);

        if(i == -1)
            throw new Error("can`t remove behavior: no such behavior");

        _behaviors[i].stop();
        _behaviors.splice(i, 1);

        trace("remove ", b);
    }

    public function startBehaviors():void{
        for each(var p:BehaviorBase in _behaviors){
            p.start(this);
        }
    }

    public function stopBehaviors():void{
        for each(var p:BehaviorBase in _behaviors){
            p.stop();
        }
    }

    public function doBehaviorsStep():void{
        for each(var p:BehaviorBase in _behaviors){
            p.doStep();
        }
    }

    public function getBehaviorByClass(bClass:Class):BehaviorBase{
        for each(var p:BehaviorBase in _behaviors){
            if(p is bClass)
                return p;
        }

        return null;
    }

    public function get view():ViewBase {
        return _view;
    }

    public function set view(value:ViewBase):void {
        _view = value;
    }

    public function get object():ObjectBase {
        return _object;
    }

    public function set object(value:ObjectBase):void {
        _object = value;
    }

    // make private, use getBehaviorByClass()
    public function get behaviors():Vector.<BehaviorBase> {
        return _behaviors;
    }
}
}
