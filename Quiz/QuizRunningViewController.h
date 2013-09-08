#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ExplainViewController.h"

// 使用するクラス名を宣言する
@class Quiz;

@interface QuizRunningViewController : UIViewController

// クイズデータ
@property (strong, nonatomic) Quiz *quiz;

// 問題文を表示するテキストビュー
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;

// 選択肢1
@property (weak, nonatomic) IBOutlet UIButton *answerButton1;

// 選択肢2
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;

// 選択肢3
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;

// 選択肢4
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;

// 選択肢5
@property (weak, nonatomic) IBOutlet UIButton *answerButton5;


// 正解時の効果音
@property (assign, nonatomic) SystemSoundID rightSound;

// 不正解時の効果音
@property (assign, nonatomic) SystemSoundID notRightSound;


// 選択肢のボタンがタップされたときの処理
- (IBAction)answer:(id)sender;

// 次の問題を表示する
- (void)showNextQuiz;

//説明文を表示する
 - (IBAction)pushExplain:(id)sender;

//解答を終了する
- (IBAction)pushReturn:(id)sender;



@end
