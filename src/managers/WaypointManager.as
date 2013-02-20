/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.02.13
 * Time: 20:52
 * To change this template use File | Settings | File Templates.
 */
package managers {
import behaviors.BehaviorBase;
import behaviors.core.WaypointItemBehavior;

import controller.ControllerBase;

import flash.geom.Point;

import flash.geom.Rectangle;

import model.ObjectBase;
import model.WaypointSequence;

import utils.Config;
import utils.GuiUtil;
import utils.RPolygon;
import utils.RShape;

import utils.VectorUtil;

public class WaypointManager {

    private var _waypoints:WaypointSequence = new WaypointSequence(); // order matters

    private static var _instance:WaypointManager;
    public function WaypointManager() {

    }

    public static function get instance():WaypointManager {
        _instance ||= new WaypointManager();
        return _instance;
    }

    public function init(wps:Vector.<Rectangle>):void{
        for each(var p:Rectangle in wps){
            var wp:ObjectBase = new ObjectBase();
            wp.position = new Point(p.x, p.y);
            wp.shapes = new <RShape>[new RPolygon(0, 0, p.width, p.height)];
            add(wp);
        }

        _waypoints.completeCb = onSequenceComplete;
    }

    private function add(wp:ObjectBase):void{
        var wpBehavior:WaypointItemBehavior = new WaypointItemBehavior(onInteraction);
        _waypoints.add(wpBehavior);

        var wpc:ControllerBase = ControllerBase.create(wp, new <BehaviorBase>[wpBehavior]);
        wpc.startBehaviors();
        Config.field.add(wpc);
    }

    private function onInteraction(wp:ObjectBase, rat:ObjectBase):void {
        var ratC:ControllerBase = Config.field.getControllerByObject(rat);
        if(!ratC.isRat)
            return;

        var wpc:ControllerBase = Config.field.getControllerByObject(wp);
        var wpBehavior:WaypointItemBehavior = wpc.getBehaviorByClass(WaypointItemBehavior) as WaypointItemBehavior;
        _waypoints.visit(wpBehavior, rat);
    }

    private function onSequenceComplete(obj:ObjectBase):void{
        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 320), "Lap End By "+ obj.name, 30, 0x0000FF);
    }
}
}
