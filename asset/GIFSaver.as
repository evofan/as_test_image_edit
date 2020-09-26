package {
    import flash.display.Sprite;
    import flash.events.EventDispatcher;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import flash.display.BitmapData;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.MovieClip;


    //GIF Encoder
    import org.gif.encoder.GIFEncoder



    public class GIFSaver extends Sprite {


        //public var fileListener:Object = new Object();	
        //as3gif
        //http://code.google.com/p/as3gif/
        //GIFEncoder 0.1.zip   570 KB

        //[AS3.0] GIFSaverクラスに挑戦！
        //http://www.project-nya.jp/modules/weblog/details.php?blog_id=1211

        //class property
        public var _this:Object = new Object();
        public var myFile:FileReference = new FileReference();

        //コンストラクタ
        public function GIFSaver():void {
            //public function GifSaver(e:Object):void {
            trace("***** GifSaverコンストラクタ *****");
            //_this= e;
            //trace("_this : " + _this);//_this : [object MainTimeline]
            init();
        }

        //初期設定
        public function init():void {
            trace("***** init *****");
            //var myFile:FileReference= new FileReference();
            myFile.addEventListener(Event.OPEN, onOpen);
            myFile.addEventListener(ProgressEvent.PROGRESS, onProgress);
            myFile.addEventListener(Event.COMPLETE, onComplete);
            myFile.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            myFile.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
            myFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            //myFile.addEventListener(fileListener);


        }

        //saveメソッド（外から呼ばれる）
        public static function GifSave(e:BitmapData, ee:String):void {
            trace("+++++ GifSave +++++");
            //外部のビットマップデータの参照渡し
            var myBitmapData:BitmapData = new BitmapData(e.width, e.height);
            myBitmapData.lock(); //本来はsetPixel()等のメソッドの動作軽減に使う
            myBitmapData.draw(e); //eのビットマップデータをmyBitmapData上に描画する
            myBitmapData.unlock(); //ロック解除
            //GIFエンコーダー使用
            var myGifEncoder:GIFEncoder = new GIFEncoder(); //新規インスタンス作成
            myGifEncoder.start(); //エンコード開始
            myGifEncoder.addFrame(myBitmapData); //エンコードするビットマップデータを渡す
            myGifEncoder.finish(); //エンコード終了
            var myByteArray:ByteArray = myGifEncoder.stream; //バイナリデータにエンコード結果を渡す
            //trace("myByteArray: : " + myByteArray);
            //x
            //myFile.download(myByteArray, ee);//ファイル保存
            //x
            //myFile.bt_saveBtn_click(myByteArray, ee);//ファイル保存

            var loader:Loader = new Loader();
            loader.loadBytes(myByteArray);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void {
                var bd:BitmapData = new BitmapData(loader.width, loader.height);
                bd.draw(loader);


            });

            //MovieClip(root).addChild(bd);
            var myFile2:FileReference = new FileReference();
            myFile2.save(myByteArray, ee)
        }



        //ファイルオープン
        public function onOpen(e:Event):void {
            dispatchEvent(e);
        }

        //ファイル読み込み中
        public function onProgress(e:ProgressEvent):void {
            dispatchEvent(e);
        }

        //ファイル読み込み完了
        public function onComplete(e:Event):void {
            dispatchEvent(e);
        }

        //ファイル読み込みエラー
        public function onIOError(e:IOErrorEvent):void {
            dispatchEvent(e);
        }

        //ファイル読み込みステータス
        public function onHTTPStatus(e:HTTPStatusEvent):void {
            dispatchEvent(e);
        }

        //ファイルセキュリティエラー
        public function onSecurityError(e:SecurityErrorEvent):void {
            dispatchEvent(e);
        }

    }


}
