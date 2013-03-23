/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.01.13
 * Time: 19:39
 * To change this template use File | Settings | File Templates.
 */
package ratz {

import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.controller.FieldController;
import core.model.ObjectBase;
import core.utils.nape.CustomMaterial;
import core.utils.nape.CustomPolygon;
import core.utils.nape.CustomShape;
import core.utils.nape.PhysEngineConnector;

import flash.geom.Point;

import ratz.behaviors.DebugStatDisplayBehavior;
import ratz.behaviors.control.ai.AIControlBehavior;
import ratz.behaviors.gameplay.BoostBehavior;
import ratz.behaviors.gameplay.DeathBehavior;
import ratz.behaviors.gameplay.MedkitItemBehavior;
import ratz.behaviors.gameplay.RatMoveBehavior;
import ratz.behaviors.gameplay.ShootBehavior;
import ratz.behaviors.gameplay.TrapBehavior;
import ratz.managers.WaypointManager;
import ratz.model.Field;
import ratz.utils.Config;

public class RatzFieldController extends FieldController{

    public function RatzFieldController(field:Field) {
        _object = field;

        super();
    }

    override protected function init():void {
        super.init();

        Config.fieldController = this;
        PhysEngineConnector.instance.createBorders(this, field.border);
        WaypointManager.instance.init(field);

        createItems(field);
        createRats(field);
    }

    private function get field():Field{
        return _object as Field;
    }

    override public function doStep(step:Number, debugView:* = null):void{
        super.doStep(step, debugView);

        for each(var p:ControllerBase in _controllers){
            if(p.isRat)
                p.object.applyTerrainFriction(0.2, 0.01);
        }

        if(!field.raceIsFinished)
            field.updateRaceProgress();
    }

    public function get ratControllers():Vector.<ControllerBase>{
        return getControllersByBehaviorClass(RatMoveBehavior);
    }

    private function createRats(raceInfo:Field):void {
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
                new DebugStatDisplayBehavior(field)]);
            add(ratC);
        }
    }

    private function createItems(raceInfo:Field):void {
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
