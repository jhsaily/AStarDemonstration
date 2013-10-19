package
{	
	import net.flashpunk.Entity;

	public class AStarPathfinder
	{
		public static var closedList:Vector.<Node>;
		public static var openList:Vector.<Node>;
		public var currentNode:Node;
		public var currentIndex:int = 0;
		public var startX:int;
		public var startY:int;
		public var newPath:Boolean = true;
		public function AStarPathfinder()
		{
		}
		public function generateNewPath(entity:Entity, goalX:int, goalY:int):void {
			startX = entity.x + 8 - (entity.x + 8)%16;
			startY = entity.y + 10 - (entity.y + 10)%16;
			openList = new Vector.<Node>();
			closedList = new Vector.<Node>();
			openList.splice(0,openList.length);
			closedList.splice(0,closedList.length);
			openList.push(new Node(startX,startY,goalX,goalY));
			newPath = false;
		}
		public function findPath(entity:Entity, goalX:int, goalY:int):Node {
			if (newPath) {
				startX = entity.x + 8 - (entity.x + 8)%16;
				startY = entity.y + 10 - (entity.y + 10)%16;
				openList = new Vector.<Node>();
				closedList = new Vector.<Node>();
				openList.splice(0,openList.length);
				closedList.splice(0,closedList.length);
				openList.push(new Node(startX,startY,goalX,goalY));
				newPath = false;
			}
			return aStarLogic(goalX, goalY);
		}
		
		public function aStarLogic(goalX:int, goalY:int):Node {
			//while(openList.length > 0) {
			if (openList.length > 0) {
				currentNode = null;
				for(var i:int = 0; i < openList.length; i++) {
					if(currentNode == null) {
						currentNode = openList[i];
						currentIndex = i;
					} else {
						if (openList[i].fCost < currentNode.fCost) {
							currentNode = openList[i];
							currentIndex = i;
						}
					}
				}
				i = 0;
				
				if (currentNode.x == goalX && currentNode.y == goalY) {
					return currentNode;
				}
				openList.splice(currentIndex,1);
				closedList.push(currentNode);
				var temp:Vector.<Node> = new Vector.<Node>;
				temp.splice(0,temp.length);
				temp = getNeighbors(currentNode);
				for (var j:int = 0; j < temp.length; j++) {
					var tentGCost:int;
					if (temp[j].x == currentNode.x || temp[j].y == currentNode.y) {
						tentGCost = currentNode.gCost + 16;
					} else {
						tentGCost = currentNode.gCost + 22;
					}
					var neighborClosedIndex:int = inClosedList(temp[j]);
					var neighborOpenIndex:int = inOpenList(temp[j]);
					if (neighborClosedIndex != -1) {
						if(tentGCost > closedList[i].gCost) {
							// Continue
						} else {
							trace("ERROR");
						}
					} 
					
					if (neighborOpenIndex == -1) {
						temp[j].updateParent(currentNode);
						temp[j].updateFCost();
						
						if(neighborOpenIndex == -1 && neighborClosedIndex == -1) {
							openList.push(temp[j]);
						}
					} else if (tentGCost < openList[neighborOpenIndex].gCost) {
						openList[neighborOpenIndex].updateParent(currentNode);
						openList[neighborOpenIndex].updateFCost();
					}
				}
				j = 0;
			}
			return currentNode;
		}
		
		public function inOpenList(node:Node):int {
			for(var i:int = 0; i < openList.length; i++) {
				if(node.x == openList[i].x && node.y == openList[i].y) {
					return i;
				}
			}
			return -1;
		}
		public function inClosedList(node:Node):int {
			for(var i:int = 0; i < closedList.length; i++) {
				if(node.x == closedList[i].x && node.y == closedList[i].y) {
					return i;
				}
			}
			return -1;
		}
		public function getNeighbors(node:Node):Vector.<Node> {
			var v:Vector.<Node> = new Vector.<Node>;
			if (MainWorld.mLevel._tiles.getTile((node.x + 16)/16, node.y/16) != 0) {
				v.push(new Node(node.x + 16, node.y, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile(node.x/16, (node.y + 16)/16) != 0) {
				v.push(new Node(node.x, node.y + 16, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile((node.x - 16)/16, node.y/16) != 0) {
				v.push(new Node(node.x - 16, node.y, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile(node.x/16, (node.y - 16)/16) != 0) {
				v.push(new Node(node.x, node.y - 16, node.goalX, node.goalY, node));
			}
		
			if (MainWorld.mLevel._tiles.getTile((node.x + 16)/16, (node.y + 16)/16) != 0
				&& (MainWorld.mLevel._tiles.getTile((node.x + 16)/16, node.y/16) != 0
					&& MainWorld.mLevel._tiles.getTile(node.x/16, (node.y + 16)/16) != 0)) {
				v.push(new Node(node.x + 16, node.y + 16, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile((node.x + 16)/16, (node.y - 16)/16) != 0
				&& (MainWorld.mLevel._tiles.getTile((node.x + 16)/16, node.y/16) != 0
					&& MainWorld.mLevel._tiles.getTile(node.x/16, (node.y - 16)/16) != 0)) {
				v.push(new Node(node.x + 16, node.y - 16, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile((node.x - 16)/16, (node.y + 16)/16) != 0
				&& (MainWorld.mLevel._tiles.getTile((node.x - 16)/16, node.y/16) != 0
					&& MainWorld.mLevel._tiles.getTile(node.x/16, (node.y + 16)/16) != 0)) {
				v.push(new Node(node.x - 16, node.y + 16, node.goalX, node.goalY, node));
			}
			if (MainWorld.mLevel._tiles.getTile((node.x - 16)/16, (node.y - 16)/16) != 0
				&& (MainWorld.mLevel._tiles.getTile((node.x - 16)/16, node.y/16) != 0
					&& MainWorld.mLevel._tiles.getTile(node.x/16, (node.y - 16)/16) != 0)) {
				v.push(new Node(node.x - 16, node.y - 16, node.goalX, node.goalY, node));
			}
			
			return v;
		}
	}
}