/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {
public class RaceInfo {

    private var _id:uint;
    private var _name:String = "noName";

    private var _racers:Vector.<UserInfo>;

    public function RaceInfo(participants:Vector.<UserInfo>) {
        _racers = participants;
    }

    public function get racers():Vector.<UserInfo> {
        return _racers;
    }

    public function set racers(value:Vector.<UserInfo>):void {
        _racers = value;
    }

}
}
