/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 15.02.13
 * Time: 20:52
 * To change this template use File | Settings | File Templates.
 */
package ratz.managers {
import core.behaviors.BehaviorBase;
import core.controller.ControllerBase;
import core.model.ObjectBase;
import core.utils.GuiUtil;
import core.utils.MathUtil;
import core.utils.geom.Line;
import core.utils.nape.CustomPolygon;
import core.utils.nape.CustomShape;

import flash.geom.Point;

import ratz.Ratz;
import ratz.behaviors.WaypointItemBehavior;
import ratz.behaviors.gameplay.RatMoveBehavior;
import ratz.model.Field;
import ratz.model.WaypointSequence;
import ratz.model.info.UserInfo;
import ratz.utils.Config;

public class WaypointManager{

    private var _waypointSequence:WaypointSequence; // order matters
    private var _raceInfo:Field;

    private static var _instance:WaypointManager;
    public function WaypointManager() {

    }

    public static function get instance():WaypointManager {
        _instance ||= new WaypointManager();
        return _instance;
    }

    public function init(raceInfo:Field):void{
        _waypointSequence = new WaypointSequence();
        _waypointSequence.completeCb = onEndLap;

        for each(var p:Object in raceInfo.waypoints){
            var wp:ObjectBase = new ObjectBase();
            wp.position = new Point(p.rect.x, p.rect.y);
            wp.shapes = new <CustomShape>[new CustomPolygon(0, 0, p.rect.width, p.rect.height)];
            add(wp, p);
        }
        _waypointSequence.computeDirections();

        _raceInfo = raceInfo;
    }

    public function correctToNextWaypointWhenRespawn(obj:ObjectBase):void {
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var prevRegisteredWpB:WaypointItemBehavior = _waypointSequence.getPrevWaypoint(lastVisitedWpB);
        var nextRegisteredWpB:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var lastVisWp:ObjectBase = Config.fieldController.getControllerByBehavior(lastVisitedWpB).object;
        var nextRegWp:ObjectBase = Config.fieldController.getControllerByBehavior(nextRegisteredWpB).object;
        if(lastVisWp.bounds.intersects(obj.bounds)){ // TODO: diiiiiirty one
            obj.rotation = MathUtil.angleFromVector(lastVisWp.getDirectionTo(nextRegWp));
            obj.position = lastVisWp.center;
        } else{
            var prevRegWp:ObjectBase = Config.fieldController.getControllerByBehavior(prevRegisteredWpB).object;

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

    // TODO: resolve finish line better
    public function getActualDirection(obj:ObjectBase, intelligence:uint = 0):Point{
        var lastWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        if(!lastWpB)
            return null;

        var nextWpB:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastWpB);
        if(nextWpB.containsObject(obj) || nextWpB.isFinish) // corner or finish line, which we simply pass
            return nextWpB.directionToNext;

        return obj.getDirectionToPoint(nextWpB.getTurnPoint(intelligence));
    }

    public function getSmartDistanceToFinishLine(obj:ObjectBase):int{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);
        var lastRegisteredWpB:WaypointItemBehavior = _waypointSequence.getLastRegisteredWaypointFor(obj);
        var nextToRegister:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastRegisteredWpB);

        if(!nextToVisit || !nextToRegister)
            return 0;

        var projToWpInLine:Point = nextToVisit.containsObject(obj) ? nextToVisit.getProjectionToOutLine(obj.position) : nextToVisit.getProjectionToInLine(obj.position);
        var dist1:int = obj.getVectorToPoint(projToWpInLine).length;

        var wpsTillNextToRegister:Vector.<WaypointItemBehavior> = _waypointSequence.getWaypointsFromTo(nextToVisit, nextToRegister);
        var n:uint = wpsTillNextToRegister.length - 1; // without nextToRegister
        var dist2:int = 0;
        for (var i:uint = 0; i < n;i++){
            dist2 += wpsTillNextToRegister[i].distanceToNext;
        }

        var dist3:int = nextToRegister.isFinish ? 0 : nextToRegister.distanceToFinishWaypoint;
        return dist1 + dist2 + dist3;
    }

    public function getLineToNextWaypoint(obj:ObjectBase):Line{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextWpBToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var nextWpToVisitC:ControllerBase = Config.fieldController.getControllerByBehavior(nextWpBToVisit);
        if(!nextWpToVisitC)
            return null;

        var nextWpToVisit:ObjectBase = nextWpToVisitC.object;
        var begin:Point = obj.position;
        var end:Point = nextWpToVisit.position;
        return new Line(begin, end);
    }

    public function getNormalToNextWaypoint(obj:ObjectBase):Line{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextWpBToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);
        if(!nextWpBToVisit)
            return null;

        var begin:Point = obj.position;
        var end:Point = nextWpBToVisit.containsObject(obj) ? nextWpBToVisit.getProjectionToOutLine(begin) : nextWpBToVisit.getProjectionToInLine(begin);
        return new Line(begin, end);
    }

    private function add(wp:ObjectBase, params:Object):void{
        var wpBehavior:WaypointItemBehavior = WaypointItemBehavior.create(params.inLine, params.outLine,
                new <Function>[null, null, onEndInteraction], params.isFinish);
        _waypointSequence.add(wpBehavior);

        var wpc:ControllerBase = ControllerBase.create(wp, new <BehaviorBase>[wpBehavior]);
        Config.fieldController.add(wpc);
    }

    private function onEndInteraction(wp:ObjectBase, obj:ObjectBase):void {
        var ratC:ControllerBase = obj.controller;
        if(!ratC.isRat)
            return;

        var wpc:ControllerBase = wp.controller;
        var wpBehavior:WaypointItemBehavior = wpc.getBehaviorByClass(WaypointItemBehavior) as WaypointItemBehavior;
        _waypointSequence.visit(wpBehavior, obj);
    }

    private function onEndLap(obj:ObjectBase):void{
        var racerInfo:UserInfo = _raceInfo.getRacerByName(obj.name);
        if(++racerInfo.currentLap >= _raceInfo.laps){
            obj.controller.stopBehaviors();
            obj.controller.startBehaviorByClass(RatMoveBehavior);
        }

        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 320), "Lap " + racerInfo.currentLap + " End By "+ obj.name, 30, 0x0000FF);
    }
}
}
