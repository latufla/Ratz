/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.01.13
 * Time: 16:12
 * To change this template use File | Settings | File Templates.
 */
package utils {
import nape.phys.Material;

public class RMaterial {

    private var _elasticity:Number;
    private var _dynamicFriction:Number;
    private var _staticFriction:Number;
    private var _density:Number;
    private var _rollingFriction:Number;

    public function RMaterial(e:Number, dF:Number, sF:Number, d:Number, rF:Number) {
        _elasticity = e;
        _dynamicFriction = dF;
        _staticFriction = sF;
        _density = d;
        _rollingFriction = rF;
    }

    public function clone():RMaterial{
        return new RMaterial(_elasticity, _dynamicFriction, _staticFriction, _density, _rollingFriction);
    }

    public function get elasticity():Number {
        return _elasticity;
    }

    public function set elasticity(value:Number):void {
        _elasticity = value;
    }

    public function get dynamicFriction():Number {
        return _dynamicFriction;
    }

    public function set dynamicFriction(value:Number):void {
        _dynamicFriction = value;
    }

    public function get staticFriction():Number {
        return _staticFriction;
    }

    public function set staticFriction(value:Number):void {
        _staticFriction = value;
    }

    public function get density():Number {
        return _density;
    }

    public function set density(value:Number):void {
        _density = value;
    }

    public function get rollingFriction():Number {
        return _rollingFriction;
    }

    public function set rollingFriction(value:Number):void {
        _rollingFriction = value;
    }

    public function toPhysEngineObj():Material{
        return new Material(_elasticity, _dynamicFriction, _staticFriction, _density, _rollingFriction);
    }
}
}
