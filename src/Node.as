package
{
	import flash.geom.Point;
	
	public class Node extends Point
	{
		public var parent:Node;
		public var gCost:int;
		public var fCost:int;
		public var goalX:int;
		public var goalY:int;
		public var dist:int;
		public function Node(x:Number=0, y:Number=0, goalX:int=0, goalY:int=0, p:Node=null)
		{
			this.goalX = goalX;
			this.goalY = goalY;
			parent = p;
			super(x, y);
			updateFCost();
		}
		
		public function updateFCost():void {
			updateGCost();
			if (MainWorld.pathType == 1) {
				//A* Manhattan Distance:
				dist = Math.abs(this.x - this.goalX) + Math.abs(this.y - this.goalY);
				fCost = gCost + dist;
			} else if (MainWorld.pathType == 2) {
				//A* Distance Formula:
				dist = Math.sqrt((this.x-goalX)*(this.x-goalX) + (this.y-goalY)*(this.y-goalY));
				fCost = gCost + dist;
			} else if (MainWorld.pathType == 3) {
				//Greedy best first Distance Formula:
				dist = Math.sqrt((this.x-goalX)*(this.x-goalX) + (this.y-goalY)*(this.y-goalY));
				fCost = dist;
			} else if (MainWorld.pathType == 4) {
				//Greedy best first Manhattan Distance
				dist = Math.abs(this.x - this.goalX) + Math.abs(this.y - this.goalY);
				fCost = dist;
			} else {
				//Slightly Modified Dijkstra
				fCost = gCost;
			}
		}
		public function updateParent(p:Node):void {
			parent = p;
		}
		public function updateGCost():void {
			if (parent != null) {
				if (this.x == parent.x || this.y == parent.y) {
					gCost = parent.gCost + 16;
				} else {
					gCost = parent.gCost + 22;
				}
			} else {
				gCost = 0;
			}
		}
	}
}