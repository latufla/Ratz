/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 30.12.12
 * Time: 20:12
 * To change this template use File | Settings | File Templates.
 */
package utils {
import debug.AmmunitionPanel;

import nape.space.Space;

public class Config {

    public static const fps:uint = 60;
    public static const ammunitionPanel:AmmunitionPanel = new AmmunitionPanel();
    public static var space:Space;
    public static var field:Field;

    public static var soundEnabled:Boolean = true;

    // gameplay
    public static function get pointsForPlacePlanet1():Array{
        return [1000, 700, 400, 0];
    }

    public static function get racesCountPlanet1():uint{
        return 8;
    }

    public static function get maxPointsCountPlanet1():uint{
        return racesCountPlanet1 * 1000;
    }

    public static function get maxBotsCount():uint{
        return 3;
    }
}
}
