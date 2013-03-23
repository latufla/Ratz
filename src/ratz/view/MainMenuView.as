/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:47
 * To change this template use File | Settings | File Templates.
 */
package ratz.view {
import core.view.ViewBase;

import ratz.event.GameEvent;

import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.events.MouseEvent;

import ratz.utils.AssetsLib;
import ratz.utils.Config;
import core.utils.EventHeap;

public class MainMenuView extends ViewBase {

    private var _container:DisplayObjectContainer;
    public function MainMenuView() {
        super();
        init();
    }

    private function init():void{
        _container = AssetsLib.instance.createAssetBy(AssetsLib.MAIN_MENU_SCREEN) as DisplayObjectContainer;
        addChild(_container);

        playButton.buttonMode =  playButton.useHandCursor = true;
        controlsButton.buttonMode =  controlsButton.useHandCursor = true;

        soundSwitcher.buttonMode =  soundSwitcher.useHandCursor = true;
        soundSwitcher.gotoAndStop(1);

        addEventListeners();
    }

    private function addEventListeners():void {
        playButton.addEventListener(MouseEvent.CLICK, onClickPlayButton);
        controlsButton.addEventListener(MouseEvent.CLICK, onClickControlsButton);
        soundSwitcher.addEventListener(MouseEvent.CLICK, onClickSoundSwitcher);
    }

    private function onClickPlayButton(e:MouseEvent):void {
        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_LOBBY));
    }

    private function onClickControlsButton(e:MouseEvent):void {
        EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_CONTROLS));
    }

    private function onClickSoundSwitcher(e:MouseEvent):void {
        Config.soundEnabled = !Config.soundEnabled;
        soundSwitcher.gotoAndStop(Config.soundEnabled ? 1 : 2);
    }

    private function get playButton():MovieClip{
        return _container["playButton"];
    }

    private function get controlsButton():MovieClip{
        return _container["controlsButton"];
    }

    private function get soundSwitcher():MovieClip{
        return _container["soundSwitcher"];
    }

}
}
