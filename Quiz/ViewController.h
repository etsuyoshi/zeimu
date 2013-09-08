#import <UIKit/UIKit.h>

// クラスが存在することを宣言する
@class Quiz;

@interface ViewController : UIViewController{
    IBOutlet UIImageView *imv;
    
}

// クイズ情報
@property (strong, nonatomic) Quiz *quiz;

@property (nonatomic,readwrite,strong) IBOutlet UIImageView* imv;

@end
