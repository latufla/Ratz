/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:49
 * To change this template use File | Settings | File Templates.
 */
package ratz.view {
import core.view.ViewBase;

import ratz.event.GameEvent;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

import ratz.model.RaceInfo;
import ratz.model.UserInfo;

import ratz.utils.AssetsLib;
import ratz.utils.Config;
import core.utils.EventHeap;

public class RaceResultView extends ViewBase{

    private static const CLOSE_TIMEOUT:Number = 7000;

    private var _container:DisplayObjectContainer;
    private var _raceInfo:RaceInfo;

    public function RaceResultView(raceInfo:RaceInfo){
        _raceInfo = raceInfo;
        init();
    }

    private function init():void{
        _container = new Sprite();

        var finishers:Vector.<UserInfo> = _raceInfo.finishers;
        var resultItem:DisplayObjectContainer;
        for (var i:int = 0; i < finishers.length; i++) {
            resultItem = createResultItem(finishers[i], i + 1);
            resultItem.x = offsetX;
            resultItem.y = offsetY + itemSpaceY * i;
            _container.addChild(resultItem);
        }
        addChild(_container);

        var tId:uint = setTimeout(function():void{
            EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_LOBBY, {raceInfo: _raceInfo}));
            clearTimeout(tId);
        }, CLOSE_TIMEOUT);
    }

    private function createResultItem(racer:UserInfo, place:uint):DisplayObjectContainer{
        var item:DisplayObjectContainer = AssetsLib.instance.createAssetBy(AssetsLib.RESULT_ITEM) as DisplayObjectContainer;

        var flag:DisplayObject = AssetsLib.instance.getFlagByCountryId(racer.country);
        flag.width = flagWidth;
        flag.height = flagHeight;
        getResultItemFlagAnchor(item).addChild(flag);

        var placeField:TextField = getResultItemPlaceField(item);
        placeField.autoSize = TextFieldAutoSize.LEFT;
        placeField.text = String(place);

        getResultItemPointsCountField(item).text = Config.pointsForPlacePlanet1[place - 1];

        return item;
    }

    private function get offsetX():int{
        return 70;
    }

    private function get offsetY():int{
        return 50;
    }

    private function get itemSpaceY():int{
        return 110;
    }

    private function get flagWidth():int{
        return 86.6;
    }

    private function get flagHeight():int{
        return 80;
    }

    private function getResultItemFlagAnchor(resultItem:DisplayObjectContainer):MovieClip{
        return resultItem["flagAnchor"];
    }

    private function getResultItemPointsCountField(resultItem:DisplayObjectContainer):TextField{
        return resultItem["pointsCountField"];
    }

    private function getResultItemPlaceField(resultItem:DisplayObjectContainer):TextField{
        return resultItem["placeField"];
    }
}
}
