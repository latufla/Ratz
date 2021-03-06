/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:50
 * To change this template use File | Settings | File Templates.
 */
package ratz.model.info {
import ratz.model.*;
import ratz.utils.Config;

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

    public function refresh():void{
        for each(var p:UserInfo in _opponents){
            p.refresh();
        }

        if(_player)
            _player.refresh();
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

    public function applyRaceInfo(raceInfo:Field):void{
        _player.points += raceInfo.getRacerPoints(_player);
        _player.races++;
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
            bot = BotInfo.create(i + 1, "rat" + (i + 1), countries.shift(), BotInfo.SMART);
            opps.push(bot);
        }
        return opps;
    }
}
}
