package de.nulldesign.nd3d.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	import de.nulldesign.nd3d.events.MeshLoadEvent;
	import de.nulldesign.nd3d.material.Material;
	import de.nulldesign.nd3d.objects.Mesh;
	import de.nulldesign.nd3d.utils.ASEParser;	

	public class MeshLoader extends EventDispatcher 
	{
		public static const MESH_TYPE_ASE:String = "ase";
		public static const MESH_TYPE_MD2:String = "md2";
		public static const MESH_TYPE_3DS:String = "3ds";		
		
		private var mesh:Mesh;

		private var meshUrl:String;
		private var meshType:String;
		private var textureList:Array;
		private var matList:Array;
		private var defaultMaterial:Material;

		private var loader:URLLoader;
		private var meshData:*;
		private var textureLoader:Loader;
		private var textureLoadIndex:Number = 0;

		public function MeshLoader() 
		{
		}

		public function loadMesh(meshUrl:String, textureList:Array, defaultMaterial:Material):void 
		{
			this.meshUrl = meshUrl;
			this.textureList = textureList;
			this.defaultMaterial = defaultMaterial;
			this.meshType = meshUrl.substr(meshUrl.length - 3, 3).toLowerCase();
			
			matList = [];
			
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMeshLoaded);
			
			switch(meshType)
			{
				case MeshLoader.MESH_TYPE_ASE: 
					loader.dataFormat = URLLoaderDataFormat.TEXT;	
					break;
				case MeshLoader.MESH_TYPE_3DS: 
				case MeshLoader.MESH_TYPE_MD2: 
					loader.dataFormat = URLLoaderDataFormat.BINARY;	
					break;
			}

			loader.load(new URLRequest(meshUrl));
		}
		
		public function loadMeshBytes(meshData:ByteArray, textureList:Array, defaultMaterial:Material, meshType:String):void 
		{
			this.meshUrl = null;
			meshData.position = 0;
			this.meshData = meshData.readUTFBytes(meshData.length);
			this.textureList = textureList;
			this.defaultMaterial = defaultMaterial;
			this.meshType = meshType;
			
			matList = [];
			if(textureList.length) 
			{
				loadNextTexture();
			} else 
			{
				buildMesh();
			}
		}

		private function buildMesh():void 
		{
			switch(meshType)
			{
				case MeshLoader.MESH_TYPE_ASE:
					mesh = ASEParser.parseFile(meshData, matList, defaultMaterial);
					break;
					
				case MeshLoader.MESH_TYPE_3DS:
					var max3dsParseObj:Max3DSParser = new Max3DSParser();
					mesh = max3dsParseObj.parseFile(ByteArray(meshData), matList, defaultMaterial);
					break;
				
				case MeshLoader.MESH_TYPE_MD2:
					mesh = MD2Parser.parseFile(ByteArray(meshData), matList[0], defaultMaterial);
					break;
			}
			
			dispatchEvent(new MeshLoadEvent(mesh));
		}

		private function onMeshLoaded(evt:Event):void 
		{
			meshData = evt.target.data;
			loader.removeEventListener(Event.COMPLETE, onMeshLoaded);
			loader = null;
			
			if(textureList.length) 
			{
				loadNextTexture();
			} else 
			{
				buildMesh();
			}
		}

		private function loadNextTexture():void 
		{
			textureLoader = new Loader();
			textureLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTextureLoaded);
			
			var texture:* = textureList[textureLoadIndex];
			if (texture is ByteArray)
			{
				textureLoader.loadBytes(texture);
			}
			else
			{
				var urlReq:URLRequest = new URLRequest(texture);
				textureLoader.load(urlReq);
			}
		}

		private function onTextureLoaded(evt:Event):void 
		{
			++textureLoadIndex;
			
			textureLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onTextureLoaded);
			
			var bmp:BitmapData;
			if(textureLoader.contentLoaderInfo.contentType == "image/png") 
			{
				bmp = new BitmapData(textureLoader.width, textureLoader.height, true, 0x00000000);
			} else 
			{
				bmp = new BitmapData(textureLoader.width, textureLoader.height, false, 0x000000);
			}

			bmp.draw(textureLoader);
			
			var tmpMat:Material = defaultMaterial.clone();
			tmpMat.texture = bmp;
			
			matList.push(tmpMat);
			
			if(textureLoadIndex < textureList.length) 
			{
				loadNextTexture();
			} else 
			{
				buildMesh();
			}
		}
	}	
}
