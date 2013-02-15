/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.02.13
 * Time: 20:08
 * To change this template use File | Settings | File Templates.
 */
package model {
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import utils.VectorUtil;

public class Waypoint extends ObjectBase{

    private var _registeredObjects:Vector.<ObjectBase>;

    public function Waypoint() {
        super();
        init();
    }

    private function init():void {
        _registeredObjects = new Vector.<ObjectBase>();
    }

    public function register(obj:ObjectBase):void{
        _registeredObjects.push(obj);
    }

    public function unregister(obj:ObjectBase):void{
        VectorUtil.removeElement(_registeredObjects, obj);
    }

    public function unregisterAll():void{
        _registeredObjects = new Vector.<ObjectBase>();
    }

    public function indexOf(obj:ObjectBase):int{
        return _registeredObjects.indexOf(obj);
    }
}
}
