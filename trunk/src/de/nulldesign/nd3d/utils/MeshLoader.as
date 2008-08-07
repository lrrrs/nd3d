package de.nulldesign.nd3d.utils {
	
	import de.nulldesign.nd3d.events.MeshLoadEvent;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.utils.ASEParser;
	
	public class MeshLoader extends EventDispatcher {
		
		private var mesh:Mesh;
		
		private var meshUrl:String;
		private var textureUrlList:Array;
		private var matList:Array;
		private var defaultMaterial:Material;
		
		private var loader:URLLoader;
		private var textureLoader:Loader;
		private var textureLoadIndex:Number = 0;
		
		public function MeshLoader() {
			
		}
		
		public function loadMesh(meshUrl:String, textureUrlList:Array, defaultMaterial:Material):void {
			
			this.meshUrl = meshUrl;
			this.textureUrlList = textureUrlList;
			this.defaultMaterial = defaultMaterial;
			
			matList = [];
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMeshLoaded);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest(meshUrl));
		}
		
		private function buildMesh():void {
			mesh = ASEParser.parseFile(loader.data, matList, defaultMaterial);
			dispatchEvent(new MeshLoadEvent(mesh));
		}
		
		private function onMeshLoaded(evt:Event):void {
			if(textureUrlList.length) {
				loadNextTexture();
			} else {
				buildMesh();
			}
		}
		
		private function loadNextTexture():void {
			
			textureLoader = new Loader();
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);

			var urlReq:URLRequest = new URLRequest(textureUrlList[textureLoadIndex]);
			textureLoader.load(urlReq);
		}
		
		private function onTextureLoaded(evt:Event):void {
			
			++textureLoadIndex;
			
			textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureLoaded);
			
			var bmp:BitmapData;
			if(textureLoader.contentLoaderInfo.contentType == "image/png") {
				bmp = new BitmapData(textureLoader.width, textureLoader.height, true, 0x00000000);
			} else {
				bmp = new BitmapData(textureLoader.width, textureLoader.height, false, 0x000000);
			}

			bmp.draw(textureLoader);
			
			var tmpMat:Material = defaultMaterial.clone();
			tmpMat.texture = bmp;
			
			matList.push(tmpMat);
			
			if(textureLoadIndex < textureUrlList.length) {
				loadNextTexture();
			} else {
				buildMesh();
			}
		}
	}	
}
