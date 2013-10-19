package
{
	import com.adobe.viewsource.ViewSource;
	
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.fscommand;
	
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.debug.Console;
	
	public class Main extends Engine
	{
		private var _file:FileReference;
		private var levelString:String;
		private var levelArray:Array;
		public function Main()
		{
			ViewSource.addMenuItem(this, "srcview/index.html");
			stage.addEventListener(Event.RESIZE, onResize);
			stage.color = 0x202020;
			super(300, 225, 60, false);
			FP.screen.scale = 2;
			FP.world = new MainWorld;
		}
		override public function init():void {
			FP.console.enable();
			super.init();
		}
		public function onResize (e:Event):void
		{
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.SHOW_ALL;
			trace("Resize detected!");
		}
		override public function update():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, browse);
			super.update();
		}
		private function browse(event:KeyboardEvent):void {
			if (event.keyCode == 76) {
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, loadFile);
				var fileFilter:FileFilter = new FileFilter("Text File: (*.txt)", "*.txt");
				_file.browse([fileFilter]);
			}
		}
		private function loadFile(event:Event):void {
			_file.removeEventListener(Event.SELECT, loadFile);
			_file.addEventListener(Event.COMPLETE, parseFile);
			_file.load();
		}
		private function parseFile(event:Event):void {
			_file.removeEventListener(Event.COMPLETE, parseFile);
			MainWorld.mLevel.clearLevel();
			levelString = _file.data.toString();
			levelArray = levelString.split('');
			generateLevel();
		}
		private function generateLevel():void {
			var row:int = 0;
			var rowLength:int = 0;
			var obtained:Boolean = false;
			MainWorld.mLevel.goalX = -1;
			MainWorld.mLevel.goalY = -1;
			for(var i:int = 0; i < levelArray.length; i++) {
				if(levelArray[i] == "0" || levelArray[i] == "o") {
					MainWorld.mLevel.addTile(i*16 - rowLength*row*16, row*16, 0, true);
				} else if (levelArray[i] == "1" || levelArray[i] == "e") {
					MainWorld.mLevel.addTile(i*16 - rowLength*row*16, row*16, 1, false);
				} else if (levelArray[i] == "2") {
					MainWorld.mLevel.addTile(i*16 - rowLength*row*16, row*16, 3, false);
					MainWorld.mLevel.goalX = i*16 - rowLength*row*16;
					MainWorld.mLevel.goalY = row*16;
				} else if (levelArray[i] == "\n") {
					row++;
					if (obtained == false) {
						rowLength = i+1;
						obtained = true;
					}
				}
			}
			MainWorld.player.x = 16;
			MainWorld.player.y = 12;
			if (MainWorld.player.pathFinder != null){
				MainWorld.path.clearLevel();
				MainWorld.player.pathFinder.generateNewPath(MainWorld.player, MainWorld.mLevel.goalX, MainWorld.mLevel.goalY);
			}
		}
	}
}