/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 04.03.13
 * Time: 17:03
 * To change this template use File | Settings | File Templates.
 */
package core.utils {
import core.event.CustomEvent;

import flash.display.MovieClip;

public class EventHeap{

    private var _dispatcher:MovieClip; // onEF need
    private static var _instance:EventHeap;
    public function EventHeap() {
        init();
    }

    private function init():void {
        _dispatcher = new MovieClip();
    }

    public static function get instance():EventHeap {
        _instance ||= new EventHeap();
        return _instance;
    }

    public function dispatch(e:CustomEvent):void{
        _dispatcher.dispatchEvent(e);
    }

    public function register(eType:String, handler:Function):void{
        _dispatcher.addEventListener(eType, handler);
    }

    public function unregister(eType:String, handler:Function):void{
        _dispatcher.removeEventListener(eType, handler);
    }
}
}
