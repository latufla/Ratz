/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.03.13
 * Time: 18:59
 * To change this template use File | Settings | File Templates.
 */
package ratz.controller {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;

import flash.geom.Point;

import ratz.model.RObjectBase;

public class RControllerBase extends ControllerBase{

    public function RControllerBase() {
        super();
    }

    public static function create(obj:ObjectBase, behaviors:Vector.<BehaviorBase> = null):RControllerBase{
        var c:RControllerBase = new RControllerBase();
        c.object = obj;
        for each(var p:BehaviorBase in behaviors){
            c.addBehavior(p);
        }

        return c;
    }

    override protected function align():void {
        var obj:RObjectBase = _object as RObjectBase;
        _view.pivotX = obj.pivotX;
        _view.pivotY = obj.pivotY;

        var pos:Point = _object.position;
        _view.x = pos.x;
        _view.y = pos.y;

        _view.rotation = _object.rotation;
    }
}
}
