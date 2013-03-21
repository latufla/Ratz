/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {
import controller.ControllerBase;

import flash.display.BitmapData;

import managers.WaypointManager;

import utils.Config;

public class RaceInfo {

    private var _id:uint;
    private var _name:String = "noName";

    private var _laps:uint = 2;

    private var _border:BitmapData;
    private var _waypoints:Vector.<Object>;

    private var _racers:Vector.<UserInfo>;

    public function RaceInfo(border:BitmapData, waypoints:Vector.<Object>, racers:Vector.<UserInfo>) {
        _border = border;
        _waypoints = waypoints;
        _racers = racers;
    }

    // TODO: deprecate racerInfo.distanceToFinish
    public function resolveRaceProgress():void{
        for each(var p:ControllerBase in Config.field.ratControllers) {
            var racerObj:ObjectBase = p.object;
            var racerInfo:UserInfo = getRacerByName(racerObj.name);
            racerInfo.distanceToFinish = WaypointManager.instance.getSmartDistanceToFinishLine(racerObj);
        }
        _racers.sort(sortOnDistanceToFinish);
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

    public function set racers(value:Vector.<UserInfo>):void {
        _racers = value;
    }

    public function getRacerPlace(r:UserInfo):int {
        return _racers.indexOf(r) + 1;
    }

    public function getRacerPoints(r:UserInfo):int {
        var place:int = _racers.indexOf(r);
        if(place == -1)
            return 0;

        return Config.pointsForPlacePlanet1[place];
    }

    public function get border():BitmapData {
        return _border;
    }

    public function set border(value:BitmapData):void {
        _border = value;
    }

    public function get waypoints():Vector.<Object> {
        return _waypoints;
    }

    public function set waypoints(value:Vector.<Object>):void {
        _waypoints = value;
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
}
}
