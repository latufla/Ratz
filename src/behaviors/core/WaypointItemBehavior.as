/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 17.02.13
 * Time: 18:19
 * To change this template use File | Settings | File Templates.
 */
package behaviors.core {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import controller.ControllerBase;

import flash.geom.Point;

import model.ObjectBase;

import utils.Config;
import utils.GuiUtil;
import utils.PhysEngineConnector;
import utils.VectorUtil;

public class WaypointItemBehavior extends BehaviorBase {

    private var _interactionCb:Function;
    private var _registeredList:Vector.<String>;

    public function WaypointItemBehavior(interactionCb:Function) {
        super();

        _interactionCb = interactionCb;
        init();
    }

    private function init():void {
        _registeredList = new Vector.<String>();
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        var obj:ObjectBase = _controller.object;
        obj.isPseudo = true;
        obj.visible = false;
        PhysEngineConnector.instance.addInteractionListener(_controller.object, onInteraction);
    }

    override public function stop():void{
        var obj:ObjectBase = _controller.object;
        obj.isPseudo = false;
        obj.visible = true;
        PhysEngineConnector.instance.removeInteractionListener(_controller.object, onInteraction);

        super.stop();
    }

    public function register(obj:ObjectBase):void{
        _registeredList.push(obj.name);

        GuiUtil.showPopupText(Ratz.STAGE, new Point(300, 350), name, 30, 0x0000FF);
//        trace(name, obj.name);
    }

    public function unregister(obj:ObjectBase):void{
        VectorUtil.removeElement(_registeredList, obj.name);
    }

    public function unregisterAll():void{
        _registeredList = new Vector.<String>();
    }

    public function isRegistered(obj:ObjectBase):Boolean{
        return _registeredList.indexOf(obj.name) != -1;
    }

    private function onInteraction(waypoint:ObjectBase, target:ObjectBase):void{
        if(_interactionCb)
            _interactionCb(waypoint, target);
    }
}
}
