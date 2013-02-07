package {

import com.junkbyte.console.Cc;

import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import starling.core.Starling;

[SWF(width="1100", height="850", backgroundColor="#FFFFFF", frameRate="60")]
public class Ratz extends Sprite {

    private var stConnector:Starling;

    public static var NAPE_VIEW:Sprite;
    public static var STARLING_VIEW:Sprite;

    public static var STAGE:Stage;

    public function Ratz() {

        STAGE = stage;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

//        NAPE_VIEW = new Sprite();
//        STARLING_VIEW = new Sprite();

        //new Engine();

        stConnector = new Starling(Engine, stage);
        stConnector.start();

//        addChild(NAPE_VIEW);
//        addChild(STARLING_VIEW);


//        Cc.startOnStage(this);
        trace("HWrd");
    }
}
}
