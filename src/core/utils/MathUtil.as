/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 22.02.13
 * Time: 12:38
 * To change this template use File | Settings | File Templates.
 */
package core.utils {
import flash.geom.Point;

import nape.geom.Vec2;

public class MathUtil {
    public static function angleFromVector(v:Point):Number{
        var v2:Vec2 = Vec2.fromPoint(v);
        return v2.angle + Math.PI / 2;
    }

    public static function vectorFromAngle(a:Number):Point{
        var v:Point = Vec2.fromPolar(1, a - Math.PI / 2).toPoint();
        return v;
    }

    // "-" - left hand
    public static function getAngleBetween(v1:Point, v2:Point):Number{
        var n:Number = (v1.x * v2.x + v1.y * v2.y);
        var d:Number = Math.sqrt((Math.pow(v1.x, 2) + Math.pow(v1.y, 2)) * (Math.pow(v2.x, 2) + Math.pow(v2.y, 2)));

        // v1.x, v1.y
        // v2.x, v2.y
        var mDet:Number = v1.x * v2.y - v2.x* v1.y;
        var sign:int = mDet / Math.abs(mDet);

        return Math.acos(n / d) * sign;
    }

    public static function scalarMul(v1:Point, v2:Point):int{
        return v1.x * v2.x + v1.y * v2.y;
    }
}
}
