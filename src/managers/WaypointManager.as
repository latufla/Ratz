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
import behaviors.gameplay.RatMoveBehavior;

import controller.ControllerBase;

import flash.display.Sprite;

import flash.geom.Point;

import model.ObjectBase;
import model.RaceInfo;
import model.UserInfo;
import model.WaypointSequence;

import utils.Config;
import utils.GuiUtil;
import utils.MathUtil;
import utils.nape.RPolygon;
import utils.nape.RShape;

public class WaypointManager{

    private var _waypointSequence:WaypointSequence; // order matters
    private var _raceInfo:RaceInfo;

    private static var _instance:WaypointManager;
    public function WaypointManager() {

    }

    public static function get instance():WaypointManager {
        _instance ||= new WaypointManager();
        return _instance;
    }

    public function init(raceInfo:RaceInfo):void{
        _waypointSequence = new WaypointSequence();
        _waypointSequence.completeCb = onEndLap;

        for each(var p:Object in raceInfo.waypoints){
            var wp:ObjectBase = new ObjectBase();
            wp.position = new Point(p.rect.x, p.rect.y);
            wp.shapes = new <RShape>[new RPolygon(0, 0, p.rect.width, p.rect.height)];
            add(wp, p);
        }
        _waypointSequence.computeDirections();

        _raceInfo = raceInfo;
    }

    public function resolveRacersProgress():void{
//        for each(var p:ControllerBase in Config.field.ratControllers){
//            var racerObj:ObjectBase = p.object;
//            var racerInfo:UserInfo = _raceInfo.getRacerByName(racerObj.name);
//        }
    }

    public function correctToNextWaypointWhenRespawn(obj:ObjectBase):void {
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var prevRegisteredWpB:WaypointItemBehavior = _waypointSequence.getPrevWaypoint(lastVisitedWpB);
        var nextRegisteredWpB:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var lastVisWp:ObjectBase = Config.field.getControllerByBehavior(lastVisitedWpB).object;
        var nextRegWp:ObjectBase = Config.field.getControllerByBehavior(nextRegisteredWpB).object;
        if(lastVisWp.bounds.intersects(obj.bounds)){ // TODO: diiiiiirty one
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

    public function getDistanceToFinishLine(obj:ObjectBase):int{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextWpBToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var nextWpToVisitC:ControllerBase = Config.field.getControllerByBehavior(nextWpBToVisit);
        if(!nextWpToVisitC)
            return 0;

        var nextWpToVisit:ObjectBase = nextWpToVisitC.object;
        var distToNextWpB:int = obj.getVectorTo(nextWpToVisit).length;
        var distFromNextToFinish:int = nextWpBToVisit.isFinish ? 0 : nextWpBToVisit.distanceToFinishWaypoint;
        return distToNextWpB + distFromNextToFinish;
    }

    public function getSmartDistanceToFinishLine(obj:ObjectBase):int{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);
        var lastRegisteredWpB:WaypointItemBehavior = _waypointSequence.getLastRegisteredWaypointFor(obj);
        var nextToRegister:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastRegisteredWpB);

        if(!nextToVisit || !nextToRegister)
            return 0;

        var nextToVisitC:ControllerBase = Config.field.getControllerByBehavior(nextToVisit);
        var nextToRegisterC:ControllerBase = Config.field.getControllerByBehavior(nextToRegister);
        if(!nextToVisitC || !nextToRegisterC)
            return 0;

        var nextWpToVisit:ObjectBase = nextToVisitC.object;
        var dist1:int = obj.getVectorTo(nextWpToVisit).length;

        var wpsTillNextToRegister:Vector.<WaypointItemBehavior> = _waypointSequence.getWaypointsFromTo(nextToVisit, nextToRegister);
        var n:uint = wpsTillNextToRegister.length - 1; // without nextToRegister
        var dist2:int = 0;
        for (var i:uint = 0; i < n;i++){
            dist2 += wpsTillNextToRegister[i].distanceToNext;
        }

        var dist3:int = nextToRegister.isFinish ? 0 : nextToRegister.distanceToFinishWaypoint;
        return dist1 + dist2 + dist3;
    }

    public function drawLineToNextWaypoint(obj:ObjectBase, lineContainer:Sprite):void{
        var lastVisitedWpB:WaypointItemBehavior = _waypointSequence.getLastWaypointVisitedBy(obj);
        var nextWpBToVisit:WaypointItemBehavior = _waypointSequence.getNextWaypoint(lastVisitedWpB);

        var nextWpToVisitC:ControllerBase = Config.field.getControllerByBehavior(nextWpBToVisit);
        if(!nextWpToVisitC)
            return;

        var nextWpToVisit:ObjectBase = nextWpToVisitC.object;
        lineContainer.graphics.clear();
        lineContainer.graphics.lineStyle(1, 0xFF0000);
        lineContainer.graphics.moveTo(obj.position.x, obj.position.y + 50);
        lineContainer.graphics.lineTo(nextWpToVisit.position.x, nextWpToVisit.position.y + 50);
        lineContainer.graphics.endFill();
    }

    private function add(wp:ObjectBase, params:Object):void{
        var wpBehavior:WaypointItemBehavior = WaypointItemBehavior.create(params.inLine, params.outLine,
                new <Function>[null, null, onEndInteraction], params.isFinish);
        _waypointSequence.add(wpBehavior);

        var wpc:ControllerBase = ControllerBase.create(wp, new <BehaviorBase>[wpBehavior]);
        Config.field.add(wpc);
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
