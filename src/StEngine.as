/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 29.12.12
 * Time: 17:21
 * To change this template use File | Settings | File Templates.
 */
package {
import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class StEngine extends Sprite{

    [Embed(source="../assets/ratMoveRun.xml", mimeType="application/octet-stream")]
    public static const AtlasXml:Class;

    [Embed(source="../assets/ratMoveRun.png")]
    public static const AtlasTexture:Class;

    public function StEngine() {
        var texture:Texture = Texture.fromBitmap(new AtlasTexture());
        var xml:XML = XML(new AtlasXml());
        var atlas:TextureAtlas = new TextureAtlas(texture, xml);

        var movie:MovieClip = new MovieClip(atlas.getTextures("run_"), 10);
        addChild(movie);

        movie.play();
        Starling.juggler.add(movie);
    }

//    private function init():void {
//        Config.space = new Space();
//        _field = new Field();
//
//        var map:Body = NapeUtil.bodyFromBitmap(new Lvl1ViewClass());
//        map.type = BodyType.STATIC;
//        map.position = new Vec2(400, 450);
//        map.space = Config.space;
//
//        var stage:Stage = Ratz.STAGE;
//        _spaceView = new BitmapDebug(stage.stageWidth, stage.stageHeight, stage.color);
//        stage.addChild(_spaceView.display);
//        stage.addEventListener(Event.ENTER_FRAME, mainLoop);
//
//        var createBodyPanel:NapeCreateObjectPanel = new NapeCreateObjectPanel(createNapeObject);
//        createBodyPanel.x = 810;
//        stage.addChild(createBodyPanel);
//
//        Config.ammunitionPanel.x = 20;
//        Config.ammunitionPanel.y = 15;
//        stage.addChild(Config.ammunitionPanel);
//
//        _ratView = AssetsLib.instance.getAssetBy(AssetsLib.RAT_MOVE_RUN);
//        _ratView.fps = 14;
////        addChild(_ratView);
//        _ratView.x = _ratView.y = 200;
//        _ratView.pivotX = _ratView.width / 2;
//        _ratView.pivotY = _ratView.height / 2;
//
//        _ratView.play();
////        Starling.juggler.add(_ratView);
//
//        _ratView.rotation =  -Math.PI / 2;
////        addEventListener(EnterFrameEvent.ENTER_FRAME, onEFStarling);
//    }
//
//    private function onEFStarling(e:EnterFrameEvent):void {
//        if(!_rat)
//            return;
//
//        var pos:Point = _rat.position;
//        _ratView.x = pos.x;
//        _ratView.y = pos.y;
//        _ratView.rotation = _rat.rotation -Math.PI / 2;
//    }
}
}
