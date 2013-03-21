/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 16.02.13
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
package model {
import behaviors.core.WaypointItemBehavior;

import flash.utils.Dictionary;

import utils.Config;

public class WaypointSequence {

    private var _list:Vector.<WaypointItemBehavior>; // order matters
    private var _lastVisitedWaypoints:Dictionary; // ObjectBase -> WaypointItemBehavior

    private var _completeCb:Function;

    public function WaypointSequence() {
        init();
    }

    private function init():void {
        _list = new Vector.<WaypointItemBehavior>();
        _lastVisitedWaypoints = new Dictionary();
    }

    public function add(wp:WaypointItemBehavior):void{
        _list.push(wp);

        wp.name = "Waypoint " + _list.length;
    }

    public function computeDirections():void {
        var nextWpB:WaypointItemBehavior;
        var nextWp:ObjectBase;
        var wp:ObjectBase;
        var wpB:WaypointItemBehavior;
        var n:uint = _list.length;
        for (var i:int = 0; i < n; i++) {
            wpB = _list[i];
            wp = Config.field.getControllerByBehavior(wpB).object;
            nextWpB = getNextWaypoint(wpB);
            nextWp = Config.field.getControllerByBehavior(nextWpB).object;
            wpB.vectorToNext = wp.getVectorTo(nextWp);
        }

        for (i = 0; i < n; i++) { // TODO: join with prev loop
            computeDistanceToFinishWaypoint(_list[i], i);
        }

    }

    private function computeDistanceToFinishWaypoint(wpB:WaypointItemBehavior, id:uint):void{
        var dist:int;
        var n:uint = _list.length;
        for (var i:int = id; i < n; i++) {
            dist += _list[i].vectorToNext.length;
        }

        wpB.distanceToFinishWaypoint = dist;
    }

    public function visit(wp:WaypointItemBehavior, obj:ObjectBase):void{
        if(sequenceCompleted(wp, obj)){
            if(_completeCb != null)
                _completeCb(obj);

            unregisterFromAll(obj);
            delete _lastVisitedWaypoints[obj.name];
        }

        tryRegister(wp, obj);
        _lastVisitedWaypoints[obj.name] = wp;
    }

    public function set completeCb(value:Function):void {
        _completeCb = value;
    }

    public function get list():Vector.<WaypointItemBehavior> {
        return _list;
    }

    public function getLastWaypointVisitedBy(obj:ObjectBase):WaypointItemBehavior{
        return _lastVisitedWaypoints[obj.name];
    }

    public function getLastRegisteredWaypointFor(obj:ObjectBase):WaypointItemBehavior{
        for (var i:int = _list.length - 1; i >=0; i--){
            if(_list[i].isRegistered(obj))
                return _list[i];
        }
        return null;
    }

    public function getWaypointsFromTo(fromWp:WaypointItemBehavior, toWp:WaypointItemBehavior):Vector.<WaypointItemBehavior>{
        var res:Vector.<WaypointItemBehavior> = new Vector.<WaypointItemBehavior>();
        var nextWp:WaypointItemBehavior = fromWp;
        res.push(nextWp);
        while(nextWp != toWp){
            nextWp = getNextWaypoint(nextWp);
            res.push(nextWp);
        }

        return res;
    }

    private function tryRegister(wp:WaypointItemBehavior, obj:ObjectBase):void {
        var prevWp:WaypointItemBehavior = getPrevWaypoint(wp);
        if(!_lastVisitedWaypoints[obj.name] || (_lastVisitedWaypoints[obj.name] == prevWp && prevWp.isRegistered(obj))){
            if(!wp.isRegistered(obj))
                wp.register(obj);
        }
    }

    private function unregisterFromAll(obj:ObjectBase):void{
        for each(var p:WaypointItemBehavior in _list){
            p.unregister(obj);
        }
    }

    public function getPrevWaypoint(wp:WaypointItemBehavior):WaypointItemBehavior{
        var curWpIdx:int = _list.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var prevWpIdx:uint = curWpIdx != 0 ? curWpIdx - 1 : _list.length - 1;
        return _list[prevWpIdx];
    }

    public function getNextWaypoint(wp:WaypointItemBehavior):WaypointItemBehavior{
        var curWpIdx:int = _list.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var nextWpIdx:uint = curWpIdx != _list.length - 1 ? curWpIdx + 1 : 0;
        return _list[nextWpIdx];
    }

    private function sequenceCompleted(wp:WaypointItemBehavior, obj:ObjectBase):Boolean {
        if(_lastVisitedWaypoints[obj.name] != getPrevWaypoint(wp))
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
