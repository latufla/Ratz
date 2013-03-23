/**
 * Created with IntelliJ IDEA.
 * User: Latufla
 * Date: 23.12.12
 * Time: 14:40
 * To change this template use File | Settings | File Templates.
 */
package core.utils.nape {
import core.utils.nape.NapeBitmapDataIso;

import ratz.utils.*;

import flash.display.BitmapData;
import flash.geom.Point;

import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;

import nape.geom.IsoFunction;

import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Polygon;

public class NapeUtil {
    public function NapeUtil() {
    }

    public static function bodyFromBitmapData(bd:BitmapData):Body{
        var bdIso:NapeBitmapDataIso = new NapeBitmapDataIso(bd, 0x80);
        return run(bdIso, bdIso.bounds);
    }

    private static function run(iso:IsoFunction, bounds:AABB, granularity:Vec2=null, quality:int=2, simplification:Number=1.5):Body {
        var body:Body = new Body();

        if (granularity==null) granularity = Vec2.weak(8, 8);
        var polys:GeomPolyList = MarchingSquares.run(iso, bounds, granularity, quality);
        for (var i:int = 0; i < polys.length; i++) {
            var p:GeomPoly = polys.at(i);

            var qolys:GeomPolyList = p.simplify(simplification).convexDecomposition(true);
            for (var j:int = 0; j < qolys.length; j++) {
                var q:GeomPoly = qolys.at(j);

                body.shapes.add(new Polygon(q));

                // Recycle GeomPoly and its vertices
                q.dispose();
            }
            // Recycle list nodes
            qolys.clear();

            // Recycle GeomPoly and its vertices
            p.dispose();
        }
        // Recycle list nodes
        polys.clear();

        // Align body with its centre of mass.
        // Keeping track of our required graphic offset.
        var pivot:Vec2 = body.localCOM.mul(-1);
        body.translateShapes(pivot);

        body.userData.graphicOffset = pivot;
        return body;
    }
}
}
