/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 14:41
 * To change this template use File | Settings | File Templates.
 */
package event {
public class GameEvent extends CustomEvent{

    public static var NEED_MAIN_MENU:String = "needMainMenu";
    public static var NEED_LOBBY:String = "needLobby";
    public static var NEED_CONTROLS:String = "needControls";
    public static var NEED_RACE:String = "needRace";
    public static var NEED_RACE_RESULT:String = "needRaceResult";

    public function GameEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false){
        super(type, data, bubbles, cancelable);
    }
}
}
