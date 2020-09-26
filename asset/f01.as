package {

    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.FileReferenceList;

    public class f01 extends Sprite {

        //class propery
        //新規ファイルリファレンス
        public var myFileRef:FileReference = new FileReference();
        //新規ファイルリファレンスリスト
        public var myFileRefList:FileReferenceList = new FileReferenceList();

        //ファイルフィルタ1
        public var myFileFlter1:FileFilter = new FileFilter("CompuServe GIF（*.GIF）", "*.gif");
        //ファイルフィルタ2
        public var myFileFlter2:FileFilter = new FileFilter("JPEG（*.JPG）", "*.jpg");
        //ファイルフィルタ3
        public var myFileFlter3:FileFilter = new FileFilter("PNG（*.PNG）", "*.png");

        public function f01():void {
            //コンスト
            trace("f01 コンスト");
            init();
        }

        public function init():void {
            trace("init");
            bt_open.addEventListener(MouseEvent.CLICK, onClick); //開くボタン押下時
            myFileRef.addEventListener(Event.SELECT, onSelect); //ファイル選択時
            myFileRef.addEventListener(Event.CANCEL, onCancel); //ファイル未選択（キャンセル）時
            myFileRef.addEventListener(Event.COMPLETE, onComplete); //ファイル読み込み完了
        }

        public function onClick(e:MouseEvent):void {
            trace("bt_open click!");
            //ファイルの種類を指定してダイアログを開く
            myFileRef.browse([myFileFlter1, myFileFlter2, myFileFlter3]);
        }

        public function onSelect(e:Event):void {
            trace("file selected!");
            //選択されたファイル名を表示
            trace(e.target.name); //bn100511_04.gif
            //リスナー、消すｍボタン消す
            var f:FileReference = FileReference(e.target); //引数付で生成する場合はnewはいらない？
            f.load(); //Flash Player10-
            //FileReference.loadでロードしたデータは必ずバイナリ形式になるので
            trace("f : " + f); //f : [object FileReference]
            trace("f.data1:" + f.data); //f.data1:null…complete後じゃないとnull？

        }

        public function onCancel(e:Event):void {
            trace("file not selected!");
        }

        public function onComplete(e:Event):void {
            trace("onComplete");
            var ff:FileReference = FileReference(e.target); //引数付で生成する場合はnewはいらない？
            //ff.load();//Flash Player10-
            trace("ff : " + ff); //ff : [object FileReference]
            //trace("f.data2"+f.data);
            trace("ff.data:" + ff.data); //ff.data:GIF89a

            var myLoader:Loader = new Loader();
            myLoader.loadBytes(ff.data); //loadByte＝ByteArrayオブジェクトからイメージをロードする

            //ロードしたものがアクセス可能になった時に実行
            myLoader.contentLoaderInfo.addEventListener(Event.INIT, loadFileInit);


        }

        public function loadFileInit(e:Event):void {
            trace("loadFileInit");
            trace(e.target.content); //[object Bitmap]
            var myBitmap:Bitmap = Bitmap(e.target.content);
            myBitmap.x = 50;
            myBitmap.y = 100;
            addChild(myBitmap);
            trace("this:" + this); //this:[object f01]

        }

    }

}
