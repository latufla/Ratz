/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:27
 * To change this template use File | Settings | File Templates.
 */
package controller {
import behaviors.BehaviorBase;
import behaviors.control.ControlBehavior;
import behaviors.gameplay.WallItemBehavior;

import model.ObjectBase;

import utils.VectorUtil;

import view.ViewBase;

public class ControllerBase {

    protected var _view:ViewBase;
    protected var _object:ObjectBase;

    protected var _behaviors:Vector.<BehaviorBase>;

    public function ControllerBase() {
        init();
    }

    private function init():void {
        _behaviors ||= new Vector.<BehaviorBase>();
    }

    public static function create(obj:ObjectBase, behaviors:Vector.<BehaviorBase> = null):ControllerBase{
        var c:ControllerBase = new ControllerBase();
        c.object = obj;
        for each(var p:BehaviorBase in behaviors){
            c.addBehavior(p);
        }

        return c;
    }

    public function addBehavior(b:BehaviorBase):void{
        if(!b)
            throw new Error("can`t add behavior: null");

        _behaviors.push(b);
    }

    public function removeBehavior(b:BehaviorBase):void{
        b.stop();
        VectorUtil.removeElement(b, _behaviors);
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

    // not class but concrete behavior
    public function hasBehavior(b:BehaviorBase):Boolean{
        return _behaviors.indexOf(b) != -1;
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

    public function get isRat():Boolean{
        return getBehaviorByClass(ControlBehavior);
    }

    public function get isWall():Boolean{
        return getBehaviorByClass(WallItemBehavior);
    }
}
}
