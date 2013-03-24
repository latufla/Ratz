package ratz {

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import starling.core.Starling;

[SWF(width="1100", height="850", backgroundColor="#FFFFFF", frameRate="60")]
public class Ratz extends Sprite {

    public static var starlingConnector:Starling;
    public static var STAGE:Stage;

    public function Ratz() {
        addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
//        Cc.startOnStage(this);
    }

    private function onAddToStage(e:Event):void {
        STAGE = stage;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        starlingConnector = new Starling(Engine, stage);
        starlingConnector.start();
    }
}
}
