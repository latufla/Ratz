/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.02.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package model {
import behaviors.core.WaypointItemBehavior;
import utils.VectorUtil;

public class WaypointSequence {

    private var _list:Vector.<WaypointItemBehavior> = new Vector.<WaypointItemBehavior>(); // order matters
    private var _lastVisited:WaypointItemBehavior;

    private var _completeCb:Function;

    public function WaypointSequence() {
    }

    public function add(wp:WaypointItemBehavior):void{
        _list.push(wp);

        wp.name = "Waypoint " + _list.length;
    }

    public function remove(wp:WaypointItemBehavior):void{
        VectorUtil.removeElement(_list, wp);
    }

    public function visit(wp:WaypointItemBehavior, obj:ObjectBase):void{
        if(sequenceCompleted(wp, obj)){
            if(_completeCb != null)
                _completeCb(obj);

            unregisterFromAll(obj);
            _lastVisited = null;
        }

        tryRegister(wp, obj);
        _lastVisited = wp;
    }

    public function set completeCb(value:Function):void {
        _completeCb = value;
    }

    private function tryRegister(wp:WaypointItemBehavior, obj:ObjectBase):void {
        var prevWp:WaypointItemBehavior = getPrev(wp);
        if(!_lastVisited || (_lastVisited == prevWp && prevWp.isRegistered(obj))){
            if(!wp.isRegistered(obj))
                wp.register(obj);
        }
    }

    private function unregisterFromAll(obj:ObjectBase):void{
        for each(var p:WaypointItemBehavior in _list){
            p.unregister(obj);
        }
    }

    private function getPrev(wp:WaypointItemBehavior):WaypointItemBehavior{
        var curWpIdx:int = _list.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var prevWpIdx:uint = curWpIdx != 0 ? curWpIdx - 1 : _list.length - 1;
        return _list[prevWpIdx];
    }

    private function sequenceCompleted(wp:WaypointItemBehavior, obj:ObjectBase):Boolean {
        if(_lastVisited != getPrev(wp))
            return false;

        var passLap:Boolean;
        for each(var p:WaypointItemBehavior in _list){
            passLap = p.isRegistered(obj);
            if(!passLap)
                break;
        }

        return passLap;
    }

}
}
