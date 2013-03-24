/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.03.13
 * Time: 13:36
 * To change this template use File | Settings | File Templates.
 */
package ratz.model {
import core.model.ObjectBase;
import core.utils.nape.CustomMaterial;
import core.utils.nape.CustomShape;

import flash.geom.Point;

import ratz.model.info.AmmunitionInfo;

public class RObjectBase extends ObjectBase {

    protected var _ammunition:AmmunitionInfo;
    public function RObjectBase() {
        super();
    }

    public static function create(pos:Point, shapes:Vector.<CustomShape>, material:CustomMaterial, interactionGroup:int):RObjectBase{
        var obj:RObjectBase = new RObjectBase();
        obj.shapes = shapes;
        obj.material = material;
        obj.position = pos;
        obj.interactionGroup = interactionGroup;

        return obj;
    }

    override protected function init():void{
        super.init();

        _ammunition = new AmmunitionInfo();
    }

    public function get ammunition():AmmunitionInfo {
        return _ammunition;
    }

    public function set ammunition(value:AmmunitionInfo):void {
        _ammunition = value;
    }
}
}
