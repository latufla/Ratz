/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package ratz.view {
import core.view.ViewBase;

import ratz.event.GameEvent;

import flash.display.DisplayObject;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ratz.model.info.GameInfo;
import ratz.model.info.UserInfo;

import ratz.utils.AssetsLib;
import ratz.utils.Config;
import core.utils.EventHeap;

public class LobbyView extends ViewBase{

    private var _container:DisplayObjectContainer;
    private var _gameInfo:GameInfo;

    public function LobbyView(gameInfo:GameInfo) {
        _gameInfo = gameInfo;
        init();
    }

    private function init():void{
        _container = AssetsLib.instance.createAssetBy(AssetsLib.LOBBY_SCREEN) as DisplayObjectContainer;
        addChild(_container);

        var player:UserInfo = _gameInfo.player;
        racesCountField.text = String(player.races);
        pointsCountField.text = String(player.points);

        maxRacesCountField.text = String(Config.racesCountPlanet1);

        maxPointsCountField.autoSize = TextFieldAutoSize.LEFT;
        maxPointsCountField.text = String(Config.maxPointsCountPlanet1);

        goButton.buttonMode = goButton.useHandCursor = true;

        var flag:DisplayObject = AssetsLib.instance.getFlagByCountryId(player.country);
        flagAnchor.addChild(flag);

        var opponents:Vector.<UserInfo> = _gameInfo.opponents;
        for (var i:int = 0; i < opponents.length; i++) {
            flag = AssetsLib.instance.getFlagByCountryId(opponents[i].country);
            flag.x = opponentsOffsetX;
            flag.y = opponentsoffsetY + opponentsFlagSpaceY * i;
            opponentsPanel.addChild(flag);
        }

        addEventListeners();
    }

    private function addEventListeners():void {
        goButton.addEventListener(MouseEvent.CLICK, onClickGoButton);
    }

    private function onClickGoButton(event:MouseEvent):void {
        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_RACE));
    }

    private function get racesCountField():TextField {
        return _container["racesCountField"];
    }

    private function get maxRacesCountField():TextField {
        return _container["maxRacesCountField"];
    }

    private function get pointsCountField():TextField {
        return _container["pointsCountField"];
    }

    private function get maxPointsCountField():TextField {
        return _container["maxPointsCountField"];
    }

    private function get goButton():MovieClip {
        return _container["goButton"];
    }

    private function get flagAnchor():MovieClip {
        return _container["flagAnchor"];
    }

    private function get ratAnchor():MovieClip {
        return _container["ratAnchor"];
    }

    private function get opponentsPanel():MovieClip {
        return _container["opponentsPanel"];
    }

    private function get opponentsOffsetX():int{
        return 20;
    }

    private function get opponentsoffsetY():int{
        return 45;
    }

    private function get opponentsFlagSpaceY():int{
        return 110;
    }
}
}
