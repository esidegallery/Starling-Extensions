package starling.extensions
{
    import flash.geom.Point;

    import starling.display.Mesh;
    import starling.rendering.IndexData;
    import starling.rendering.VertexData;
    import starling.textures.Texture;

    public class QuadSection extends Mesh
    {
        private var _width:Number;
        private var _height:Number;
        private var _color:uint;
        private var _slices:Array;
        private var _ratio:Number;
        private var _clockwise:Boolean;

        private static var sPoint:Point = new Point();

        public function QuadSection(width:Number, height:Number, color:uint=0xffffff)
        {
            _color = color;
            _width = width;
            _height = height;
            _ratio = 1.0;
            _clockwise = true;
            _slices = [
                { ratio: 0.0,   x: _width / 2, y: 0       },
                { ratio: 0.125, x: _width,     y: 0       },
                { ratio: 0.375, x: _width,     y: _height },
                { ratio: 0.625, x: 0,          y: _height },
                { ratio: 0.875, x: 0,          y: 0       },
                { ratio: 1.0,   x: _width / 2, y: 0       }
            ];

            var vertexData:VertexData = new VertexData(null, 6);
            var indexData:IndexData = new IndexData(15);

            super(vertexData, indexData);

            this.updateVertices();
        }

        private function updateVertices():void
        {
            vertexData.numVertices = 0;
            indexData.numIndices = 0;

            if (_ratio > 0)
            {
                var angle:Number = _ratio * Math.PI * 2.0 - Math.PI / 2.0;
                var numSlices:int = _slices.length;
                updateVertex(0, _width / 2, _height / 2); // center point

                for (var i:int=1; i<numSlices; ++i)
                {
                    var currSlice:Object = _slices[i];
                    var prevSlice:Object = _slices[i - 1];
                    var nextVertexID:int = i < 6 ? i + 1 : 1;

                    indexData.addTriangle(0, i, nextVertexID);
                    updateVertex(i, prevSlice.x, prevSlice.y);

                    if (_ratio > currSlice.ratio)
                        updateVertex(nextVertexID, currSlice.x, currSlice.y);
                    else
                    {
                        intersectLineWithSlice(
                            prevSlice.x, prevSlice.y, currSlice.x, currSlice.y, angle, sPoint);
                        updateVertex(nextVertexID, sPoint.x, sPoint.y);
                        break;
                    }
                }
            }

            setVertexDataChanged();
        }

        private function updateVertex(vertexID:int, x:Number, y:Number):void
        {
            if (!_clockwise)
                x = _width - x;

            if (texture)
                texture.setTexCoords(vertexData, vertexID, "texCoords", x / _width, y / _height);

            vertexData.setPoint(vertexID, "position", x, y);
            vertexData.setColor(vertexID, "color", _color);
        }

        private function intersectLineWithSlice(ax:Number, ay:Number, bx:Number, by:Number,
                                                angle:Number, out:Point=null):Point
        {
            out ||= new Point();

            if (ax == bx && ay == by) return null; // length = 0

            var abx:Number = bx - ax;
            var aby:Number = by - ay;
            var cdx:Number = Math.cos(angle);
            var cdy:Number = Math.sin(angle);
            var tDen:Number = cdy * abx - cdx * aby;

            if (tDen == 0.0) return null; // parallel or identical

            var cx:Number = _width  / 2.0;
            var cy:Number = _height / 2.0;
            var t:Number = (aby * (cx - ax) - abx * (cy - ay)) / tDen;

            out.x = cx + t * cdx;
            out.y = cy + t * cdy;

            return out;
        }

        override public function get color():uint { return _color; }
        override public function set color(value:uint):void { super.color = _color = value; }

        override public function set texture(value:Texture):void
        {
            super.texture = value;
            if (value.frame) trace("Warning: 'QuadSection' will ignore any texture frames.");
            updateVertices();
        }

        public function get ratio():Number { return _ratio; }
        public function set ratio(value:Number):void
        {
            if (_ratio != value)
            {
                _ratio = value;
                updateVertices();
            }
        }

        public function get clockwise():Boolean { return _clockwise; }
        public function set clockwise(value:Boolean):void
        {
            if (_clockwise != value)
            {
                _clockwise = value;
                updateVertices();
            }
        }

        public static function fromTexture(texture:Texture):QuadSection
        {
            var quadPie:QuadSection = new QuadSection(texture.width, texture.height);
            quadPie.texture = texture;
            return quadPie;
        }
    }
}
