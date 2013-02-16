/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.02.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package model {
import model.Waypoint;

import utils.VectorUtil;

public class WaypointSequence {

    private var _list:Vector.<Waypoint> = new Vector.<Waypoint>(); // order matters
    private var _lastVisited:Waypoint;

    private var _allPassedCb:Function;

    public function WaypointSequence() {
    }

    public function add(wp:Waypoint):void{
        _list.push(wp);
        wp.name = "Waypoint " + _list.length;
    }

    public function remove(wp:Waypoint):void{
        VectorUtil.removeElement(_list, wp);
    }

    public function visit(wp:Waypoint, obj:ObjectBase):void{
        if(sequenceCompleted(wp, obj)){
            if(_allPassedCb != null)
                _allPassedCb();

            unregisterFromAll(obj);
            _lastVisited = null;
        }

        tryRegister(wp, obj);
        _lastVisited = wp;
    }

    public function set allPassedCb(value:Function):void {
        _allPassedCb = value;
    }

    private function tryRegister(wp:Waypoint, obj:ObjectBase):void {
        var prevWp:Waypoint = getPrev(wp);
        if(!_lastVisited || (_lastVisited == prevWp && prevWp.isRegistered(obj))){
            if(!wp.isRegistered(obj))
                wp.register(obj);
        }
    }

    private function unregisterFromAll(obj:ObjectBase):void{
        for each(var p:Waypoint in _list){
            p.unregister(obj);
        }
    }

    private function getPrev(wp:Waypoint):Waypoint{
        var curWpIdx:int = _list.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var prevWpIdx:uint = curWpIdx != 0 ? curWpIdx - 1 : _list.length - 1;
        return _list[prevWpIdx];
    }

    private function sequenceCompleted(wp:Waypoint, obj:ObjectBase):Boolean {
        if(_lastVisited != getPrev(wp))
            return false;

        var passLap:Boolean;
        for each(var p:Waypoint in _list){
            passLap = p.isRegistered(obj);
            if(!passLap)
                break;
        }

        return passLap;
    }

}
}
