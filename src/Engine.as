/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package {
import behaviors.BehaviorBase;
import behaviors.BoostBehavior;
import behaviors.MedkitItemBehavior;
import behaviors.MoveBehavior;
import behaviors.ShootBehavior;
import behaviors.TrapBehavior;
import behaviors.TrapItemBehavior;
import behaviors.control.user.UserControlBehavior;

import controller.ControllerBase;

import debug.NapeCreateObjectPanel;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Point;

import model.ObjectBase;

import nape.space.Space;
import nape.util.BitmapDebug;

import starling.display.MovieClip;
import starling.display.Sprite;

import utils.Config;
import utils.RMaterial;
import utils.RPolygon;
import utils.RShape;

public class Engine extends Sprite{

    [Embed(source="../assets/lvl1.png")]
    private var Lvl1ViewClass:Class;

    private var _rat:ObjectBase;
    private var _spaceView:BitmapDebug;

    public static var ratController:ControllerBase;

    private var _field:Field;

    public function Engine() {
        init();
//        TestUtil.startControllerTest();
    }

    private function init():void {
        Config.space = new Space();

        var border:BitmapData = Bitmap(new Lvl1ViewClass()).bitmapData;
        _field = new Field(new Point(0, 50), border);
        Config.field = _field;

        var stage:Stage = Ratz.STAGE;
        _spaceView = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
        stage.addChild(_spaceView.display);
        stage.addEventListener(Event.ENTER_FRAME, mainLoop);

        var createBodyPanel:NapeCreateObjectPanel = new NapeCreateObjectPanel(createNapeObject);
        createBodyPanel.x = 810;
        stage.addChild(createBodyPanel);

        Config.ammunitionPanel.x = 20;
        Config.ammunitionPanel.y = 15;
        stage.addChild(Config.ammunitionPanel);
    }


    private function mainLoop(e:Event):void {
        _field.simulateStep(1 / 60, _spaceView);

        // friction
        if(!_rat)
            return;

        _rat.applyTerrainFriction(0.2, 0.01);
        Config.ammunitionPanel.info = _rat.ammunition;
    }

    private function createNapeObject(params:Object):void{
        var material:Object = params["material"];
        var rMaterial:RMaterial = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);
        _rat = ObjectBase.create(new Point(650, 700), new <RShape>[new RPolygon(0, 0, 30, 60)], rMaterial, params["other"]["group"]);

        ratController = ControllerBase.create(_rat, new <BehaviorBase>[new UserControlBehavior(), new MoveBehavior(), new TrapBehavior(), new BoostBehavior(), new ShootBehavior()]);
        ratController.startBehaviors();
        _field.add(ratController);

        var medkit:ObjectBase = ObjectBase.create(new Point(650, 250), new <RShape>[new RPolygon(0, 0, 30, 30)], rMaterial, params["other"]["group"]);
        medkit.ammunition.health = 35;

        var medkitController:ControllerBase = ControllerBase.create(medkit, new <BehaviorBase>[new MedkitItemBehavior()]);
        medkitController.startBehaviors();
        _field.add(medkitController);

        var trap:ObjectBase = ObjectBase.create(new Point(200, 200), new <RShape>[new RPolygon(0, 0, 20, 20)], rMaterial, params["other"]["group"]);
        trap.ammunition.health = 20;

        var trapController:ControllerBase = ControllerBase.create(trap, new <BehaviorBase>[new TrapItemBehavior()]);
        trapController.startBehaviors();
        _field.add(trapController);
    }
}
}
