/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 21:21
 * To change this template use File | Settings | File Templates.
 */
package ratz.model.info {
public class UserInfo {
    public static const CHINA:uint = 0;
    public static const JAPAN:uint = 1;
    public static const RUSSIA:uint = 2;
    public static const USA:uint = 3;

    protected var _id:uint;
    protected var _name:String = "noName";

    protected var _country:uint = CHINA;

    protected var _points:uint = 0;
    protected var _races:uint = 0;

    protected var _currentLap:uint = 0;
    protected var _distanceToFinish:int = 0;

    public function UserInfo(id:uint, name:String) {
        _id = id;
        _name = name;
    }

    public static function create(id:uint, name:String, country:uint):UserInfo{
        var info:UserInfo = new UserInfo(id, name);
        info.country = country;
        return info;
    }

    public function refresh():void{
        _currentLap = 0;
        _distanceToFinish = 0;
    }

    public function get country():uint {
        return _country;
    }

    public function set country(value:uint):void {
        _country = value;
    }

    public function get name():String {
        return _name;
    }

    public function get id():uint {
        return _id;
    }

    public function get points():uint {
        return _points;
    }

    public function set points(value:uint):void {
        _points = value;
    }

    public function get races():uint {
        return _races;
    }

    public function set races(value:uint):void {
        _races = value;
    }

    public function toString():String{
        return "{ id: " + _id  +
                ", name: " + _name +
                ", country: " + _country +
                ", points: " + _points +
                ", races: " + _races + " }";
    }

    public function get currentLap():uint {
        return _currentLap;
    }

    public function set currentLap(value:uint):void {
        _currentLap = value;
    }

    public function get distanceToFinish():int {
        return _distanceToFinish;
    }

    public function set distanceToFinish(value:int):void {
        _distanceToFinish = value;
    }
}
}
