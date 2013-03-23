/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 30.12.12
 * Time: 15:23
 * To change this template use File | Settings | File Templates.
 */
package ratz.utils {
import starling.display.MovieClip;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class StarlingAssetsLib {

    public static const RAT_IDLE:String = "ratIdle";
    public static const RAT_MOVE_ACC:String = "ratMoveAcc";
    public static const RAT_MOVE_RUN:String = "ratMoveRun";

    [Embed(source="../../../assets/ratIdle.xml", mimeType="application/octet-stream")]
    private const RatIdleXml:Class;

    [Embed(source="../../../assets/ratIdle.png")]
    private const RatIdleTexture:Class;

    [Embed(source="../../../assets/ratMoveAcc.xml", mimeType="application/octet-stream")]
    private const RatMoveAccXml:Class;

    [Embed(source="../../../assets/ratMoveAcc.png")]
    private const RatMoveAccTexture:Class;

    [Embed(source="../../../assets/ratMoveRun.xml", mimeType="application/octet-stream")]
    private const RatMoveRunXml:Class;

    [Embed(source="../../../assets/ratMoveRun.png")]
    private const RatMoveRunTexture:Class;

    private var _assets:Array/* of MovieClip`s */;

    private static var _instance:StarlingAssetsLib;

    public function StarlingAssetsLib() {
        init();
    }

    public static function get instance():StarlingAssetsLib {
        if(!_instance)
            _instance = new StarlingAssetsLib();

        return _instance;
    }

    public function getAssetBy(name:String):MovieClip{
        var asset:MovieClip;
        try{
            asset = _assets[name];
        } catch (e:Error){
            trace("AssetsLib -> getAssetBy(): no asset with name: " + name);
        }

        return asset;
    }

    private function init():void {
        _assets = [];

        // RAT
        _assets[RAT_IDLE] = createMovieClipFrom(RatIdleTexture, RatIdleXml, "idle", 10);
        _assets[RAT_MOVE_ACC] = createMovieClipFrom(RatMoveAccTexture, RatMoveAccXml, "moveAcc", 10);
        _assets[RAT_MOVE_RUN] = createMovieClipFrom(RatMoveRunTexture, RatMoveRunXml, "moveRun", 10);
    }

    private function createMovieClipFrom(bitmapClass:Class, xmlClass:Class, prefix:String, fps:uint = 10):MovieClip{
        var texture:Texture = Texture.fromBitmap(new bitmapClass());
        var xml:XML = XML(new xmlClass());
        var atlas:TextureAtlas = new TextureAtlas(texture, xml);
        return new MovieClip(atlas.getTextures(prefix), fps);
    }

}
}
