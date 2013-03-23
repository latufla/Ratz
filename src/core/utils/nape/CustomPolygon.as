/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 16:17
 * To change this template use File | Settings | File Templates.
 */
package core.utils.nape {
import flash.geom.Rectangle;

import nape.shape.Polygon;
import nape.shape.Shape;

public class CustomPolygon extends CustomShape{

    private var _size:Rectangle;
    public function CustomPolygon(x:int, y:int, w:int, h:int) {
        _size = new Rectangle(x, y, w, h);
    }

    public function get size():Rectangle {
        return _size;
    }

    public function set size(value:Rectangle):void {
        _size = value;
    }

    public function clone():CustomPolygon{
        return new CustomPolygon(_size.x, _size.y, _size.width, _size.height);
    }

    override public function toPhysEngineObj():Shape{
        return new Polygon(Polygon.rect(_size.x, _size.y, _size.width, _size.height));
    }
}
}
