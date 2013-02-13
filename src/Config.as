/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 30.12.12
 * Time: 20:12
 * To change this template use File | Settings | File Templates.
 */
package {
import debug.AmmunitionPanel;

import Field;

import nape.callbacks.CbType;
import nape.space.Space;

public class Config {

    public static const fps:uint = 60;
    public static const ammunitionPanel:AmmunitionPanel = new AmmunitionPanel();
    public static var space:Space;
    public static var field:Field;
}
}
