/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.12.12
 * Time: 17:57
 * To change this template use File | Settings | File Templates.
 */
package core.utils {
public class ObjectUtil {
    public function ObjectUtil() {
    }

    public static function debugTrace(o:*):void{
        for (var p:* in o){
            trace(p, o[p]);
        }
    }
}
}
