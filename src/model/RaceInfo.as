/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {
import utils.Config;

public class RaceInfo {

    private var _id:uint;
    private var _name:String = "noName";

    private var _racers:Vector.<UserInfo>;

    public function RaceInfo(racers:Vector.<UserInfo>) {
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

}
}
