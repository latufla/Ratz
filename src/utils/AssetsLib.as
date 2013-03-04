/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 13:44
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

public class AssetsLib {

    // SCREENS
    public static const MAIN_MENU_SCREEN:String = "mainScreen";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="MainScreenView")]
    private const MainMenuScreen:Class;

    public static const CONTROLS_SCREEN:String = "controlsScreen";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="ControlsScreenView")]
    private const ControlsScreen:Class;

    public static const LOBBY_SCREEN:String = "lobbyScreen";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="LobbyScreenView")]
    private const LobbyScreen:Class;

    public static const RESULT_ITEM:String = "resultItem";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="ResultItemView")]
    private const ResultItem:Class;
    // END SCREENS

    // FLAGS
    public static const CHINA_SIGNED_FLAG:String = "chinaSignedFlag";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="ChinaSignedFlagView")]
    private const ChinaSignedFlag:Class;

    public static const JAPAN_SIGNED_FLAG:String = "japanSignedFlag";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="JapanSignedFlagView")]
    private const JapanSignedFlag:Class;

    public static const USA_SIGNED_FLAG:String = "usaSignedFlag";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="USASignedFlagView")]
    private const USASignedFlag:Class;

    public static const RUSSIA_SIGNED_FLAG:String = "russiaSignedFlag";
    [Embed(source="../../assets/gui/GUI_0_1_a.swf", symbol="RussiaSignedFlagView")]
    private const RussiaSignedFlag:Class;
    // END FLAGS

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
        _assets[MAIN_MENU_SCREEN] = MainMenuScreen;
        _assets[CONTROLS_SCREEN] = ControlsScreen;
        _assets[LOBBY_SCREEN] = LobbyScreen;
        _assets[RESULT_ITEM] = ResultItem;

        _assets[CHINA_SIGNED_FLAG] = ChinaSignedFlag;
        _assets[JAPAN_SIGNED_FLAG] = JapanSignedFlag;
        _assets[USA_SIGNED_FLAG] = USASignedFlag;
        _assets[RUSSIA_SIGNED_FLAG] = RussiaSignedFlag;
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

    public function createAssetBy(className:String):DisplayObjectContainer{
        var asset:Class = getAssetClassBy(className);
        return new asset() as DisplayObjectContainer;
    }
}
}
