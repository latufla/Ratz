/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:44
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.MovieClip;

public class AssetsLib {

    public static const MAIN_SCREEN:String = "mainScreen";

    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="MainScreenView")]
    private const MainScreen:Class;

    private var _assets:Array/* of MovieClip`s */;

    private static var _instance:AssetsLib;
    public function AssetsLib() {
        init();
    }

    public static function get instance():AssetsLib{
        _instance ||= new AssetsLib();
        return _instance;
    }


    private function init():void {
        _assets = [];
        _assets[MAIN_SCREEN] = MainScreen;
    }

    public function getAssetClassBy(name:String):Class{
        var asset:Class;
        try{
            asset = _assets[name];
        } catch (e:Error){
            trace("AssetsLib -> getAssetBy(): no asset class with name: " + name);
        }

        return asset;
    }
}
}
