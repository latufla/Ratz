/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.03.13
 * Time: 14:35
 * To change this template use File | Settings | File Templates.
 */
package core.controller {
import core.behaviors.BehaviorBase;
import core.model.ObjectBase;
import core.utils.VectorUtil;
import core.utils.nape.PhysEngineConnector;

public class FieldController extends ControllerBase{

    protected var _controllers:Vector.<ControllerBase>;

    public function FieldController() {
        super();
        init();
    }

    protected function init():void {
        _controllers = new Vector.<ControllerBase>();
        PhysEngineConnector.instance.initField(this);
    }

    public function add(c:ControllerBase):void{
        PhysEngineConnector.instance.addObjectToField(this, c.object);
        _controllers.push(c);
        c.startBehaviors();
    }

    public function remove(c:ControllerBase):void{
        c.stopBehaviors();
        PhysEngineConnector.instance.destroyObject(c.object);
        VectorUtil.removeElement(_controllers, c);
    }

    public function doStep(step:Number, debugView:* = null):void{
        for each(var p:ControllerBase in _controllers){
            p.doBehaviorsStep();
        }

        PhysEngineConnector.instance.doStep(this, step, debugView);
    }

    public function getControllerByObject(obj:ObjectBase):ControllerBase{
        for each(var p:ControllerBase in _controllers){
            if(p.object == obj)
                return p;
        }

        return null;
    }

    public function getControllerByBehavior(b:BehaviorBase):ControllerBase{
        for each(var p:ControllerBase in _controllers){
            if(p.hasBehavior(b))
                return p;
        }

        return null;
    }

    public function getControllersByBehaviorClass(bClass:Class):Vector.<ControllerBase>{
        return _controllers.filter(function (e:ControllerBase, i:int, v:Vector.<ControllerBase>):Boolean{
            return e.getBehaviorByClass(bClass);
        });
    }

}
}
