/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package {
import behaviors.BoostBehavior;
import behaviors.MedkitBehavior;
import behaviors.MoveBehavior;
import behaviors.TrapCreateBehavior;
import behaviors.gamepad.GamepadBehavior;
import behaviors.ShootBehavior;
import behaviors.TrapBehavior;
import behaviors.control.user.UserControlBehavior;

import controller.ControllerBase;

import debug.AmmunitionPanel;

import debug.NapeCreateObjectPanel;

import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import model.Field;

import model.RObjectBase;

import nape.geom.Vec2;

import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nape.shape.Polygon;
import nape.shape.Shape;
import nape.space.Space;
import nape.util.BitmapDebug;
import nape.util.Debug;

import starling.core.Starling;

import starling.display.MovieClip;

import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import utils.AssetsLib;

import utils.NapeUtil;
import utils.ObjectUtil;
import utils.RMaterial;
import utils.RPolygon;
import utils.RShape;
import utils.TestUtil;

public class Engine extends Sprite{

    [Embed(source="../assets/lvl1.png")]
    private var Lvl1ViewClass:Class;

    private var _rat:RObjectBase;
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

        _field = new Field();
        Config.field = _field;

        var map:Body = NapeUtil.bodyFromBitmap(new Lvl1ViewClass());
        map.type = BodyType.STATIC;
        map.position = new Vec2(400, 450);
        map.space = Config.space;

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
        _rat = new RObjectBase();
        _rat.position = new Point(650, 700);
        _rat.shapes = new <RShape>[new RPolygon(0, 0, 30, 60)];
        _rat.interactionGroup = params["other"]["group"];
        var material:Object = params["material"];
        _rat.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);
        _field.add(_rat);

        ratController = new ControllerBase();
        ratController.object = _rat;
        ratController.addBehavior(new UserControlBehavior());
        ratController.addBehavior(new MoveBehavior());
        ratController.addBehavior(new TrapCreateBehavior());
        ratController.startBehaviors();
        ratController.getBehaviorByClass(TrapCreateBehavior).stop();

        var medkit:RObjectBase = new RObjectBase();
        medkit.position = new Point(650, 250);
        medkit.shapes = new <RShape>[new RPolygon(0, 0, 30, 30)];
        var material:Object = params["material"];
        medkit.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);

        medkit.ammunition.health = 35;
        _field.add(medkit);

        var medkitController:ControllerBase = new ControllerBase();
        medkitController.object = medkit;
        medkitController.addBehavior(new MedkitBehavior());
        medkitController.startBehaviors();

        var trap:RObjectBase = new RObjectBase();
        trap.position = new Point(200, 200);
        trap.shapes = new <RShape>[new RPolygon(0, 0, 20, 20)];
        trap.material = new RMaterial(material["elasticity"], material["dynamicFriction"], material["staticFriction"], material["density"], material["rollingFriction"]);

        trap.ammunition.health = 20;
        _field.add(trap);

        var trapController:ControllerBase = new ControllerBase();
        trapController.object = trap;
        trapController.addBehavior(new TrapBehavior());
        trapController.startBehaviors();
    }
}
}
