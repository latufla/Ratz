/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:57
 * To change this template use File | Settings | File Templates.
 */
package {
import event.GameEvent;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import model.GameResult;
import model.RaceResult;

import utils.ObjectUtil;

import view.ControlsView;
import view.LobbyView;
import view.MainMenuView;
import view.RaceResultView;

public class SceneController extends EventDispatcher{
    private var _raceResult:RaceResult;
    private var _gameResult:GameResult;

    private var _gameEventHandlers:Dictionary; // event type -> function

    public function SceneController() {
        init();
    }

    private function init():void {
        addEventListeners();
    }

    private function addEventListeners():void {
        _gameEventHandlers = new Dictionary();
        _gameEventHandlers[GameEvent.NEED_MAIN_MENU] = onNeedMainMenu;
        _gameEventHandlers[GameEvent.NEED_CONTROLS] = onNeedControls;
        _gameEventHandlers[GameEvent.NEED_LOBBY] = onNeedLobby;
        _gameEventHandlers[GameEvent.NEED_RACE] = onNeedRace;
        _gameEventHandlers[GameEvent.NEED_RACE_RESULT] = onNeedRaceResult;

        for (var p:String in _gameEventHandlers){
            addEventListener(p, onGameEvent);
        }
    }

    // all game events come here
    private function onGameEvent(e:GameEvent):void{
        var handler:Function = _gameEventHandlers[e.type];
        if(handler)
            handler(e.data);
    }

    private function onNeedMainMenu(data:*):void{
        trace(MainMenuView);
    }

    private function onNeedControls(data:*):void{
        trace(ControlsView);
    }

    private function onNeedLobby(data:*):void{
        trace(LobbyView);
    }

    private function onNeedRace(data:*):void{
        trace("Field");
    }

    private function onNeedRaceResult(data:*):void{
        trace(RaceResultView);
    }

}
}
