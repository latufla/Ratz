/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package ratz {

import core.behaviors.BehaviorBase;
import ratz.behaviors.control.ai.AIControlBehavior;
import ratz.behaviors.control.user.UserControlBehavior;
import ratz.behaviors.DebugStatDisplayBehavior;
import ratz.behaviors.StatDisplayBehavior;
import ratz.behaviors.gameplay.BoostBehavior;
import ratz.behaviors.gameplay.DeathBehavior;
import ratz.behaviors.gameplay.MedkitItemBehavior;
import ratz.behaviors.gameplay.RatMoveBehavior;
import ratz.behaviors.gameplay.ShootBehavior;
import ratz.behaviors.gameplay.TrapBehavior;

import core.controller.ControllerBase;

import flash.events.Event;
import flash.geom.Point;

import ratz.managers.WaypointManager;

import core.model.ObjectBase;
import ratz.model.RaceInfo;

import ratz.utils.Config;

import core.utils.nape.PhysEngineConnector;
import core.utils.VectorUtil;
import core.utils.nape.CustomMaterial;
import core.utils.nape.CustomPolygon;
import core.utils.nape.CustomShape;

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

        createItems(_raceInfo);
        createRats(_raceInfo);
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

            if(p.isRat)
                p.object.applyTerrainFriction(0.2, 0.01);
        }

        PhysEngineConnector.instance.doStep(this, step, debugView);

        if(!_raceInfo.raceIsFinished)
            _raceInfo.resolveRaceProgress();
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

    public function get ratControllers():Vector.<ControllerBase>{
        return getControllersByBehaviorClass(RatMoveBehavior);
    }

    private function createRats(raceInfo:RaceInfo):void {
        var finishWp:Object = raceInfo.finishWaypointDesc;
        if(!finishWp)
            return;

        var startPoints:Vector.<Point> = finishWp.inLine.getEvenDistributedPoints(6);
        startPoints.shift();
        startPoints.pop();

        var rat:ObjectBase;
        var ratC:ControllerBase;
        for(var i:uint = 0; i < raceInfo.racers.length; i++){
            rat = ObjectBase.create(new Point(startPoints[i].x + i * 10, startPoints[i].y + 20), new <CustomShape>[new CustomPolygon(0, 0, 30, 60)], new CustomMaterial(), 1);
            rat.name = raceInfo.racers[i].name;
            ratC = ControllerBase.create(rat, new <BehaviorBase>[new AIControlBehavior(), //new UserControlBehavior(),
                new RatMoveBehavior(),
                new TrapBehavior(),
                new BoostBehavior(),
                new ShootBehavior(),
                new DeathBehavior(),
//                new StatDisplayBehavior(),
                new DebugStatDisplayBehavior(_raceInfo)]);
            add(ratC);
        }
    }

    private function createItems(raceInfo:RaceInfo):void {
        var medkit:ObjectBase = ObjectBase.create(new Point(650, 250), new <CustomShape>[new CustomPolygon(0, 0, 30, 30)], new CustomMaterial(), 1);
        medkit.ammunition.health = 35;

        var medkitController:ControllerBase = ControllerBase.create(medkit, new <BehaviorBase>[new MedkitItemBehavior()]);
        add(medkitController);
//
//        var medkit2:ObjectBase = ObjectBase.create(new Point(130, 500), new <RShape>[new RPolygon(0, 0, 30, 30)], rMaterial, params["other"]["group"]);
//        medkit2.ammunition.health = 35;
//
//        var medkitController2:ControllerBase = ControllerBase.create(medkit2, new <BehaviorBase>[new MedkitItemBehavior()]);
//        _field.add(medkitController2);
//
//        var trap:ObjectBase = ObjectBase.create(new Point(660, 70), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
//        trap.ammunition.health = 120;
//
//        var trapController:ControllerBase = ControllerBase.create(trap, new <BehaviorBase>[new TrapItemBehavior()]);
//        _field.add(trapController);
//
//        var trap2:ObjectBase = ObjectBase.create(new Point(70, 70), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
//        trap2.ammunition.health = 120;
//
//        var trapController2:ControllerBase = ControllerBase.create(trap2, new <BehaviorBase>[new TrapItemBehavior()]);
//        _field.add(trapController2);
//
//        var trap3:ObjectBase = ObjectBase.create(new Point(400, 70), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
//        trap3.ammunition.health = 120;
//
//        var trapController3:ControllerBase = ControllerBase.create(trap3, new <BehaviorBase>[new TrapItemBehavior()]);
//        _field.add(trapController3);
//
//        var trap4:ObjectBase = ObjectBase.create(new Point(70, 300), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
//        trap4.ammunition.health = 120;
//
//        var trapController4:ControllerBase = ControllerBase.create(trap4, new <BehaviorBase>[new TrapItemBehavior()]);
//        _field.add(trapController4);
//
//        var trap5:ObjectBase = ObjectBase.create(new Point(400, 650), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
//        trap5.ammunition.health = 120;
//
//        var trapController5:ControllerBase = ControllerBase.create(trap5, new <BehaviorBase>[new TrapItemBehavior()]);
//        _field.add(trapController5);
    }
}
}
