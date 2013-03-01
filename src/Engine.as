/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package {
import behaviors.BehaviorBase;
import behaviors.control.ai.AIControlBehavior;
import behaviors.core.StatDisplayBehavior;
import behaviors.gameplay.BoostBehavior;
import behaviors.gameplay.DeathBehavior;
import behaviors.gameplay.MedkitItemBehavior;
import behaviors.gameplay.RatMoveBehavior;
import behaviors.gameplay.ShootBehavior;
import behaviors.gameplay.TrapBehavior;
import behaviors.gameplay.TrapItemBehavior;
import behaviors.control.user.UserControlBehavior;

import controller.ControllerBase;

import debug.NapeCreateObjectPanel;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;

import managers.WaypointManager;

import model.ObjectBase;


import nape.space.Space;
import nape.util.BitmapDebug;

import starling.display.MovieClip;
import starling.display.Sprite;

import utils.Config;
import utils.FPSCounter;
import utils.geom.Line;
import utils.nape.RMaterial;
import utils.nape.RPolygon;
import utils.nape.RShape;

public class Engine extends Sprite{

    [Embed(source="../assets/lvl1.png")]
    private var Lvl1ViewClass:Class;

    private var _rat:ObjectBase;
    private var _spaceView:BitmapDebug;

    private var _ratController:ControllerBase;

    private var _field:Field;

    public function Engine() {
        init();
//        TestUtil.startControllerTest();

    }

    private function init():void {
        Config.space = new Space();

        var border:BitmapData = Bitmap(new Lvl1ViewClass()).bitmapData;
        var wps:Vector.<Object> = new Vector.<Object>();
        wps.push({rect: new Rectangle(604, 380, 169, 24), turnPoint: null});
        wps.push({rect: new Rectangle(604, 30, 170, 170)});
        wps.push({rect: new Rectangle(35, 30, 170, 170)});
        wps.push({rect: new Rectangle(35, 590, 170, 170)});
        wps.push({rect: new Rectangle(604, 590, 170, 170)});
        _field = new Field(border, wps);

        var stage:Stage = Ratz.STAGE;
        Config.ammunitionPanel.x = 20;
        Config.ammunitionPanel.y = 15;
        stage.addChild(Config.ammunitionPanel);

        _spaceView = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
        _spaceView.display.x = 0;
        _spaceView.display.y = 50;
        stage.addChild(_spaceView.display);
        stage.addEventListener(Event.ENTER_FRAME, mainLoop);

        var createBodyPanel:NapeCreateObjectPanel = new NapeCreateObjectPanel(createNapeObject);
        createBodyPanel.x = 810;
        stage.addChild(createBodyPanel);

        stage.addChild(new FPSCounter(5, 5));
    }


    private function mainLoop(e:Event):void {
        _field.simulateStep(1 / 60, _spaceView);
    }

    private function createNapeObject(params:Object):void{
        var material:Object = params["material"];
        var rMaterial:RMaterial = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);

//        createRats(rMaterial, params["other"]["group"]);

        var rat1 = ObjectBase.create(new Point(650, 410), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, params["other"]["group"]);
        rat1.name = "Rat 1";

        var rat1Controller = ControllerBase.create(rat1, new <BehaviorBase>[new UserControlBehavior(),
            new RatMoveBehavior(),
            new TrapBehavior(),
            new BoostBehavior(),
            new ShootBehavior(),
            new DeathBehavior(),
            new StatDisplayBehavior()]);
        _field.add(rat1Controller);

//        var medkit:ObjectBase = ObjectBase.create(new Point(650, 250), new <RShape>[new RPolygon(0, 0, 30, 30)], rMaterial, params["other"]["group"]);
//        medkit.ammunition.health = 35;
//
//        var medkitController:ControllerBase = ControllerBase.create(medkit, new <BehaviorBase>[new MedkitItemBehavior()]);
//        _field.add(medkitController);
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

    private function createRats(rMaterial:RMaterial, group:int):void {
//        var rat1 = ObjectBase.create(new Point(620, 410), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, group);
//        rat1.name = "Rat 1";
//
//        var rat1Controller = ControllerBase.create(rat1, new <BehaviorBase>[new AIControlBehavior(),
//            new RatMoveBehavior(),
//            new TrapBehavior(),
//            new BoostBehavior(),
//            new ShootBehavior(),
//            new DeathBehavior(),
//            new StatDisplayBehavior()]);
//        _field.add(rat1Controller);

        var rat2 = ObjectBase.create(new Point(660, 410), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, group);
        rat2.name = "Rat 2";

        var rat2Controller = ControllerBase.create(rat2, new <BehaviorBase>[new AIControlBehavior(),
            new RatMoveBehavior(),
            new TrapBehavior(),
            new BoostBehavior(),
            new ShootBehavior(),
            new DeathBehavior()]);
        _field.add(rat2Controller);

//        var rat3 = ObjectBase.create(new Point(700, 410), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, group);
//        rat3.name = "Rat 3";
//
//        var rat3Controller = ControllerBase.create(rat3, new <BehaviorBase>[new AIControlBehavior(),
//            new RatMoveBehavior(),
//            new TrapBehavior(),
//            new BoostBehavior(),
//            new ShootBehavior(),
//            new DeathBehavior()]);
//        _field.add(rat3Controller);
//
//        var rat4 = ObjectBase.create(new Point(740, 410), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, group);
//        rat4.name = "Rat 4";
//
//        var rat4Controller = ControllerBase.create(rat4, new <BehaviorBase>[new AIControlBehavior(),
//            new RatMoveBehavior(),
//            new TrapBehavior(),
//            new BoostBehavior(),
//            new ShootBehavior(),
//            new DeathBehavior()]);
//        _field.add(rat4Controller);

    }
}
}
