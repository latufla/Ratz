/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:35
 * To change this template use File | Settings | File Templates.
 */
package ratz.debug {
import flash.text.TextField;

import core.model.Ammunition;

import core.utils.TweenUtil;

public class AmmunitionPanel extends DebugAmmunitionPanelView{

    private static var DIFF_COLORS:Array = [0xFF0000, 0x00FF00]
    public function AmmunitionPanel() {
    }

    public function set data(value:Ammunition):void{
        refreshField(aShotsField, String(value.shots));
        refreshField(aBoostField, String(value.boost));
        refreshField(aTrapsField, String(value.traps));
        refreshField(aHealthField, String(value.health));
    }

    private function refreshField(f:TextField, text:String):void {
        var diff:int = int(text) - int(f.text);
        if(diff == 0)
            return;

        var color:uint = DIFF_COLORS[int(diff > 0)];
        var tx:int = f.x;
        var ty:int = f.y;
        f.textColor = color;
        TweenUtil.tween(f, 200, {x: tx - (f.width * 1.5 / 6), y: ty - (f.height * 1.5 / 6), scaleX: 1.5, scaleY: 1.5,
            onComplete: function():void{
                f.textColor = 0x000000;
                TweenUtil.tween(f, 100, {x: tx, y: ty, scaleX: 1, scaleY: 1});
            }
        });

        f.text = text;
    }
}
}
