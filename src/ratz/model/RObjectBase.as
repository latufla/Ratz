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
import ratz.utils.StarlingAssetsLib;

public class RObjectBase extends ObjectBase {

    protected var _ammunition:AmmunitionInfo;

    protected var _pivotX:int = 16;
    protected var _pivotY:int = 48;

    public function RObjectBase() {
        super();
    }

    public static function create(libDesc:String, pos:Point, shapes:Vector.<CustomShape>, material:CustomMaterial, interactionGroup:int):RObjectBase{
        var obj:RObjectBase = new RObjectBase();
        obj.libDesc = libDesc;
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

    override public function createAsset():*{
        return StarlingAssetsLib.instance.getAssetBy(_libDesc);
    }

    public function get ammunition():AmmunitionInfo {
        return _ammunition;
    }

    public function set ammunition(value:AmmunitionInfo):void {
        _ammunition = value;
    }

    public function get pivotX():int {
        return _pivotX;
    }

    public function set pivotX(value:int):void {
        _pivotX = value;
    }

    public function get pivotY():int {
        return _pivotY;
    }

    public function set pivotY(value:int):void {
        _pivotY = value;
    }
}
}
