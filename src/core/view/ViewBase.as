/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 12.01.13
 * Time: 17:32
 * To change this template use File | Settings | File Templates.
 */
package core.view {
import starling.display.Sprite;

public class ViewBase extends Sprite{

    private var _content:*;
    public function ViewBase() {
        super();
    }

    public function get content():* {
        return _content;
    }

    public function set content(value:*):void {
        _content = value;

        if(_content)
            addChild(_content);
    }
}
}
