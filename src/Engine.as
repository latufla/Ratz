/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package {
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

    private var _ratView:MovieClip;

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
        _rat = new ObjectBase();
        _rat.position = new Point(650, 700);
        _rat.shapes = new <RShape>[new RPolygon(0, 0, 30, 60)];
        _rat.interactionGroup = params["other"]["group"];
        var material:Object = params["material"];
        _rat.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);


        ratController = new ControllerBase();
        ratController.object = _rat;
        ratController.addBehavior(new UserControlBehavior());
        ratController.addBehavior(new MoveBehavior());
        ratController.addBehavior(new TrapBehavior());
        ratController.addBehavior(new BoostBehavior());
        ratController.addBehavior(new ShootBehavior());
        ratController.startBehaviors();
        _field.add(ratController);

        var medkit:ObjectBase = new ObjectBase();
        medkit.position = new Point(650, 250);
        medkit.shapes = new <RShape>[new RPolygon(0, 0, 30, 30)];
        var material:Object = params["material"];
        medkit.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);

        medkit.ammunition.health = 35;

        var medkitController:ControllerBase = new ControllerBase();
        medkitController.object = medkit;
        medkitController.addBehavior(new MedkitItemBehavior());
        medkitController.startBehaviors();
        _field.add(medkitController);

        var trap:ObjectBase = new ObjectBase();
        trap.position = new Point(200, 200);
        trap.shapes = new <RShape>[new RPolygon(0, 0, 20, 20)];
        trap.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);

        trap.ammunition.health = 20;

        var trapController:ControllerBase = new ControllerBase();
        trapController.object = trap;
        trapController.addBehavior(new TrapItemBehavior());
        trapController.startBehaviors();
        _field.add(trapController);
    }
}
}
