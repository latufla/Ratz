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
import model.WaypointSequence;

import utils.Config;
import utils.RPolygon;
import utils.RShape;

import utils.VectorUtil;

public class WaypointManager {

    private var _waypointSequence:WaypointSequence = new WaypointSequence(); // order matters

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
            wp.isPseudo = true;
            add(wp);
        }

        _waypointSequence.allPassedCb = onSequenceFinish;
    }

    public function add(wp:Waypoint):void{
        _waypointSequence.add(wp)
        wp.addInteractionListener(onInteraction);

        Config.field.add(ControllerBase.create(wp));
    }

    private function onInteraction(wp:Waypoint, rat:ObjectBase):void {
        if(rat.name != "rat")
            return;

        _waypointSequence.visit(wp, rat);
    }

    private function onSequenceFinish():void{
        trace("End Lap");
    }

//    public function remove(wp:Waypoint):void{
//        VectorUtil.removeElement(_waypointSequence, wp);
//        wp.removeInteractionListener(onInteraction);
//    }
}
}
