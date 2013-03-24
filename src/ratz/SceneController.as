/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package ratz {
import core.utils.DisplayObjectUtil;
import core.utils.EventHeap;

import flash.display.MovieClip;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import nape.util.BitmapDebug;

import ratz.behaviors.CameraBehavior;
import ratz.controller.RFieldController;

import ratz.event.GameEvent;
import ratz.model.Field;
import ratz.model.info.GameInfo;
import ratz.model.info.UserInfo;
import ratz.utils.Config;
import ratz.utils.RaceInfoLib;
import ratz.view.ControlsView;
import ratz.view.LobbyView;
import ratz.view.MainMenuView;

public class SceneController extends EventDispatcher{
    private var _gameEventHandlers:Dictionary; // ratz.event type -> function

    private var _view:MovieClip;

    private var _field:RFieldController;
    private var _fieldDebugView:BitmapDebug;

    public function SceneController() {
        init();
    }

    private function init():void {
        _view = new MovieClip();
        Ratz.STAGE.addChild(_view);

        addEventListeners();

        var player:UserInfo = UserInfo.create(0, "rat0", UserInfo.USA);
        Config.gameInfo = new GameInfo(player);
        trace(Config.gameInfo);

        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_RACE));

        Config.sceneController = this;
    }

    private function addEventListeners():void {
        _gameEventHandlers = new Dictionary();
        _gameEventHandlers[GameEvent.NEED_MAIN_MENU] = onNeedMainMenu;
        _gameEventHandlers[GameEvent.NEED_CONTROLS] = onNeedControls;
        _gameEventHandlers[GameEvent.NEED_LOBBY] = onNeedLobby;
        _gameEventHandlers[GameEvent.NEED_RACE] = onNeedRace;
//        _gameEventHandlers[GameEvent.NEED_RACE] = onNeedRaceResult;
        _gameEventHandlers[GameEvent.NEED_RACE_RESULT] = onNeedRaceResult;

        for (var p:String in _gameEventHandlers){
            EventHeap.instance.register(p, onGameEvent);
        }
    }

    // all game events come here
    private function onGameEvent(e:GameEvent):void{
        var handler:Function = _gameEventHandlers[e.type];
        if(handler)
            handler(e.data);
    }

    private function onNeedMainMenu(data:*):void{
        DisplayObjectUtil.removeAll(_view);
        _view.addChild(new MainMenuView());
    }

    private function onNeedControls(data:*):void{
        DisplayObjectUtil.removeAll(_view);
        _view.addChild(new ControlsView());
    }

    private function onNeedLobby(data:*):void{
        DisplayObjectUtil.removeAll(_view);

        if(data && data.raceInfo)
            Config.gameInfo.applyRaceInfo(data.raceInfo);

        _view.addChild(new LobbyView(Config.gameInfo));
    }

    private function onNeedRaceResult(data:*):void{
        EventHeap.instance.unregister(Event.ENTER_FRAME, mainLoop);
        DisplayObjectUtil.removeAll(_view);
        _field.destroy();
        Config.gameInfo.refresh();

//        DisplayObjectUtil.removeAll(_view);
//        var raceInfo:RaceInfo = RaceInfoLib.getRaceInfoByLevel(1);
//        _view.addChild(new RaceResultView(data.raceInfo));
    }

    private function onNeedRace(data:*):void{
        DisplayObjectUtil.removeAll(_view);

        Config.ammunitionPanel.x = 20;
        Config.ammunitionPanel.y = 15;
        _view.addChild(Config.ammunitionPanel);

        var f:Field = RaceInfoLib.getRaceInfoByLevel(1);
        _field = new RFieldController(f);
        _field.addBehavior(new CameraBehavior());
        _field.startBehaviors();
        _field.draw();

        if(Config.DEBUG){
            _fieldDebugView = new BitmapDebug(1850, 1870, Ratz.STAGE.color);
            _view.addChild(_fieldDebugView.display);
            _view.alpha = 0.5;
        }

        EventHeap.instance.register(Event.ENTER_FRAME, mainLoop);
    }

    private function mainLoop(e:Event):void {
        _field.doStep(1 / 60, _fieldDebugView);
        _field.draw();

        if(!_field.view.parent)
            Config.mainScene.addChild(_field.view);
    }

    public function get view():MovieClip {
        return _view;
    }
}
}