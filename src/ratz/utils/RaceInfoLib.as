/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 18.03.13
 * Time: 14:40
 * To change this template use File | Settings | File Templates.
 */
package ratz.utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import ratz.model.Field;
import ratz.model.info.UserInfo;

import core.utils.geom.Line;

public class RaceInfoLib {

    [Embed(source="../../../assets/lvl1.png")]
    private static var Race1BorderViewClass:Class;

    public function RaceInfoLib() {
        init();
    }

    private function init():void {

    }

    public static function getRaceInfoByLevel(l:uint = 1):Field{
        var border:BitmapData = Bitmap(new Race1BorderViewClass()).bitmapData;
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