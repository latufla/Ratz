/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 19:10
 * To change this template use File | Settings | File Templates.
 */
package utils {
import flash.geom.Point;

public class VectorUtil {

    public static function removeElement(v:*, e:*):void{
        if(!v)
            return;

        var idx:int = v.indexOf(e);
        if(idx != -1)
            v.splice(idx, 1);
    }

    public static function getDirection(v:Point):Point{
        var dir:Point = v.clone();
        dir.x = dir.x != 0 ? dir.x / Math.abs(dir.x) : 0;
        dir.y = dir.y != 0 ? dir.y / Math.abs(dir.y) : 0;

        return dir;
    }

}
}
