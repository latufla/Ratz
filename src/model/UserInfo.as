/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 21:21
 * To change this template use File | Settings | File Templates.
 */
package model {
public class UserInfo {
    public static const CHINA:uint = 0;
    public static const JAPAN:uint = 1;
    public static const RUSSIA:uint = 2;
    public static const USA:uint = 3;

    public static const RETARDED:uint = 0;
    public static const DUMB:uint = 1;
    public static const ORDINARY:uint = 2;
    public static const SMART:uint = 3;

    private var _id:uint;
    private var _name:String = "noName";

    private var _country:uint = CHINA;

    private var _points:uint = 1500;
    private var _races:uint = 3;

    // bot
    private var _intelligence:uint = SMART;

    public function UserInfo(id:uint, name:String) {
        _id = id;
        _name = name;
    }

    public static function create(id:uint, name:String, country:uint, intelligence:uint = SMART):UserInfo{
        var info:UserInfo = new UserInfo(id, name);
        info.country = country;
        info.intelligence = intelligence;
        return info;
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

    public function get intelligence():uint {
        return _intelligence;
    }

    public function set intelligence(value:uint):void {
        _intelligence = value;
    }

    public function toString():String{
        return "{ id: " + _id  +
                ", name: " + _name +
                ", country: " + _country +
                ", points: " + _points +
                ", races: " + _races +
                ", intelligence: " + _intelligence + " }";
    }
}
}
