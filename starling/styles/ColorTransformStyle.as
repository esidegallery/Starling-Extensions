package starling.styles
{
    import starling.display.Mesh;
    import starling.rendering.MeshEffect;
    import starling.rendering.VertexDataFormat;
    import starling.styles.MeshStyle;
    import starling.utils.Color;
    import starling.utils.StringUtil;

    public class ColorTransformStyle extends MeshStyle
    {
        public static const VERTEX_FORMAT:VertexDataFormat = MeshStyle.VERTEX_FORMAT.extend("multipliers:float4,offsets:float4");

        private var _matrix:Vector.<Number>;

        public function ColorTransformStyle(redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0, 
                                            redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void 
        {
            _matrix = new Vector.<Number>(8, true);
            setTo(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
        }

        public function setTo(redMultiplier:Number = 1.0, greenMultiplier:Number = 1.0, blueMultiplier:Number = 1.0, alphaMultiplier:Number = 1.0, 
                              redOffset:Number = 0, greenOffset:Number = 0, blueOffset:Number = 0, alphaOffset:Number = 0):void 
        {
            _matrix[0] = redMultiplier;
            _matrix[1] = greenMultiplier;
            _matrix[2] = blueMultiplier;
            _matrix[3] = alphaMultiplier;
            _matrix[4] = redOffset;
            _matrix[5] = greenOffset;
            _matrix[6] = blueOffset;
            _matrix[7] = alphaOffset;

            updateVertices();
        }

        override public function copyFrom(meshStyle:MeshStyle):void 
        {
            var colorTransformStyle:ColorTransformStyle = meshStyle as ColorTransformStyle;
            if (colorTransformStyle) 
            {
                var l:int = _matrix.length;
                for (var i:int = 0; i < l; ++i) 
                {
                    _matrix[i] = colorTransformStyle._matrix[i];
                }
            }

            super.copyFrom(meshStyle);
        }

        override public function createEffect():MeshEffect 
        {
            return new ColorTransformEffect();
        }

        override protected function onTargetAssigned(target:Mesh):void 
        {
            updateVertices();
        }

        override public function get vertexFormat():VertexDataFormat
        {
            return VERTEX_FORMAT;
        }

        private function updateVertices():void 
        {
            if (target) 
            {
                var numVertices:int = vertexData.numVertices;
                var redOffset:Number = _matrix[4] / 255;
                var greenOffset:Number = _matrix[5] / 255;
                var blueOffset:Number = _matrix[6] / 255;
                var alphaOffset:Number = _matrix[7] / 255;

                // Setting color multipliers and offsets
                for (var i:int = 0; i < numVertices; ++i) 
                {
                    vertexData.setPoint4D(i, "multipliers", _matrix[0], _matrix[1], _matrix[2], _matrix[3]);
                    vertexData.setPoint4D(i, "offsets", redOffset, greenOffset, blueOffset, alphaOffset);
                }

                setRequiresRedraw();
            }
        }

        public function concat(second:ColorTransformStyle):void 
        {
            _matrix[0] *= second.redMultiplier;
            _matrix[1] *= second.greenMultiplier;
            _matrix[2] *= second.blueMultiplier;
            _matrix[3] *= second.alphaMultiplier;
            _matrix[4] += second.redOffset;
            _matrix[5] += second.greenOffset;
            _matrix[6] += second.blueOffset;
            _matrix[7] += second.alphaOffset;
            updateVertices();
        }

        public function toString():String
        {
            return StringUtil.format("(redMultiplier={0}, greenMultiplier={1}, blueMultiplier={2}, alphaMultiplier={3}, " + "redOffset={4}, greenOffset={5}, blueOffset={6}, alphaOffset={7})", _matrix[0], _matrix[1], _matrix[2], _matrix[3], _matrix[4], _matrix[5], _matrix[6], _matrix[7]);
        }

        override public function get color():uint 
        {
            return Color.rgb(_matrix[4], _matrix[5], _matrix[6]);
        }

        override public function set color(value:uint):void 
        {
            _matrix[0] = 0;
            _matrix[1] = 0;
            _matrix[2] = 0;
            _matrix[4] = Color.getRed(value);
            _matrix[5] = Color.getGreen(value);
            _matrix[6] = Color.getBlue(value);
            updateVertices();
        }

        public function get redMultiplier():Number 
        {
            return _matrix[0];
        }
        public function set redMultiplier(value:Number):void 
        {
            _matrix[0] = value;
            updateVertices();
        }

        public function get greenMultiplier():Number 
        {
            return _matrix[1];
        }
        public function set greenMultiplier(value:Number):void 
        {
            _matrix[1] = value;
            updateVertices();
        }

        public function get blueMultiplier():Number 
        {
            return _matrix[2];
        }
        public function set blueMultiplier(value:Number):void 
        {
            _matrix[2] = value;
            updateVertices();
        }

        public function get alphaMultiplier():Number 
        {
            return _matrix[3];
        }
        public function set alphaMultiplier(value:Number):void 
        {
            _matrix[3] = value;
            updateVertices();
        }

        public function get redOffset():Number 
        {
            return _matrix[4];
        }
        public function set redOffset(value:Number):void 
        {
            _matrix[4] = value;
            updateVertices();
        }

        public function get greenOffset():Number 
        {
            return _matrix[5];
        }
        public function set greenOffset(value:Number):void 
        {
            _matrix[5] = value;
            updateVertices();
        }

        public function get blueOffset():Number 
        {
            return _matrix[6];
        }
        public function set blueOffset(value:Number):void 
        {
            _matrix[6] = value;
            updateVertices();
        }

        public function get alphaOffset():Number 
        {
            return _matrix[7];
        }
        public function set alphaOffset(value:Number):void 
        {
            _matrix[7] = value;
            updateVertices();
        }
    }
}

import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;

import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.styles.ColorTransformStyle;

class ColorTransformEffect extends MeshEffect 
{
    public static const VERTEX_FORMAT:VertexDataFormat = ColorTransformStyle.VERTEX_FORMAT;

    private static const COLOR_CONSTANTS:Vector.<Number> = new <Number>[0, 0.01, 0.0001, 1];

    override protected function createProgram():Program 
    {
        var vertexShader:String, fragmentShader:String;
        var multipliersAndOffsets:String = [
            "max ft0.xyzw, ft0.xyzw, fc0.xxxz", // avoid division through zero in next step // Disable because of alpha artifact with offset
            "div ft0.xyz, ft0.xyz, ft0.www", // restore original (non-PMA) RGB values

            "mul ft0, ft0, v2", // apply color multipliers to texel color

            "add ft0.xyz, ft0.xyz, v3.xyz", // apply rgb offsets to texel rgb
            "mov ft4.w, fc0.z", // prepare ft4 to store our alpha offset during operations
            "sge ft4.w, ft0.w, fc0.y", // If ft2.w > 0, then we'll add the alpha offset
            "mul ft4.w, ft4.w, v3.w", // We multiply our alpha offset to the result of the previous check
            "add ft0.w, ft0.w, ft4.w", // apply alpha offset to texel alpha

            "min ft0.xyzw, ft0.xyzw, fc0.wwww", // colorTransform channel values can't go above 1
            "max ft0.xyzw, ft0.xyzw, fc0.xxxx", // colorTransform channel values can't go under 0

            "mul ft0.xyz, ft0.xyz, ft0.www", // multiply with alpha again (PMA)
            "mov oc, ft0" // copy to output
        ].join("\n");

        if (texture) 
        {
            vertexShader = [
                "m44 op, va0, vc0", // 4x4 matrix transform to output clip-space
                "mov v0, va1", // pass texture coordinates to fragment shader
                "mul v1, va2, vc4", // multiply alpha (vc4) with color (va2), unused with texture
                "mov v2, va3", // pass multipliers to fragment shader
                "mov v3, va4" // pass offsets to fragment shader
            ].join("\n");

            fragmentShader = [
                tex("ft0", "v0", 0, texture) +
                multipliersAndOffsets
            ].join("\n");
        } 
        else 
        {
            vertexShader = [
                "m44 op, va0, vc0", // 4x4 matrix transform to output clipspace
                "mul v0, va2, vc4", // multiply alpha (vc4) with color (va2)
                "mov v2, va3", // pass multipliers to fragment shader
                "mov v3, va4" // pass offsets to fragment shader
            ].join("\n");

            fragmentShader = [
                "mov ft0, v0",
                multipliersAndOffsets
            ].join("\n");
        }

        return Program.fromSource(vertexShader, fragmentShader);
    }

    override public function get vertexFormat():VertexDataFormat 
    {
        return VERTEX_FORMAT;
    }

    override protected function beforeDraw(context:Context3D):void 
    {
        super.beforeDraw(context);

        vertexFormat.setVertexBufferAt(3, vertexBuffer, "multipliers");
        vertexFormat.setVertexBufferAt(4, vertexBuffer, "offsets");

        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, COLOR_CONSTANTS, 1);
    }

    override protected function afterDraw(context:Context3D):void 
    {
        context.setVertexBufferAt(3, null);
        context.setVertexBufferAt(4, null);

        super.afterDraw(context);
    }
}