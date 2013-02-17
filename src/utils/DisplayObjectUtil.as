/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 13:54
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.display.DisplayObject;

public class DisplayObjectUtil {

    public static function tryRemove(view:DisplayObject):void{
        if(view.parent)
            view.parent.removeChild(view);
    }
}
}
