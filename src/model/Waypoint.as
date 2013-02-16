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
        trace("register:", name, obj.name);
    }

    public function unregister(obj:ObjectBase):void{
        VectorUtil.removeElement(_registeredObjects, obj);
    }

    public function unregisterAll():void{
        _registeredObjects = new Vector.<ObjectBase>();
    }

    public function isRegistered(obj:ObjectBase):Boolean{
        return _registeredObjects.indexOf(obj) != -1;
    }
}
}
