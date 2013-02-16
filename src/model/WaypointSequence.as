/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.02.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package model {
import utils.VectorUtil;

public class WaypointSequence {

    private var _list:Vector.<Waypoint> = new Vector.<Waypoint>(); // order matters
    private var _lastVisited:Waypoint;

    private var _allVisitedCb:Function;

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
        if(!_lastVisited){

            if(wp.indexOf(obj) == -1)
                wp.register(obj);

            _lastVisited = wp;
            return;
        }

        var passLap:Boolean;
        for each(var p:Waypoint in _list){
            passLap = (p.indexOf(obj) != -1);
            if(!passLap)
                break;
        }

        if(passLap){
            if(_allVisitedCb != null)
                _allVisitedCb();

            unregisterFromAll(obj);
            _list[0].register(obj);
        }

        var prevWp:Waypoint = getPrevWaypoint(wp);
        if(_lastVisited == prevWp && prevWp.indexOf(obj) != -1){
            if(wp.indexOf(obj) == -1)
                wp.register(obj);
        }
        _lastVisited = wp;
    }

    public function set allVisitedCb(value:Function):void {
        _allVisitedCb = value;
    }

    private function unregisterFromAll(obj:ObjectBase):void{
        for each(var p:Waypoint in _list){
            p.unregister(obj);
        }
    }

    private function getPrevWaypoint(wp:Waypoint):Waypoint{
        var curWpIdx:int = _list.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var prevWpIdx:uint = curWpIdx != 0 ? curWpIdx - 1 : _list.length - 1;
        return _list[prevWpIdx];
    }


}
}
