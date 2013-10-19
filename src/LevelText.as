package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	public class LevelText extends Entity
	{
		public function LevelText()
		{
			
		}
		public function addText(text:String, x:int, y:int):void
		{
			var temp:Text = new Text(text,x,y);
			temp.size /= 2;
			this.addGraphic(temp);
		}
	}
}