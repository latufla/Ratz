/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.02.13
 * Time: 20:52
 * To change this template use File | Settings | File Templates.
 */
package managers {
import controller.ControllerBase;

import flash.geom.Point;

import flash.geom.Rectangle;

import model.ObjectBase;
import model.Waypoint;

import utils.Config;
import utils.RPolygon;
import utils.RShape;

import utils.VectorUtil;

public class WaypointManager {


    // TODO: use Vector.<ControllerBase>
    private var _waypointSequence:Vector.<Waypoint> = new Vector.<Waypoint>(); // order matters

    private static var _instance:WaypointManager;
    public function WaypointManager() {

    }

    public static function get instance():WaypointManager {
        _instance ||= new WaypointManager();
        return _instance;
    }

    public function init(wps:Vector.<Rectangle>):void{
        for each(var p:Rectangle in wps){
            var wp:Waypoint = new Waypoint();
            wp.position = new Point(p.x, p.y);
            wp.shapes = new <RShape>[new RPolygon(0, 0, p.width, p.height)];
            wp.name = "Waypoint " + p.x + "" + p.y;
            wp.isPseudo = true;
            add(wp);
        }
    }

    public function add(wp:Waypoint):void{
        _waypointSequence.push(wp);
        wp.addInteractionListener(onInteraction);

        Config.field.add(ControllerBase.create(wp));
    }

    private function onInteraction(wp:ObjectBase, rat:ObjectBase):void {

        if(!(wp is Waypoint) || rat.name != "rat" || (wp as Waypoint).indexOf(rat) != -1)
            return;

        var wpIdx:int = _waypointSequence.indexOf(wp);
        if(wpIdx == -1)
            return;

        var passAllPrevWaypoints:Boolean = true;
        for (var i:int = 0; i < wpIdx; i++) {
            passAllPrevWaypoints = (_waypointSequence[i].indexOf(rat) != -1);
            if(!passAllPrevWaypoints)
                break;

        }
        if(passAllPrevWaypoints){

            trace(VectorUtil.getDirection(new Point(rat.bounds.x, rat.bounds.y)), (wp as Waypoint).getDirectionTo(getPrevWaypoint(wp as Waypoint)));
            //(wp as Waypoint).getDirectionTo(getPrevWaypoint(wp as Waypoint))
            (wp as Waypoint).register(rat);
            trace(wp.name, rat.name);
        }

    }

    public function remove(wp:Waypoint):void{
        VectorUtil.removeElement(_waypointSequence, wp);
        wp.removeInteractionListener(onInteraction);
    }

    public function unregisterFromAll(obj:ObjectBase):void{
        for each(var p:Waypoint in _waypointSequence){
            p.unregister(obj);
        }
    }

    public function clearAllRegistrations():void{
        for each(var p:Waypoint in _waypointSequence){
            p.unregisterAll();
        }
    }

    private function getPrevWaypoint(wp:Waypoint):Waypoint{
        var curWpIdx:int = _waypointSequence.indexOf(wp);
        if(curWpIdx == -1)
            return null;

        var prevWpIdx:uint = curWpIdx != 0 ? curWpIdx - 1 : _waypointSequence.length - 1;
        return _waypointSequence[prevWpIdx];
    }
}
}
