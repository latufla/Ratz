/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 13:07
 * To change this template use File | Settings | File Templates.
 */
package utils {
import com.greensock.TweenLite;

public class TweenUtil {

    public static function tween(obj:*, time:Number, params:Object):void{
        TweenLite.to(obj, time / 1000, params);
    }

}
}
