import caurina.transitions.*;
import caurina.transitions.properties.*;

ColorShortcuts.init(); //Tweenerブライトネス変化用初期化（必須）;
//↑無いとerr## [Tweener] Error: The property '_brightness' doesn't seem to be a normal object property of [object mc_plate1] or a registered special property.
DisplayShortcuts.init(); //Tweener共用スケール用初期化（必須）

Tweener.addTween(mc_menu_all, {y: 4, time: 10, alpha: 1});
