/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 18.03.13
 * Time: 14:40
 * To change this template use File | Settings | File Templates.
 */
package ratz.utils {
import core.utils.geom.Line;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import ratz.model.Field;

public class RaceInfoLib {

    [Embed(source="../../../assets/lvl1.png")]
    private static var DemoRace1BorderViewClass:Class;

    [Embed(source="../../../assets/levels/1/level_1_borders.png")]
    private static var Race1BorderViewClass:Class;

    public function RaceInfoLib() {
        init();
    }

    private function init():void {

    }

    public static function getRaceInfoByLevel(l:uint = 1):Field{
//        return getDemoRaceInfoByLevel();


        var border:BitmapData = Bitmap(new Race1BorderViewClass()).bitmapData;
        var wps:Vector.<Object> = new Vector.<Object>();
        wps.push({isFinish: true, rect: new Rectangle(1490, 910, 170, 2), inLine: new Line(new Point(1490, 912), new Point(1660, 912)), outLine:new Line(new Point(1490, 910), new Point(1660, 910))});
        wps.push({rect: new Rectangle(1458, 177, 206, 206), inLine: new Line(new Point(1458, 383), new Point(1664, 383)), outLine:new Line(new Point(1458, 177), new Point(1458, 383))});
        wps.push({rect: new Rectangle(170, 177, 206, 206), inLine: new Line(new Point(376, 177), new Point(376, 383)), outLine:new Line(new Point(170, 383), new Point(376, 383))});
        wps.push({rect: new Rectangle(170, 1465, 206, 206), inLine: new Line(new Point(170, 1465), new Point(376, 1465)), outLine:new Line(new Point(376, 1465), new Point(376, 1671))});
        wps.push({rect: new Rectangle(1458, 1465, 206, 206), inLine: new Line(new Point(1458, 1465), new Point(1458, 1671)), outLine:new Line(new Point(1458, 1465), new Point(1664, 1465))});

        var f:Field = new Field(border, wps, Config.gameInfo.allRacers);
        f.libDesc = StarlingAssetsLib.LEVEL_1;
        return f;
    }

    public static function getDemoRaceInfoByLevel():Field{
        var border:BitmapData = Bitmap(new DemoRace1BorderViewClass()).bitmapData;
        var wps:Vector.<Object> = new Vector.<Object>();
        wps.push({isFinish: true, rect: new Rectangle(604, 380, 170, 2), inLine: new Line(new Point(604, 382), new Point(774, 382)), outLine:new Line(new Point(604, 380), new Point(774, 380))});
        wps.push({rect: new Rectangle(604, 30, 170, 170), inLine: new Line(new Point(604, 200), new Point(774, 200)), outLine:new Line(new Point(604, 30), new Point(604, 200))});
        wps.push({rect: new Rectangle(35, 30, 170, 170), inLine: new Line(new Point(205, 30), new Point(205, 200)), outLine:new Line(new Point(35, 200), new Point(205, 200))});
        wps.push({rect: new Rectangle(35, 590, 170, 170), inLine: new Line(new Point(35, 590), new Point(205, 590)), outLine:new Line(new Point(205, 590), new Point(205, 760))});
        wps.push({rect: new Rectangle(604, 590, 170, 170), inLine: new Line(new Point(604, 590), new Point(604, 760)), outLine:new Line(new Point(604, 590), new Point(774, 590))});

//        return new RaceInfo(border, wps, new <UserInfo>[Config.gameInfo.allRacers[0]]/*Config.gameInfo.allRacers*/);
        return new Field(border, wps, Config.gameInfo.allRacers);
    }

}
}
