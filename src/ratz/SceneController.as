/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package ratz {
import ratz.event.GameEvent;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import ratz.model.info.GameInfo;
import ratz.model.Field;
import ratz.model.info.UserInfo;

import nape.util.BitmapDebug;

import ratz.utils.Config;
import core.utils.DisplayObjectUtil;
import core.utils.EventHeap;
import ratz.utils.RaceInfoLib;

import ratz.view.ControlsView;
import ratz.view.LobbyView;
import ratz.view.MainMenuView;
import ratz.view.RaceResultView;
import core.view.ViewBase;

public class SceneController extends EventDispatcher{
    private var _gameEventHandlers:Dictionary; // ratz.event type -> function

    private var _view:ViewBase;

    private var _field:RatzFieldController;
    private var _fieldDebugView:BitmapDebug;

    public function SceneController() {
        init();
    }

    private function init():void {
        _view = new ViewBase();
        Ratz.STAGE.addChild(_view);

        addEventListeners();

        var player:UserInfo = UserInfo.create(0, "rat0", UserInfo.USA);
        Config.gameInfo = new GameInfo(player);
        trace(Config.gameInfo);

        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_RACE));
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

        trace("onNeedLobby", new Error().getStackTrace());
        if(data && data.raceInfo)
            Config.gameInfo.applyRaceInfo(data.raceInfo);

        _view.addChild(new LobbyView(Config.gameInfo));
    }

    private function onNeedRaceResult(data:*):void{
//        DisplayObjectUtil.removeAll(_view);
        trace("onNeedRaceResult");
//        var raceInfo:RaceInfo = RaceInfoLib.getRaceInfoByLevel(1);
//        _view.addChild(new RaceResultView(data.raceInfo));
    }

    private function onNeedRace(data:*):void{
        DisplayObjectUtil.removeAll(_view);

        Config.ammunitionPanel.x = 20;
        Config.ammunitionPanel.y = 15;
        _view.addChild(Config.ammunitionPanel);

        var raceInfo:Field = RaceInfoLib.getRaceInfoByLevel(1);
        _field = new RatzFieldController(raceInfo);

        _fieldDebugView = new BitmapDebug(Ratz.STAGE.stageWidth, Ratz.STAGE.stageHeight, Ratz.STAGE.color);
        _fieldDebugView.display.x = 0;
        _fieldDebugView.display.y = 50;
        _view.addChild(_fieldDebugView.display);

        _view.addEventListener(Event.ENTER_FRAME, mainLoop);
    }

    private function mainLoop(e:Event):void {
        _field.doStep(1 / 60, _fieldDebugView);
    }
}
}