//
//  InitViewController.h
//  Quiz
//
//  Created by 遠藤 豪 on 13/06/27.
//
//

#import <UIKit/UIKit.h>

// クラスが存在することを宣言する
@class Quiz;

@interface InitViewController : UIViewController

// クイズ情報
@property (strong, nonatomic) Quiz *quiz;

//戻るボタン
- (IBAction)pushRtn:(id)sender;

@end
