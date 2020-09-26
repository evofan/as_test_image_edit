package {
    import com.goodinson.snapshot.*; //Goodinson氏の画像ライブラリsnapshotクラスインポート
    import flash.display.*;
    import flash.events.*;
    import fl.controls.*;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    //file load
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.net.FileReferenceList;

    //scolor picker
    import fl.controls.ColorPicker;
    import fl.events.ColorPickerEvent;

    //キー入力
    //import flash.events.KeyboardEvent.*;

    //GIF関連
    //import GIFSaver;

    public class Main extends Sprite {
        private var grpAction:RadioButtonGroup; //新規RadioButtonGroup（コンポーネント）インスタンス作成
        private var grpFormat:RadioButtonGroup; //新規RadioButtonGroup（コンポーネント）インスタンス作成

        //file load
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

        //text
        public var myTextFormat:TextFormat = new TextFormat();

        //text
        public var myTextFormatOld:TextFormat = new TextFormat();

        //color pickler
        public var myColorPicker:ColorPicker = new ColorPicker();

        function Main() //コンストラクタ
        {
            // hide UI while initializing
            this.visible = false; //ステージ初期化まで非表示
            trace("this:" + this); //this:[object Main]
            addEventListener(Event.ADDED_TO_STAGE, onReady); //ステージ初期化完了で呼び出すリスナー登			//color picker settei

        }


        //----------------------------------------------------------------------

        public function onStart():void {
            //
            trace("onStart");
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
            //myBitmap.x = 50;
            //myBitmap.y = 100;
            //addChild(myBitmap);

            //ok
            //var abc:Number = myBitmap.width;
            //trace("abc : " + abc);//
            _global.myBitmapWidth = myBitmap.width;
            _global.myBitmapHeight = myBitmap.height;



            mc_sample.mc_kara.addChild(myBitmap);
            trace("this:" + this); //this:[object f01]

            //mc_sample.visible = true;

        }

        //----------------------------------------------------------------------

        private function onReady(evt:Event):void //ステージ初期化で呼び出される関数
        {
            // UI has been initialized
            visible = true; //初期化後にtrue
            removeEventListener(Event.ADDED_TO_STAGE, onReady); //ステージのリスナー削除

            //mc_sample.visible = false;


            myColorPicker.addEventListener(ColorPickerEvent.CHANGE, changeHandler);
            myColorPicker.move(30, 300); //カラーピッカー位置

            //初期値（default 黒）
            myColorPicker.selectedColor = 0x999999;
            addChild(myColorPicker);

            //■座布団関連ｓ
            var key1:String;
            var key2:String;
            //
            //mc_sample.mc_zabuton.


            //SHIFT
            /*
               var space_flg : Boolean = false;


               function KeyDownFunc(event){
               if(event.keyCode == "16"){
               space_flg = true;
               }
               }

               function KeyUpFunc(event){
               if(event.keyCode == "16"){
               space_flg = false;
               }
               }

               stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownFunc);
               stage.addEventListener(KeyboardEvent.KEY_UP, KeyUpFunc);

               stage.addEventListener(Event.ENTER_FRAME, function(event){
               if(space_flg){
               // trace("スペースキーが押されている");
               }else{
               // trace("スペースキーが押されていない");
               }
               });
             */

            //CURSOR
            stage.addEventListener(KeyboardEvent.KEY_DOWN, aClick)
            function aClick(e:KeyboardEvent):void {
                key1 = String(e.keyCode);
                trace("key1 : " + key1);
                if (key1 == "38") {
                    mc_sample.mc_zabuton.y -= 1;
                } else if (key1 == "40") {
                    mc_sample.mc_zabuton.y += 1;
                } else if (key1 == "37") {
                    mc_sample.mc_zabuton.x -= 1;
                } else if (key1 == "39") {
                    mc_sample.mc_zabuton.x += 1;
                }
                //key2 = String(e.keyCode);
                //trace("key2 : " + key2);
                else if (key1 == "104") {
                    mc_sample.mc_zabuton.height -= 1;
                    if (mc_sample.mc_zabuton.height < 10) {
                        mc_sample.mc_zabuton.height = 10
                    }
                } else if (key1 == "98") {
                    mc_sample.mc_zabuton.height += 1;
                    if (mc_sample.mc_zabuton.height > 100) {
                        mc_sample.mc_zabuton.height = 100
                    }
                } else if (key1 == "100") {
                    mc_sample.mc_zabuton.width -= 1;
                    if (mc_sample.mc_zabuton.width < 10) {
                        mc_sample.mc_zabuton.width = 10
                    }
                } else if (key1 == "102") {
                    mc_sample.mc_zabuton.width += 1;
                    if (mc_sample.mc_zabuton.width > 100) {
                        mc_sample.mc_zabuton.wisth = 100
                    }
                }

            }

            onStart();

            // create radio button groups
            grpAction = new RadioButtonGroup("grpAction"); //新規ラジオボタングループ作成
            grpFormat = new RadioButtonGroup("grpFormat"); //新規ラジオボタングループ作成

            // initialize radio buttons
            optJPG.group = grpFormat; //ラジオボタンoptJPGのラジオボタングループはgrpFormatインスタンス
            optJPG.value = Snapshot.JPG; //ラジオボタンoptJPGの値はSnapshotクラスの定数JPG
            optPNG.group = grpFormat; //ラジオボタンoptPNGのラジオボタングループはgrpFormatインスタンス
            optPNG.value = Snapshot.PNG; //ラジオボタンoptPNGの値はSnapshotクラスの定数PNG
            grpFormat.selection = optJPG; //デフォルトではgrpFormatインスタンスはoptJPGを選択

            optGIF.group = grpFormat;
            optGIF.value = Snapshot.GIF;

            optDisplay.group = grpAction; //ラジオボタンoptDisplayのラジオボタングループはgrpActionインスタンス
            optDisplay.value = Snapshot.DISPLAY; //ラジオボタンoptDisplayの値はSnapshotクラスの定数DISPLAY
            optPrompt.group = grpAction; //ラジオボタンoptDisplayのラジオボタングループはgrpActionインスタンス
            optPrompt.value = Snapshot.PROMPT; //ラジオボタンoptDisplayの値はSnapshotクラスの定数PROMPT
            optLoad.group = grpAction; //ラジオボタンoptDisplayのラジオボタングループはgrpActionインスタンス
            optLoad.value = Snapshot.LOAD; //ラジオボタンoptDisplayの値はSnapshotクラスの定数LOAD
            grpAction.selection = optLoad; //デフォルトではgrpActionインスタンスはoptLoadを選択

            // set the required Snapshot URL
            Snapshot.gateway = "snapshot.php"; //Snapshotクラスのgateway（文字型）にPHPのアドレスを代入（この場合同階層）

            btnCapture.addEventListener(MouseEvent.CLICK, onCapture); //ステージ上のボタンbtnCaptureにリスナー登録


            mc_sample.tf01.autoSize = TextFieldAutoSize.LEFT;

            //stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

            btnUp.addEventListener(MouseEvent.CLICK, onBtnUp); //
            btnDown.addEventListener(MouseEvent.CLICK, onBtnDown); //
            btnRight.addEventListener(MouseEvent.CLICK, onBtnRight); //
            btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft); //

            btnPlus.addEventListener(MouseEvent.CLICK, onBtnPlus);
            btnMinus.addEventListener(MouseEvent.CLICK, onBtnMinus);

        }

        private function onCapture(evt:MouseEvent):void //btnCaptureボタン押下時処理ｓ
        {
            // capture as JPG and display prompt user to save/download
            //Snapshotクラスのcapture関数（ターゲットのDisplayObject、{画像フォーマット、保存フォーマット、ローダー？｝を指定して）実行
            Snapshot.capture(mc_sample, {format: grpFormat.selectedData,
                    action: grpAction.selectedData,
                    loader: loader});
        }

        public function onBtnUp(e:MouseEvent):void {
            mc_sample.tf01.y--;
        }

        public function onBtnDown(e:MouseEvent):void {
            mc_sample.tf01.y++;
        }

        public function onBtnRight(e:MouseEvent):void {
            mc_sample.tf01.x++;
        }

        public function onBtnLeft(e:MouseEvent):void {
            mc_sample.tf01.x--;
        }

        public function onBtnPlus(e:MouseEvent):void {
            myTextFormatOld = mc_sample.tf01.getTextFormat();
            myTextFormatOld.size = myTextFormatOld.size + 1;
            trace("myTextFormatOld.size : " + myTextFormatOld.size);
            mc_sample.tf01.setTextFormat(myTextFormatOld);
        }

        public function onBtnMinus(e:MouseEvent):void {
            trace("myTextFormatOld.size : " + myTextFormatOld.size);
            myTextFormatOld = mc_sample.tf01.getTextFormat();
            var a:Number = Number(myTextFormatOld.size);
            trace("a : " + a);
            var b:Number = a - 1;
            if (b < 9) {
                b = 9
            }
            trace("b : " + b);
            myTextFormatOld.size = Object(b);
            mc_sample.tf01.setTextFormat(myTextFormatOld)
        }

        /*
           public function onKeyDown(event:KeyboardEvent):void {
           //mc_sample.tf01.y ++;
           if (event.keyCode == 38) {
           mc_sample.tf01.y --;
           }else if (event.keyCode == 40) {
           mc_sample.tf01.y ++;
           }else if (event.keyCode == 37){
           mc_sample.tf01.x --;
           }else if (event.keyCode == 39) {
           mc_sample.tf01.x ++;
           }
         */

        /*
           if (event.keyCode == 187 || event.keyCode == 107) {
           //mc_sample.tf01.getTextFormat(myTextFormatOld);

           //myTextFormat.size =myTextFormatOld.size + 1 ;
           //mc_sample.tf01.setTextFormat(myTextFormat);
           myTextFormatOld = mc_sample.tf01.getTextFormat();
           myTextFormatOld.size = myTextFormatOld.size +1;
           trace("myTextFormatOld.size : " + myTextFormatOld.size);
           mc_sample.tf01.setTextFormat(myTextFormatOld);

           }else if (event.keyCode == 189 || event.keyCode == 109) {
           //mc_sample.tf01.getTextFormat(myTextFormatOld);

           //var a:Number = myTextFormatOld.size - 1
           trace("myTextFormatOld.size : " + myTextFormatOld.size);
           //myTextFormat.size = a ;
           //mc_sample.tf01.setTextFormat(myTextFormat);
           myTextFormatOld = mc_sample.tf01.getTextFormat();
           var a:Number = Number(myTextFormatOld.size);
           trace("a : " + a);
           var b:Number = a - 1;
           if (b < 9) { b=9}
           trace("b : " + b);
           myTextFormatOld.size = Object(b);
           mc_sample.tf01.setTextFormat(myTextFormatOld)
           }
         */

        //}	



        public function changeHandler(event:ColorPickerEvent):void {
            trace("color changed:", event.color, "(#" + event.target.hexValue + ")"); //hexValueはString

            //myTextFormatOld.color = event.oolor;
            //myTextFormatOld.color = event.target.hexValue;
            //var a:uint = event.target.hexValue(16);
            //trace("a : " + a);

            trace("event.color, : " + event.color); //event.color, : 13434624（10進）
            trace(typeof event.color); //number(0～16777215)

            var c:uint = event.color;
            var e:String = c.toString(16); //16進数に変換
            trace("e : " + e); //e : ffffff

            //myTextFormatOld.color = 0xff0000;//ok赤になる」
            myTextFormatOld.color = "0x" + e; //カラー適用
            mc_sample.tf01.setTextFormat(myTextFormatOld); //フォーマット適用	
        }

    }







}
