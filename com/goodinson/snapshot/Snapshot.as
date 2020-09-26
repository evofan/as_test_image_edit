package com.goodinson.snapshot//goodinson氏作成のsnapshotクラス（Mainクラスから呼ばれて使用される）
{
	//import com.goodinson.snapshot.*;
	import com.adobe.images.*;//as3corelibのJPEG、PNGエンコーダーをインポート
	import com.dynamicflash.util.Base64;//Base64 encoder/decoderをインポート
	//String or ByteArray オブジェクトをBase64でエンコード/デコード
	//Base64は、データを64種類の印字可能な英数字のみを用いて、それ以外の文字を扱うことの出来ない通信環境にてマルチバイト文字やバイナリデータを扱うためのエンコード方式である
	//主に電子メール（添付ファイルのバイナリを）やBasic認証（IDやPASSの文字列を）、電子掲示板（圧縮した画像やテキストを）で使われる。
	import flash.display.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.ByteArray;//バイト配列操作用
	
	//import GIFEncoder;//GIF保存用
	import org.gif.encoder.GIFEncoder;


	public class Snapshot
	{
		
		//■クラスプロパティ
		// supported image file types
		public static const JPG:String = "jpg";//定数JPGはjpg
		public static const PNG:String = "png";//定数PNGはjpg
		
		public static const GIF:String = "gif";//定数PNGはjpg//追加
		
		// supported server-side actions
		public static const DISPLAY:String = "display";//定数DISPLAYはdisplay
		public static const PROMPT:String = "prompt";//定数PROMPTはprompt
		public static const LOAD:String = "load";//定数LOADはload
		
		// default parameters
		private static const JPG_QUALITY_DEFAULT:uint = 95;//定数JPG_QUALITY_DEFAULTは80（jpg画像の画質）
		private static const PIXEL_BUFFER:uint = 0;//定数PIXEL_BUFFERは1（アンチエイリアスの為、キャプチャー時に加えるバッファ
		private static const DEFAULT_FILE_NAME:String = 'snapshot';//定数DEFAULT_FILE_NAMEはsnapshot（保存する画像の名前）
		
		// path to server-side script
		public static var gateway:String;//gatewayは使用するPHPのパス（Main.as内で指定される）
		
		public function Snapshot():void//コンストラクタ（元は無し）
		{
			//
		}
		
		public static function capture(target:DisplayObject, options:Object):void//静的メソッドなのでインスタンス作成無しに呼び出される
		//キャプチャーボタン押下時の処理（ターゲットのDisplayObject、{画像フォーマット、保存フォーマット、ローダー？｝を指定して）実行
		{
			//ディスプレイオブジェクト選択
			var relative:DisplayObject = target.parent;//つまりmc_sampleの親＝Mainクラス
			trace("relative : " + relative);//relative : [object Main]
			
			// get target bounding rectangle//ターゲットの矩形の境界を取得
			var rect:Rectangle = target.getBounds(relative);
			//Rectangle オブジェクトは、その位置（左上隅のポイント (x, y) で示される）、および幅と高さで定義される領域です。
			//DisplayObjectクラスのgetBoundsメソッド
			//getBounds(targetCoordinateSpace:DisplayObject):Rectangle
			//targetCoordinateSpace オブジェクトの座標系を基準にして、表示オブジェクトの領域を定義する矩形を返します。
			//★つまりここでは、座標系（[object Main]）を基準にして表示オブジェクト（mc_sample）の領域を定義する矩形を返す↓★（固定サイズなら不要だが可変サイズでは必須？）
			trace("rect : " + rect);//rect : (x=33.15, y=29.7, w=191.7, h=182.60000000000002)
			
			// capture within bounding rectangle;矩形の境界をキャプチャーする
			//add a 1-pixel buffer around the perimeter（周辺） to ensure（確保する） that all anti-aliasing is included
			//全てのアンチエイリアスが含まれる事を確保する為に、周辺の周りに1pxのバッファを加える
		//var bitmapData:BitmapData = new BitmapData(rect.width + PIXEL_BUFFER * 2, rect.height + PIXEL_BUFFER * 2);
			//新規ビットマップインスタンス作成（width:int, height:int, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF）
			//バッファの分だけ上下左右にpxを足して
			
			//↑文字が下突き抜けるので、読み込んだ画像サイズに固定
			var bitmapData:BitmapData = new BitmapData(_global.myBitmapWidth, _global.myBitmapHeight);
			
			// capture the target into bitmapData
			bitmapData.lock();//GIF実装時追加、setPixek用？
			//draw()はsource 表示オブジェクトをビットマップイメージ上に描画
			bitmapData.draw(relative, new Matrix(1, 0, 0, 1, -rect.x + PIXEL_BUFFER, -rect.y + PIXEL_BUFFER));
			//draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, 
			//blendMode:String = null, clipRect:Rectangle = null, smoothing:Boolean = false)
			//draw（表示オブジェクトまたは BitmapData オブジェクト、ビットマップの座標を拡大 / 縮小、回転、または変換Matrix(1,0,0,1,バッファ分戻す,バッファ分戻す)又はnullでデフォルト、
			//new Matrix(a：xscale,歪曲(傾斜),歪曲(傾斜),d:yscale,x軸方向の平行移動pix値,y軸方向の平行移動pix値);
			bitmapData.unlock();//GIF実装時追加、setPixek用？
			
			// encode image to ByteArray
			var byteArray:ByteArray;//新規バイト配列インスタンス作成
			switch (options.format)//引数のoption（連想配列のformatの値でで条件分岐）
			{
				case JPG://JPGなら
					// encode as JPG
					var jpgEncoder:JPGEncoder = new JPGEncoder(JPG_QUALITY_DEFAULT);//新規jpgEncoderインスタンス作成（引数で画質）
					byteArray = jpgEncoder.encode(bitmapData);//新規バイト配列インスタンスはbitmapdataをJpgエンコードして生成
					break;//停止

				case GIF://GIF追加
					// encode as GIF
					//GIFエンコーダー使用
					var myGifEncoder:GIFEncoder = new GIFEncoder();//新規GIFエンコーダーインスタンス作成
					myGifEncoder.start();//エンコード開始
					myGifEncoder.addFrame(bitmapData);//エンコードするビットマップデータを渡す
					myGifEncoder.finish();//エンコード終了
					//var myByteArray:ByteArray = myGifEncoder.stream;//バイナリデータにエンコード結果を渡す
					byteArray = myGifEncoder.stream;//バイナリデータにエンコード結果を渡すs
					break;//停止

				case PNG://PNGまたは
					default://指定無しなら
					// encode as PNG
					byteArray = PNGEncoder.encode(bitmapData);//新規バイト配列インスタンスはbitmapdataをPngエンコードして生成
					break; 停止
			}
			
			// convert binary ByteArray to plain-text, for transmission in POST data
			//バイナリのバイト配列インスタンスをプレーンテキストに変換、POSTデータとして送信するために
			var byteArrayAsString:String = Base64.encodeByteArray(byteArray);//Base64方式でエンコード

			// constuct server-side URL to which to send image data
			//イメージデータを送るために、サーバーサイドのURLを乱数付加で生成
			var url:String = gateway + '?' + Math.random();
			
			// determine name of file to be saved / displayed
			//保存又は表示する名前を決定する
			var fileName:String = DEFAULT_FILE_NAME + '.' + options.format;//デフォルトファイル名+引数のoptionの連想配列のformatの値（拡張子）
			
			// create URL request
			var request:URLRequest = new URLRequest(url);//新規URLリクエストインスタンス作成作成
			
			// send data via POST method
			request.method = URLRequestMethod.POST;//送信方法をPOST形式で指定
			
			// set data to send
			var variables:URLVariables = new URLVariables();//新規送信用インスタンス作成
			variables.format = options.format;//送信用インスタンスのformatプロパティを設定
			variables.action = options.action;//送信用インスタンスのactionプロパティを設定
			variables.fileName = fileName;//送信用インスタンスのfilenameを設定
			variables.image = byteArrayAsString;//送信用インスタンスのimageプロパティを設定
			request.data = variables;//URLリクエストのデータ型はURLVariables
			
			if (options.action == LOAD)//引数のoptionのactionが”LOAD”なら
			{
				// load image back into loadContainer
				options.loader.load(request);//Flash内部に表示（右側のムービークリップloader内にロード）
				
			} else
			{
				navigateToURL(request, "_blank");//それ以外なら、ブラウザで開く
				//保存かブラウザ上表示化は、PHP側で判別して処理
			}
		}
	}
}