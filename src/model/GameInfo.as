/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package model {

import utils.Config;

public class GameInfo {

    private var _player:UserInfo;
    private var _opponents:Vector.<UserInfo>;

    public function GameInfo(player:UserInfo){
        _player = player;
        init();
    }

    private function init():void {
        _opponents = createOpponents(_player);
    }

    private function createOpponents(p:UserInfo):Vector.<UserInfo>{
        var countries:Array = [UserInfo.CHINA, UserInfo.JAPAN, UserInfo.RUSSIA, UserInfo.USA];
        var excessCountryId:int = countries.indexOf(_player.country);
        if(excessCountryId == -1)
            return null;

        countries.splice(excessCountryId, 1);

        var opps:Vector.<UserInfo> = new Vector.<UserInfo>();
        var bot:UserInfo;
        for (var i:uint = 0; i < Config.maxBotsCount && countries.length != 0; i++){
            bot = UserInfo.create(i + 1, "rat" + (i + 1), countries.shift(), UserInfo.SMART);
            opps.push(bot);
        }
        return opps;
    }

    public function toString():String{
        return "{ player: " + _player +  "\n opponents: " + _opponents + "}";
    }

    public function get player():UserInfo {
        return _player;
    }

    public function get opponents():Vector.<UserInfo> {
        return _opponents;
    }

    public function get allRacers():Vector.<UserInfo>{
        var ps:Vector.<UserInfo> = _opponents.concat();
        ps.unshift(_player);
        return ps;
    }
}
}
