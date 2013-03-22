/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {
import controller.ControllerBase;

import event.GameEvent;

import flash.display.BitmapData;

import managers.WaypointManager;

import utils.Config;
import utils.EventHeap;
import utils.VectorUtil;

public class RaceInfo {

    private var _id:uint;
    private var _name:String = "noName";

    private var _laps:uint = 1;

    private var _border:BitmapData;
    private var _waypoints:Vector.<Object>;

    private var _racers:Vector.<UserInfo>;

    private var _runners:Vector.<UserInfo>;
    private var _finishers:Vector.<UserInfo>;

    public function RaceInfo(border:BitmapData, waypoints:Vector.<Object>, racers:Vector.<UserInfo>) {
        _border = border;
        _waypoints = waypoints;
        _racers = racers;
        _runners = _racers.concat(); // only links
        _finishers = new Vector.<UserInfo>();
    }

    // TODO: deprecate racerInfo.distanceToFinish
    public function resolveRaceProgress():void{
        if(raceIsFinished)
            return;

        for each(var p:ControllerBase in Config.field.ratControllers) {
            var racerObj:ObjectBase = p.object;
            var racerInfo:UserInfo = getRacerByName(racerObj.name);

            if(_runners.indexOf(racerInfo) != -1 && racerInfo.currentLap >= _laps){
                VectorUtil.removeElement(_runners, racerInfo);
                _finishers.push(racerInfo);
            } else{
                racerInfo.distanceToFinish = WaypointManager.instance.getSmartDistanceToFinishLine(racerObj);
            }
        }
        _runners.sort(sortOnDistanceToFinish);

        if(raceIsFinished)
            EventHeap.instance.dispatch(new GameEvent(GameEvent.NEED_RACE_RESULT,{raceInfo:this}));
    }

    private function sortOnDistanceToFinish(a:UserInfo, b:UserInfo){
        var aDist:Number = a.distanceToFinish;
        var bDist:Number = b.distanceToFinish;
        if(a.currentLap > b.currentLap)
            return -1;

        if(aDist > bDist) {
            return 1;
        } else if(aDist < bDist) {
            return -1;
        } else  {
            return 0;
        }
    }

    public function get racers():Vector.<UserInfo> {
        return _racers;
    }

    public function getRacerPlace(r:UserInfo):int {
        var fId:int = _finishers.indexOf(r);
        if(fId != -1)
            return fId + 1;

        var fCount:uint = _finishers.length;
        return fCount + _runners.indexOf(r) + 1;
    }

    public function getRacerPoints(r:UserInfo):int {
        var place:int = _finishers.indexOf(r);
        if(place == -1)
            return 0;

        return Config.pointsForPlacePlanet1[place];
    }

    public function get border():BitmapData {
        return _border;
    }

    public function get waypoints():Vector.<Object> {
        return _waypoints;
    }

    public function get finishWaypointDesc():Object{
        var res:Vector.<Object> = _waypoints.filter(function (e:Object, i:int, v:Vector.<Object>):Boolean{
            return e.isFinish;
        });
        return res[0];
    }

    public function getRacerByName(name:String):UserInfo{
        var res:Vector.<UserInfo> = _racers.filter(function (e:UserInfo, i:int, v:Vector.<UserInfo>):Boolean{
            return e.name == name;
        });
        return res[0];
    }

    public function get laps():uint {
        return _laps;
    }

    public function get finishers():Vector.<UserInfo> {
        return _finishers;
    }


    public function get raceIsFinished():Boolean{
        return _runners.length == 0;
    }
}
}
