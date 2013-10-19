package
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;

	public class MainWorld extends World
	{
		public static var mLevel:MainLevel;
		public static var path:VisualPath;
		public static var player:Player;
		public static var pathType:int;
		public static var world:MainWorld;
		public function MainWorld()
		{
			world = this;
			mLevel = new MainLevel;
			path = new VisualPath;
			pathType = 1;
			player = new Player;
			add(player);
			add(mLevel);
			add(path);
		}
	}
}