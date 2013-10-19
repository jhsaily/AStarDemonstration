package
{	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Entity
	{
		[Embed(source = '/assets/player.png')] private const PLAYER_GRAPHIC:Class;
		public var image:Spritemap = new Spritemap(PLAYER_GRAPHIC,16,20);
		public var WALKSPEED:int = 80;
		public var DIRECTION:String = "Down";
		public var drag:Boolean = false;
		public var pathFinder:AStarPathfinder;
		public var timeMod:uint = 5;
		public var text:LevelText;
		private var time:uint = 0;
		private var prevX:int = 0;
		private var prevY:int = 0;
		private var path:Node;
		private var justSpawned:Boolean = true;
		private var textType:int = 0;
		public function Player()
		{
			text = new LevelText();
			MainWorld.world.add(text);
			this.type = "player";
			Input.define("One", Key.DIGIT_1);
			Input.define("Two", Key.DIGIT_2);
			Input.define("Three", Key.DIGIT_3);
			Input.define("Four", Key.DIGIT_4);
			Input.define("Five", Key.DIGIT_5);
			Input.define("Up", Key.UP, Key.W);
			Input.define("Down", Key.DOWN, Key.S);
			Input.define("Left", Key.LEFT, Key.A);
			Input.define("Right", Key.RIGHT, Key.D);
			Input.define("ModUp", Key.E);
			Input.define("ModDown", Key.Q);
			Input.define("fCost", Key.F);
			Input.define("gCost", Key.G);
			Input.define("fCost", Key.F);
			Input.define("hCost", Key.H);
			Input.define("noCost", Key.N);
			image.add("StandRight",[9],0,false);
			image.add("StandDown",[0],0,false);
			image.add("StandLeft",[3],0,false);
			image.add("StandUp",[6],0,false);
			image.add("WalkUp",[7,6,8,6],10,true);
			image.add("WalkDown",[1,0,2,0],10,true);
			image.add("WalkLeft",[4,3,5,3],10,true);
			image.add("WalkRight",[10,9,11,9],10,true);
			graphic = image;
			this.setHitbox(16,16,x,y-4);
			x = 16;
			y = 12;
		}
		
		override public function update():void
		{
			if (justSpawned){
				FP.log("A* Manhattan Distance Selected");
				justSpawned = false;
			}
			if (Input.mousePressed && FP.world.mouseX >= this.x && FP.world.mouseX <= this.x + 16 && FP.world.mouseY >= this.y && FP.world.mouseY <= this.y + 20) {
				drag = !drag;
				MainWorld.path.clearLevel();
			} else if (Input.mousePressed && MainWorld.mLevel._tiles.getTile((FP.world.mouseX - FP.world.mouseX%16)/16, (FP.world.mouseY - FP.world.mouseY%16)/16) != 0) {
				MainWorld.mLevel.addTile((FP.world.mouseX - FP.world.mouseX%16),(FP.world.mouseY - FP.world.mouseY%16),3, false);
				if (MainWorld.mLevel.goalX != -1 && MainWorld.mLevel.goalY != -1) {
					MainWorld.mLevel.addTile((MainWorld.mLevel.goalX),(MainWorld.mLevel.goalY),1, false);
				}
				MainWorld.mLevel.goalX = (FP.world.mouseX - FP.world.mouseX%16);
				MainWorld.mLevel.goalY = (FP.world.mouseY - FP.world.mouseY%16);
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (!drag && (Math.floor(prevX/16) != Math.floor(this.x/16) || Math.floor(prevY/16) != Math.floor(this.y/16))) {
				MainWorld.path.clearLevel();
				prevX = this.x;
				prevY = this.y;
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (this.x >= 0 && this.y > 0 && MainWorld.mLevel.goalX != -1 && time%timeMod == 0) {
				MainWorld.world.remove(text);
				text = null;
				text = new LevelText();
				MainWorld.path.clearLevel();
				if (pathFinder == null) {
					pathFinder = new AStarPathfinder();
				}
				path = pathFinder.findPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				if (path != null && path.x == MainWorld.mLevel.goalX && path.y == MainWorld.mLevel.goalY) {
					path = path.parent;
				}
				if (AStarPathfinder.openList != null) {
					for(var i:int = 0; i < AStarPathfinder.openList.length; i++) {
						if (AStarPathfinder.openList[i].x == MainWorld.mLevel.goalX && AStarPathfinder.openList[i].y == MainWorld.mLevel.goalY){
						} else {
							MainWorld.path.addTile(AStarPathfinder.openList[i].x,AStarPathfinder.openList[i].y,4,false);
						}
						if (textType == 1) {
							text.addText(""+Math.floor(AStarPathfinder.openList[i].fCost/16),AStarPathfinder.openList[i].x,AStarPathfinder.openList[i].y);
						} else if (textType == 2) {
							text.addText(""+Math.floor(AStarPathfinder.openList[i].gCost/16),AStarPathfinder.openList[i].x,AStarPathfinder.openList[i].y);
						} else if (textType == 3) {
							text.addText(""+Math.floor(AStarPathfinder.openList[i].dist/16),AStarPathfinder.openList[i].x,AStarPathfinder.openList[i].y);
						} else {
							//Do Nothing
						}
					}
				}
				if (AStarPathfinder.closedList != null) {
					for(var j:int = 0; j < AStarPathfinder.closedList.length; j++) {
						MainWorld.path.addTile(AStarPathfinder.closedList[j].x,AStarPathfinder.closedList[j].y,5,false);
						if (textType == 1) {
							text.addText(""+Math.floor(AStarPathfinder.closedList[j].fCost/16),AStarPathfinder.closedList[j].x,AStarPathfinder.closedList[j].y);
						} else if (textType == 2) {
							text.addText(""+Math.floor(AStarPathfinder.closedList[j].gCost/16),AStarPathfinder.closedList[j].x,AStarPathfinder.closedList[j].y);
						} else if (textType == 3) {
							text.addText(""+Math.floor(AStarPathfinder.closedList[j].dist/16),AStarPathfinder.closedList[j].x,AStarPathfinder.closedList[j].y);
						} else {
							//Do Nothing
						}
					}
				}
				while(path != null && path.parent != null) {
					MainWorld.path.addTile(path.x,path.y,2,false);
					path = path.parent;
				}
			}
			time++;
			updateMovement();
			if (this.x + 16 > FP.camera.x + FP.screen.width - 16) {
				FP.camera.x++;
			} else if (this.x - 16< FP.camera.x) {
				FP.camera.x--;
			}
			if (this.y + 16 > FP.camera.y + FP.screen.height - 20) {
				FP.camera.y++;
			} else if (this.y - 12 < FP.camera.y) {
				FP.camera.y--;
			}
			updateCollision();
			super.update();
			MainWorld.world.add(text);
		}
		
		public function updateMovement():void
		{
			if (drag) {
				this.x = (FP.world.mouseX) - (FP.world.mouseX)%16;
				this.y = (FP.world.mouseY -4) - (FP.world.mouseY)%16;
			}
			if (Input.pressed("fCost")) {
				textType = 1;
				FP.log("Displaying F Cost");
			}
			if (Input.pressed("gCost")) {
				textType = 2;
				FP.log("Displaying G Cost");
			}
			if (Input.pressed("hCost")) {
				textType = 3;
				FP.log("Displaying H Cost");
			}
			if (Input.pressed("noCost")) {
				textType = 0;
				FP.log("Displaying No Cost");
			}
			if (Input.pressed("One")) {
				MainWorld.pathType = 1;
				FP.log("A* Manhattan Distance Selected");
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (Input.pressed("Two")) {
				MainWorld.pathType = 2;
				FP.log("A* Distance Formula Selected");
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (Input.pressed("Three")) {
				MainWorld.pathType = 3;
				FP.log("Greedy BFS Manhattan Distance Selected");
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (Input.pressed("Four")) {
				MainWorld.pathType = 4;
				FP.log("Greedy BFS Distance Formula Selected");
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (Input.pressed("Five")) {
				MainWorld.pathType = 5;
				FP.log("Dijkstra's Formula Selected");
				if (pathFinder!= null) {
					pathFinder.generateNewPath(this, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
				}
			}
			if (Input.pressed("ModUp")) {
				timeMod++;
				FP.log("Update once every: " + timeMod + " frames.");
			}
			if (Input.pressed("ModDown")) {
				if (timeMod > 0) {
					timeMod--;
					FP.log("Update once every: " + timeMod + " frames.");
				}
			}
			if (Input.check("Up")) {
				this.y -= 1;
				image.play("WalkUp");
				DIRECTION = "Up";
			} else if (Input.check("Down")) {
				this.y += 1;
				image.play("WalkDown");
				DIRECTION = "Down";
			} else if (Input.check("Left")) {
				this.x -= 1;
				image.play("WalkLeft");
				DIRECTION = "Left";
			} else if (Input.check("Right")) {
				this.x += 1;
				image.play("WalkRight");
				DIRECTION = "Right";
			} else {
				image.play("Stand" + DIRECTION);
			}
		}
		
		public function updateCollision():void {
			if( this.collide("level",x,y)) {
				trace("Collision!");
				if (DIRECTION == "Right") {
					this.x -= 1;
				} else if (DIRECTION == "Left") {
					this.x += 1;
				}
				if (DIRECTION == "Up") {
					this.y += 1;
				} else if (DIRECTION == "Down") {
					this.y -= 1;
				}
			}
		}
	}
}