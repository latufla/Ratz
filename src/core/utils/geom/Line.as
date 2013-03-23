/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 01.03.13
 * Time: 18:05
 * To change this template use File | Settings | File Templates.
 */
package core.utils.geom {
import core.utils.MathUtil;

import flash.geom.Point;

// VH and from smaller coords to bigger
public class Line {

    private var _begin:Point;
    private var _end:Point;

    public function Line(begin:Point, end:Point) {
        _begin = begin;
        _end = end;
    }

    public function getPointProjection(p:Point):Point{
        var vn:Point = _end.subtract(_begin); //сдвинем точку "a" в начало координат
        vn.normalize(1);    //нормализуем вектор
        var vp:Point = p.subtract(_begin);   //превратим точку в вектор с началом в начале координат
        var f:int = MathUtil.scalarMul(vn,vp); //скалярное произведение, порядок не важен
        return _begin.add(new Point(vn.x * f,  vn.y * f));            //спроецированная точка
    }

    public function getEvenDistributedPoints(amount:uint = 10):Vector.<Point>{
        if(amount == 0)
            return null;

        var interval:Point = _end.subtract(_begin);
        interval.x = interval.x / amount;
        interval.y = interval.y / amount;
        return getPointsViaInterval(interval);
    }

    private function getPointsViaInterval(interval:Point):Vector.<Point>{
        var pts:Vector.<Point> = new Vector.<Point>();
        var pt:Point = _begin.clone();

        do{
            pts.push(pt);
            pt = pt.clone().add(interval);
        } while(pt.x <= _end.x && pt.y <= _end.y)

        pts[pts.length - 1] = _end.clone();
        return pts;
    }

    public function get begin():Point {
        return _begin;
    }

    public function set begin(value:Point):void {
        _begin = value;
    }

    public function get end():Point {
        return _end;
    }

    public function set end(value:Point):void {
        _end = value;
    }
}
}
