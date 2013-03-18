/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package {

import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.events.Event;

import managers.WaypointManager;

import model.ObjectBase;
import model.RaceInfo;

import utils.Config;

import utils.nape.PhysEngineConnector;
import utils.VectorUtil;

public class Field {

    private var _controllers:Vector.<ControllerBase>;
    private var _raceInfo:RaceInfo;

    public function Field(raceInfo:RaceInfo) {
        _raceInfo = raceInfo;
        init();
    }

    private function init():void {
        Config.field = this;

        _controllers = new Vector.<ControllerBase>();
        PhysEngineConnector.instance.initField(this, _raceInfo.border);
        WaypointManager.instance.init(_raceInfo);

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
        c.startBehaviors();
    }

    public function remove(c:ControllerBase):void{
        c.stopBehaviors();
        PhysEngineConnector.instance.destroyObject(c.object);
        VectorUtil.removeElement(_controllers, c);
    }

    public function simulateStep(step:Number, debugView:* = null):void{
        PhysEngineConnector.instance.simulateStep(this, step, debugView);
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
            return e is bClass;
        });
    }
}
}
