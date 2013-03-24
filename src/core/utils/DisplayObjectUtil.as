/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 13:54
 * To change this template use File | Settings | File Templates.
 */
package core.utils {
import core.utils.geom.Line;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;

public class DisplayObjectUtil {

    public static function tryRemove(view:DisplayObject):void{
        if(view.parent)
            view.parent.removeChild(view);
    }

    public static function removeAll(view:DisplayObjectContainer):void{
        while(view.numChildren != 0)
            view.removeChildAt(0);
    }

    public static function drawLine(g:Graphics, l:Line, color:uint = 0xFF0000):void{
        g.lineStyle(1, color);
        g.moveTo(l.begin.x, l.begin.y);
        g.lineTo(l.end.x, l.end.y);
        g.endFill();
    }
}
}
