/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {
import flash.display.BitmapData;

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
