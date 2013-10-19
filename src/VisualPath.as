package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	public class VisualPath extends Entity
	{
		[Embed(source = '/assets/tiles.png')] private const TILES:Class;
		private var _tiles:Tilemap;
		private var _grid:Grid;
		public var tileWidth:int;
		public var tileHeight:int;
		public function VisualPath()
		{
			this.type = "path";
			tileWidth = 800;
			tileHeight = 800;
			_tiles = new Tilemap(TILES,tileWidth,tileHeight,16,16);
			
			_grid = new Grid(tileWidth, tileHeight, 16, 16);
			mask = _grid;
			graphic = _tiles;
			layer = 1;
		}
		
		public function addTile(x:int, y:int, index:int, wall:Boolean):void {
			_tiles.setTile(Math.floor(x/16), Math.floor(y/16), index);
			if (wall) {
				_grid.setTile(Math.floor(x/16), Math.floor(y/16), true);
			}
		}
		
		public function clearLevel():void {
			_tiles.clearRect(0,0,tileWidth/16,tileHeight/16);
			_grid.clearRect(0,0,tileWidth/16,tileHeight/16);
		}
		
		public function newMap(columns:int, rows:int):void {
			clearLevel();
			tileWidth = columns*16;
			tileHeight = rows*16;
			_tiles = new Tilemap(TILES, tileWidth, tileHeight, 16, 16);
		}
	}
}