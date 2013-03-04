/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.12.12
 * Time: 17:57
 * To change this template use File | Settings | File Templates.
 */
package utils {
import event.CustomEvent;
import event.GameEvent;
import flash.events.IEventDispatcher;

public class ObjectUtil {
    public function ObjectUtil() {
    }

    public static function debugTrace(o:*):void{
        for (var p:String in o){
            trace(p, o[p]);
        }
    }

    public static function addEventListeners(o:IEventDispatcher, events:Vector.<String>, handler:Function):void{
        for each(var p:String in events){
            o.addEventListener(p, handler);
        }
    }
}
}
