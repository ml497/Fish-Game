package fish;

class EnemyFish extends Fish {

	public function new(x:Int, y:Int, size:Float, velX:Float, velY:Float = 0){
		super(x, y, size);

		this.velX = velX;
		this.velY = velY;
	}

}