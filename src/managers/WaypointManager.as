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
import behaviors.core.WaypointItemBehavior;

import controller.ControllerBase;

import event.CustomEvent;

import flash.events.EventDispatcher;

import flash.geom.Point;

import flash.geom.Rectangle;

import model.ObjectBase;
import model.WaypointSequence;

import utils.Config;
import utils.GuiUtil;
import utils.MathUtil;
import utils.nape.RPolygon;
import utils.nape.RShape;

public class WaypointManager extends EventDispatcher{

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
            var wp:ObjectBase = new ObjectBase();
            wp.position = new Point(p.x, p.y);
            wp.shapes = new <RShape>[new RPolygon(0, 0, p.width, p.height)];
            add(wp);
        }

        _waypointSequence.completeCb = onSequenceComplete;
    }

    public function get waypoints():Vector.<ControllerBase>{
        var wpBehaviors:Vector.<WaypointItemBehavior> = _waypointSequence.list;
        var wps:Vector.<ControllerBase> = new Vector.<ControllerBase>();
        for each(var p:WaypointItemBehavior in wpBehaviors){
            wps.push(Config.field.getControllerByBehavior(p));
        }
        return wps;
    }

    public function correctToNextWaypointWhenRespawn(obj:ObjectBase):void {
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var prevRegisteredWpB:WaypointItemBehavior = _waypointSequence.getPrevWaypoint(lastVisitedWpB);
        var nextRegisteredWpB:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var lastVisWp:ObjectBase = Config.field.getControllerByBehavior(lastVisitedWpB).object;
        var nextRegWp:ObjectBase = Config.field.getControllerByBehavior(nextRegisteredWpB).object;
        if(lastVisWp.intersects(obj)){
            obj.rotation = MathUtil.angleFromVector(lastVisWp.getDirectionTo(nextRegWp));
            obj.position = lastVisWp.center;
        } else{
            var prevRegWp:ObjectBase = Config.field.getControllerByBehavior(prevRegisteredWpB).object;

            var lastToPrev:Point = lastVisWp.getDirectionTo(prevRegWp);
            var lastToNext:Point = lastVisWp.getDirectionTo(nextRegWp);
            var lastToObj:Point = lastVisWp.getDirectionTo(obj);

            var lastToPrevAngleDiff:Number = Math.abs(MathUtil.angleFromVector(lastToObj) - MathUtil.angleFromVector(lastToPrev));
            var lastToNextAngleDiff:Number = Math.abs(MathUtil.angleFromVector(lastToObj) - MathUtil.angleFromVector(lastToNext));

            if(lastToPrevAngleDiff < lastToNextAngleDiff)
                obj.rotation = MathUtil.angleFromVector(prevRegWp.getDirectionTo(lastVisWp));
            else
                obj.rotation = MathUtil.angleFromVector(lastVisWp.getDirectionTo(nextRegWp));
        }
    }

    private function add(wp:ObjectBase):void{
        var wpBehavior:WaypointItemBehavior = new WaypointItemBehavior(onInteraction);
        _waypointSequence.add(wpBehavior);

        var wpc:ControllerBase = ControllerBase.create(wp, new <BehaviorBase>[wpBehavior]);
        Config.field.add(wpc);
    }

    private function onInteraction(wp:ObjectBase, obj:ObjectBase):void {
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;

        var wpc:ControllerBase = wp.controller;
        var wpBehavior:WaypointItemBehavior = wpc.getBehaviorByClass(WaypointItemBehavior) as WaypointItemBehavior;
        _waypointSequence.visit(wpBehavior, obj);

        var nextWpB:WaypointItemBehavior = _waypointSequence.getNextWaypoint(wpBehavior);
        var nextWpC:ControllerBase = Config.field.getControllerByBehavior(nextWpB);
        dispatchEvent(new CustomEvent(CustomEvent.WAYPOINT_VISIT, {waypoint: wp, nextToVisitWaypoint: nextWpC.object, object: obj}));
    }

    private function onSequenceComplete(obj:ObjectBase):void{
        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 320), "Lap End By "+ obj.name, 30, 0x0000FF);
    }
}
}
