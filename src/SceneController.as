/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package {
import event.GameEvent;
import event.GameEvent;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import model.GameInfo;
import model.RaceInfo;
import model.UserInfo;

import utils.DisplayObjectUtil;

import utils.EventHeap;

import utils.ObjectUtil;

import view.ControlsView;
import view.LobbyView;
import view.MainMenuView;
import view.RaceResultView;
import view.ViewBase;

public class SceneController extends EventDispatcher{
    private var _raceInfo:RaceInfo;
    private var _gameInfo:GameInfo;

    private var _gameEventHandlers:Dictionary; // event type -> function

    private var _mainMenuView:MainMenuView;
    private var _controlsView:ControlsView;

    private var _view:ViewBase;

    public function SceneController() {
        init();
    }

    private function init():void {
        _view = new ViewBase();
        Ratz.STAGE.addChild(_view);

        addEventListeners();
        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_MAIN_MENU));

        var player:UserInfo = UserInfo.create(0, "rat0", UserInfo.USA);
        _gameInfo = new GameInfo(player);
        trace(_gameInfo);
    }

    private function addEventListeners():void {
        _gameEventHandlers = new Dictionary();
        _gameEventHandlers[GameEvent.NEED_MAIN_MENU] = onNeedMainMenu;
        _gameEventHandlers[GameEvent.NEED_CONTROLS] = onNeedControls;
        _gameEventHandlers[GameEvent.NEED_LOBBY] = onNeedLobby;
//        _gameEventHandlers[GameEvent.NEED_RACE] = onNeedRace;
        _gameEventHandlers[GameEvent.NEED_RACE] = onNeedRaceResult;
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
        _view.addChild(new LobbyView(_gameInfo));
    }

    private function onNeedRace(data:*):void{
        trace("Field");
    }

    private function onNeedRaceResult(data:*):void{
        DisplayObjectUtil.removeAll(_view);
        _raceInfo = new RaceInfo(_gameInfo.allRacers);
        _view.addChild(new RaceResultView(_raceInfo));
    }

}
}
