package {
    import fl.transitions.Photo;
    import flash.display.Sprite;
    import flash.display.BitmapData;
    import flash.display.Bitmap;

    import flash.events.EventDispatcher;
    import flash.net.FileReference;
    import flash.utils.ByteArray;

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.IOErrorEvent;
    import flash.events.HTTPStatusEvent;
    import flash.events.SecurityErrorEvent;

    import flash.events.MouseEvent;

    import GIFSaver;

    import caurina.transitions.*;
    import caurina.transitions.properties.*;

    public class Main extends Sprite {

        //class property
        //public var _this:Object = new Object();

        private var mySaver:GIFSaver = new GIFSaver();
        //private var mySaver:GifSaver =  new GifSaver(_this);
        private var saveBtn:mc_hozon = new mc_hozon();
        private var useBitmap:Bitmap; // = new Bitmap();

        public function Main():void {
            //public function Main(e:Object):void {
            trace("***** Mainコンストラクタ *****");
            init2();
        }

        public function init2():void {
            trace("***** init2 *****");

            ColorShortcuts.init();
            DisplayShortcuts.init();

            //mySaver:GifSaver = new GifSaver();
            mySaver.addEventListener(Event.COMPLETE, onComplete2);
            addChild(saveBtn);
            saveBtn.x = 143;
            saveBtn.y = 230;
            saveBtn.enabled = true;
            saveBtn.useHandCursor = true;
            saveBtn.mouseEnabled = true;
            saveBtn.buttonMode = true;
            //saveBtn.addEventListener(MouseEvent.CLICK, onClick2);
            saveBtn.addEventListener(MouseEvent.CLICK, bt_saveBtn_click);
            saveBtn.addEventListener(MouseEvent.MOUSE_OVER, bt_saveBtn_over);
            saveBtn.addEventListener(MouseEvent.MOUSE_OUT, bt_saveBtn_out);

            //var bitmapData = new BitmapData();
            var useBitmapData:BitmapData = new BitmapData(400, 400, true, 0xFF000000);
            var photo:Photo = new Photo(400, 400);
            useBitmap = new Bitmap(photo);
            //addChild(useBitmap);//確認用
            useBitmap.x = 20;
            useBitmap.y = 20;
        }

        public function onComplete2(e:Event):void {
            trace("***** onComplete2 *****");
        }

        /*
           public function onClick2(e:MouseEvent):void {
           trace("***** onClick2 *****");
           }
         */

        function bt_saveBtn_click(e:MouseEvent):void {
            trace("bt_saveBtn_click !");
            //navigateToURL(footer_url1,"_blank");
            var tempBitmapData:BitmapData = useBitmap.bitmapData;
            GIFSaver.GifSave(tempBitmapData, "testtest.gif");
            //GIFSaver.init();
        }

        function bt_saveBtn_over(e:MouseEvent):void {
            trace("bt_saveBtn_over !");
            Tweener.addTween(saveBtn, {_brightness: 0.3, time: 1, alpha: 1});
        }

        function bt_saveBtn_out(e:MouseEvent):void {
            trace("bt_saveBtn_out !");
            Tweener.addTween(saveBtn, {_brightness: 0, time: 1, alpha: 1});
        }

    }


}

