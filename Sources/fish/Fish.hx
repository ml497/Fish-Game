package fish;

import kha.graphics2.Graphics;
import kha.Color;

class Fish{

	public var x:Float;
	public var y:Float;
	var facing:Direction;
	public var height:Float;
	public var velX:Float;
	public var velY:Float;

	public function new(x:Int, y:Int, height:Float) {
		facing = Direction.LEFT;
		this.x = x;
		this.y = y;
		this.velX = 0;
		this.velY = 0;

		this.height = height;
	}

	public function updateMe() {
		x += velX;
		y += velY;
		if(velX > 0){
			facing = Direction.RIGHT;
		} else {
			facing = Direction.LEFT;
		}
	}

	public function collidesWith(other:Fish):Bool {
		var xDist = Math.abs(this.x - other.x);
		var yDist = Math.abs(this.y - other.y);
		var distance:Float = Math.sqrt(Math.pow( xDist, 2 ) + Math.pow( yDist, 2) );

		var xyRatio = xDist / (xDist + yDist);

		return distance < ( (1+xyRatio) * (this.height + other.height) );
	}

	public function drawMe(graphics:Graphics, color:Color) {
		graphics.color = color;
		fillOval(graphics, x, y, height, 2);

		if( facing == Direction.LEFT ){
			graphics.fillTriangle(x+height, y, x+height*2.8, y+height*1.2, x+height*2.8, y-height*1.2);
		} else {
			graphics.fillTriangle(x-height, y, x-height*2.8, y+height*1.2, x-height*2.8, y-height*1.2);
		}
	}

	static function fillOval(g2: Graphics, cx: Float, cy: Float, radius: Float, xRatio:Float = 1, segments: Int = 0): Void {
		#if sys_html5
			if (kha.SystemImpl.gl == null) {
				var g: kha.js.CanvasGraphics = cast g2;
				g.fillCircle(cx, cy, radius);
				return;
			}
		#end

		if (segments <= 0) {
			segments = Math.floor(10 * Math.sqrt(radius));
		}
			
		var theta = 2 * Math.PI / segments;
		var c = Math.cos(theta);
		var s = Math.sin(theta);
		
		var x = radius;
		var y = 0.0;
		
		for (n in 0...segments) {
			var px = x*xRatio + cx;
			var py = y + cy;
			
			var t = x;
			x = c * x - s * y;
			y = c * y + s * t;
			
			g2.fillTriangle(px, py, x*xRatio + cx, y + cy, cx, cy);
		}
	}

}