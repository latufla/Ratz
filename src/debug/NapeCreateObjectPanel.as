/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 24.12.12
 * Time: 16:24
 * To change this template use File | Settings | File Templates.
 */
package debug {
import flash.events.MouseEvent;
import flash.text.TextField;

import utils.ObjectUtil;

public class NapeCreateObjectPanel extends DebugNapeCreateObjectPanelView{

    private var _textFields:Array;
    private var _createCb:Function;

    public function NapeCreateObjectPanel(createCb:Function) {
        _createCb = createCb;
        init();
    }

    private function init():void {
        _textFields = [mElasticityField, mDynamicFrictionField, mStaticFrictionField, mDensityField, mRollingFrictionField, fStepField, fMaxField, fGroupField];
        for each(var p:TextField in _textFields){
            p.restrict = "0-9.";
        }

        mElasticityField.text = "0.8";
        mDynamicFrictionField.text = "1";
        mStaticFrictionField.text = "1.4";
        mDensityField.text = "1.5";
        mRollingFrictionField.text = "0.01";

        createButton.addEventListener(MouseEvent.CLICK, onClickCreate);
    }

    private function onClickCreate(e:MouseEvent):void {
        if(_createCb != null)
            _createCb(params);
    }

    private function get params():Object{
        var res:Object = {};

        res["material"] = { elasticity: Number(mElasticityField.text),
            dynamicFriction: Number(mDynamicFrictionField.text),
            staticFriction: Number(mStaticFrictionField.text),
            density: Number(mDensityField.text),
            rollingFriction: Number(mRollingFrictionField.text)};

        res["force"] = { stepValue: Number(fStepField.text),
            maxValue: Number(fMaxField.text) };

        res["other"] = { group: Number(fGroupField.text)};

        trace("---")
        ObjectUtil.debugTrace(res["material"]);
        ObjectUtil.debugTrace(res["force"]);

        return res;
    }

}
}
