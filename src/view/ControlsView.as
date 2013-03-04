/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:48
 * To change this template use File | Settings | File Templates.
 */
package view {
import event.GameEvent;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.MouseEvent;

import utils.AssetsLib;
import utils.EventHeap;

public class ControlsView extends ViewBase{

    private var _container:DisplayObjectContainer;
    public function ControlsView() {
        super();
        init();
    }

    private function init():void{
        _container = AssetsLib.instance.createAssetBy(AssetsLib.CONTROLS_SCREEN) as DisplayObjectContainer;
        addChild(_container);

        backButton.buttonMode =  backButton.useHandCursor = true;
        addEventListeners();
    }

    private function addEventListeners():void {
        backButton.addEventListener(MouseEvent.CLICK, onClickBackButton);
    }

    private function onClickBackButton(event:MouseEvent):void {
        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_MAIN_MENU));
    }

    private function get backButton():MovieClip {
        return _container["backButton"];
    }
}
}
