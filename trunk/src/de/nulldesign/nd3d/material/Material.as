package de.nulldesign.nd3d.material 
{
	import flash.display.BitmapData;		
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	public class Material 
	{
		public var color:uint;
		public var isSprite:Boolean;
		public var doubleSided:Boolean = false;
		public var smoothed:Boolean = false;
		public var additive:Boolean = false;
		public var calculateLights:Boolean = true;
		private var _alpha:Number;
		private var _texture:BitmapData;
		private var transformedTexture:BitmapData;
		private var isDirty:Boolean;

		public function Material(color:uint, alpha:Number, texture:BitmapData = null, doubleSided:Boolean = false, smoothed:Boolean = false, additive:Boolean = false, calculateLights:Boolean = false) 
		{
			this.texture = texture;
			this.color = color;
			this.alpha = alpha;
			this.doubleSided = doubleSided;
			this.smoothed = smoothed;
			this.additive = additive;
			this.calculateLights = calculateLights;
		}

		public function clone():Material 
		{
			return new Material(color, alpha, texture, doubleSided, smoothed, additive, calculateLights);
		}
		
		public function applyTransformations():void
		{
			if (!_texture) return;
			isDirty = false;
			
			if (_alpha == 1) 
			{
				if (transformedTexture && transformedTexture != _texture) transformedTexture.dispose();
				transformedTexture = _texture;
				return;
			}
			
			if (!transformedTexture || transformedTexture == _texture)
			{
				transformedTexture = new BitmapData(_texture.width, _texture.height, true, 0);
			}
			else transformedTexture.fillRect(transformedTexture.rect, 0);
			
			var ct:ColorTransform = new ColorTransform();
			ct.alphaMultiplier = _alpha;
			transformedTexture.draw(_texture, new Matrix(), ct);
		}
		
		public function get alpha():Number { return _alpha; }
		
		public function set alpha(value:Number):void 
		{
			if (_alpha == value) return;
			_alpha = value;
			isDirty = true;
		}
		
		public function get texture():BitmapData 
		{
			if (isDirty) applyTransformations();
			return transformedTexture; 
		}
		
		public function set texture(value:BitmapData):void 
		{
			_texture = value;
			isDirty = true;
		}
	}
}
