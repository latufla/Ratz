/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 13:47
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.DisplayObjectContainer;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class GuiUtil {
    [Embed(source="../../assets/fonts/ARIALUNI.TTF", fontName = "myArial", mimeType = "application/x-font", unicodeRange = "U+0020-007E", fontWeight="normal", fontStyle="normal", advancedAntiAliasing="true", embedAsCFF="false")]
    private var myArialFont:Class;

    [Embed(source="../../assets/fonts/BADABB__.TTF", fontName = "myComix", mimeType = "application/x-font", unicodeRange = "U+0020-007E", fontWeight="normal", fontStyle="normal", advancedAntiAliasing="true", embedAsCFF="false")]
    private var myComixFont:Class;

    public static function showPopupText(view:DisplayObjectContainer, pos:Point, text:String, fontSize:uint = 30, color:uint = 0x00FF00):void{
        var tField:TextField = new TextField();
        tField.x = pos.x;
        tField.y = pos.y;
        tField.autoSize = TextFieldAutoSize.LEFT;
        tField.embedFonts = true;
        tField.defaultTextFormat = new TextFormat("myComix", fontSize);
        tField.text = text;
        tField.textColor = color;
        view.addChild(tField);

        TweenUtil.tween(tField, 2000, { y: tField.y - 50, alpha: 0, onComplete: function():void{DisplayObjectUtil.tryRemove(tField)}});
    }

    public static function showStaticText(view:DisplayObjectContainer, pos:Point, text:String, fontSize:uint = 30, color:uint = 0x00FF00):void{
        var tField:TextField = new TextField();
        tField.x = pos.x;
        tField.y = pos.y;
        tField.autoSize = TextFieldAutoSize.LEFT;
        tField.embedFonts = true;
        tField.defaultTextFormat = new TextFormat("myComix", fontSize);
        tField.text = text;
        tField.textColor = color;
        view.addChild(tField);

        TweenUtil.tween(tField, 2000, { alpha: 0, onComplete: function():void{DisplayObjectUtil.tryRemove(tField)}});
    }
}
}
