/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 20.03.13
 * Time: 19:31
 * To change this template use File | Settings | File Templates.
 */
package behaviors.core {
import behaviors.BehaviorBase;

import controller.ControllerBase;

import flash.display.Sprite;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import managers.WaypointManager;

import model.ObjectBase;
import model.RaceInfo;
import model.UserInfo;

import utils.DisplayObjectUtil;
import utils.geom.Line;

public class DebugStatDisplayBehavior extends BehaviorBase{

    private var _raceInfo:RaceInfo;
    private var _statField:TextField;
    private var _lineContainer:Sprite;

    public function DebugStatDisplayBehavior(raceInfo:RaceInfo) {
        super();
        _raceInfo = raceInfo;
    }

    override public function start(c:ControllerBase):void{
        super.start(c);

        _statField ||= new TextField();
        _statField.autoSize = TextFieldAutoSize.LEFT;
        _statField.textColor = 0xFF0000;
        _lineContainer ||= new Sprite();
    }

    override public function stop():void{
        super.stop();
//        DisplayObjectUtil.tryRemove(_statField);
        DisplayObjectUtil.tryRemove(_lineContainer);
    }

    override public function doStep():void {
        if(!_enabled)
            return;

        super.doStep();

        var obj:ObjectBase = _controller.object;
        _statField.x = obj.position.x;
        _statField.y = obj.position.y;

        var racerInfo:UserInfo = _raceInfo.getRacerByName(obj.name);
        if(racerInfo)
            _statField.text = _raceInfo.getRacerPlace(racerInfo) + " place " + String(racerInfo.distanceToFinish) + "m";

        var lineToNextWpCenter:Line = WaypointManager.instance.getLineToNextWaypoint(obj);
        var normalToNextWpInLine:Line = WaypointManager.instance.getNormalToNextWaypoint(obj);

        _lineContainer.graphics.clear();
        if(lineToNextWpCenter)
            DisplayObjectUtil.drawLine(_lineContainer.graphics, lineToNextWpCenter, 0xFF0000);

        if(normalToNextWpInLine)
            DisplayObjectUtil.drawLine(_lineContainer.graphics, normalToNextWpInLine, 0x0000FF);

        Ratz.STAGE.addChild(_lineContainer);
        Ratz.STAGE.addChild(_statField);
    }
}
}