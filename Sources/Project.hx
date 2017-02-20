package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.graphics2.Graphics;
import kha.Color;
import kha.input.Keyboard;
import kha.Key;
import fish.*;

class Project {

	public var playerFish:Fish;
	public var enemyFish:Array<EnemyFish>;

	var down:Bool;
	var left:Bool;
	var up:Bool;
	var right:Bool;

	var tick:Int;
	static inline var PLAYER_FISH_START_HEIGHT:Int = 10;

	public function new() {
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		Keyboard.get().notify(onKeyDown, onKeyUp);

		init();
	}

	public function init() {
		tick = 0;
		playerFish = new Fish(400, 400, PLAYER_FISH_START_HEIGHT);
		enemyFish = new Array<EnemyFish>();
	}

	function update(): Void {
		this.updatePlayerFishVel();
		this.collisionUpdate();

		tick++;

		if( tick % 15 == 0 ){
			generateFish();
		}

		for( fish in enemyFish ){
			fish.updateMe();
		}

		playerFish.updateMe();
	}

	function collisionUpdate() {
		var newFishArray = new Array<EnemyFish>();
		for (fish in enemyFish){
			if( !playerFish.collidesWith(fish) ){	
				newFishArray.push(fish);
			} else {
				if(playerFish.height < fish.height){
					trace("Game over.  Score: " + Std.int(playerFish.height));
					playerFish.height = PLAYER_FISH_START_HEIGHT;
					playerFish.x = 400;
					playerFish.y = 400;

					enemyFish = new Array<EnemyFish>();
					return;
				} else {
					playerFish.height += fish.height/10;
				}
			}
		}
		enemyFish = newFishArray;
	}

	function updatePlayerFishVel() {
		if(down && playerFish.velY < 20){
			playerFish.velY += 1;
		}
		if(left && playerFish.velX > -20){
			playerFish.velX -= 1;
		}
		if(up && playerFish.velY > -20){
			playerFish.velY -= 1;
		}
		if(right && playerFish.velX < 20){
			playerFish.velX += 1;
		}

		if(!down && !up){
			playerFish.velY *= 0.95;
		}
		if(!left && !right){
			playerFish.velX *= 0.95;
		}
	}

	public function render(framebuffer: Framebuffer): Void {	
		var graphics = framebuffer.g2;
		graphics.begin();
		graphics.color = Color.fromValue(0xff7df9ff);
		graphics.fillRect(0, 0, System.windowWidth(), System.windowHeight());
		playerFish.drawMe(graphics, Color.Orange);
		for(fish in enemyFish){
			var enemyColor:Color = (fish.height <= playerFish.height) ? Color.Yellow : Color.Red;
			fish.drawMe(graphics, enemyColor);
		}
		graphics.end();
	}

	function generateFish():Void {
		var goingRight = Std.random(2) == 1;
		var speed = 1 + Std.random(5);
		enemyFish.push(new EnemyFish(goingRight ? Std.int(0-System.windowWidth()/5) : Std.int(System.windowWidth()+System.windowWidth()/5), Std.random(System.windowHeight()), Std.random(Std.int(playerFish.height*2)), goingRight ? speed : -speed, 0));
	}

	public function onKeyDown(key:Key, value:String):Void {
		switch (key){
			case LEFT: left = true;
			case RIGHT: right = true;
			case UP: up = true;
			case DOWN: down = true;
			
			default: return;
		}
	}

	public function onKeyUp(key:Key, value:String):Void {
		switch (key){
			case LEFT: left = false;
			case RIGHT: right = false;
			case UP: up = false;
			case DOWN: down = false;
			
			default: return;
		}
	}

}
