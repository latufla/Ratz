/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 14.01.13
 * Time: 18:35
 * To change this template use File | Settings | File Templates.
 */
package debug {
import model.Ammunition;

public class AmmunitionPanel extends DebugAmmunitionPanelView{
    public function AmmunitionPanel() {
    }

    // TODO: remove this dirt
    public function set info(value:Ammunition):void{
        aShotsField.text = String(value.shots);
        aBoostField.text = String(value.boost);
        aTrapsField.text = String(value.traps);

        aHealthField.text = String(value.health);
    }
}
}
