/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:42
 * To change this template use File | Settings | File Templates.
 */
package ratz {
import flash.geom.Point;

import starling.display.Sprite;

import core.utils.FPSCounter;
import core.utils.geom.Line;

public class Engine extends Sprite{

    private var _scene:SceneController;

    public function Engine() {
        init();
//        TestUtil.startControllerTest();

//        var assetClass:Class = AssetsLib.instance.getAssetClassBy(AssetsLib.CHINA_SIGNED_FLAG);
//        var asset:DisplayObject = new assetClass() as DisplayObject;
//        Ratz.STAGE.addChild(asset);
//
//        assetClass = AssetsLib.instance.getAssetClassBy(AssetsLib.JAPAN_SIGNED_FLAG);
//        asset = new assetClass() as DisplayObject;
//        asset.x = 120;
//        Ratz.STAGE.addChild(asset);

//        _scene = new SceneController();

//        var pnt:Point = new Point(10, 12);
//        var line:Line = new Line(new Point(4, 6), new Point(8, 6));
//        trace(line.getPointProjection(pnt));
    }

    private function init():void {
        _scene = new SceneController();
        Ratz.STAGE.addChild(new FPSCounter(5, 5));
    }
}
}
