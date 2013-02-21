/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 21.02.13
 * Time: 13:15
 * To change this template use File | Settings | File Templates.
 */
package event {
import flash.events.Event;

public class CustomEvent extends Event{
    private var _data:Object;
    public static const WAYPOINT_VISIT:String = "waypointVisit";

    public function CustomEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false){
        super(type, bubbles, cancelable);
        this._data = data;
        return;
    }

    public function get data():Object {
        return _data;
    }
}
}
