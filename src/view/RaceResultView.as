/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:49
 * To change this template use File | Settings | File Templates.
 */
package view {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import model.RaceInfo;
import model.UserInfo;

import utils.AssetsLib;
import utils.Config;

public class RaceResultView extends ViewBase{

    private var _container:DisplayObjectContainer;
    private var _raceInfo:RaceInfo;
    public function RaceResultView(raceInfo:RaceInfo){
        _raceInfo = raceInfo;
        init();
    }

    private function init():void{
        _container = new Sprite();

        var racers:Vector.<UserInfo> = _raceInfo.racers;
        var resultItem:DisplayObjectContainer;
        for (var i:int = 0; i < racers.length; i++) {
            resultItem = createResultItem(racers[i], i + 1);
            resultItem.x = offsetX;
            resultItem.y = offsetY + itemSpaceY * i;
            _container.addChild(resultItem);
        }
        addChild(_container);
    }

    private function createResultItem(racer:UserInfo, place:uint):DisplayObjectContainer{
        var item:DisplayObjectContainer = AssetsLib.instance.createAssetBy(AssetsLib.RESULT_ITEM) as DisplayObjectContainer;

        var flags:Array = [AssetsLib.CHINA_SIGNED_FLAG, AssetsLib.JAPAN_SIGNED_FLAG,
            AssetsLib.RUSSIA_SIGNED_FLAG, AssetsLib.USA_SIGNED_FLAG];

        var flag:DisplayObject = AssetsLib.instance.createAssetBy(flags[racer.country]);
        getResultItemFlagAnchor(item).addChild(flag);

        var placeField:TextField = getResultItemPlaceField(item);
        placeField.autoSize = TextFieldAutoSize.LEFT;
        placeField.text = String(place);

        getResultItemPointsCountField(item).text = Config.pointsForPlacePlanet1[place - 1];

        return item;
    }

    private function get offsetX():uint{
        return 50;
    }

    private function get offsetY():uint{
        return 30;
    }

    private function get itemSpaceY():uint{
        return 140;
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
