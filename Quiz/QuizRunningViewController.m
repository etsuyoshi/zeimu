#import "QuizRunningViewController.h"
#import "Quiz.h"
#import "QuizItem.h"
#import "DataStore.h"

#import <AudioToolbox/AudioToolbox.h>

// クイズの出題数
static NSInteger kQuizCount = 3;

// 次のクイズが表示されるまでの待ち時間（秒単位）
static const NSTimeInterval kNextQuizInterval = 1.5;

// クラス内から使用するメソッドの宣言
@interface QuizRunningViewController ()
- (void)initSound;
@end

@implementation QuizRunningViewController

// 正解判定画像
UIImageView *maruImageView_ = nil;
UIImageView *batuImageView_ = nil;

//章番号
NSString* sectorName = nil;

//問題番号
NSString* questionNo = nil;



//誤答回数---->>>グローバルに宣言して渡せば良いかも？
long sumOfWrong = 0;

// プロパティに対応するインスタンス変数とアクセッサメソッドの生成
@synthesize quiz = _quiz;
@synthesize questionTextView = _questionTextView;
@synthesize answerButton1 = _answerButton1;
@synthesize answerButton2 = _answerButton2;
@synthesize answerButton3 = _answerButton3;
@synthesize answerButton4 = _answerButton4;
@synthesize answerButton5 = _answerButton5;
@synthesize rightSound = _rightSound;
@synthesize notRightSound = _notRightSound;





// 初期化処理
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
        // インスタンス変数の初期化
        _quiz = nil;
        _rightSound = 0;
        _notRightSound = 0;
        
        
        // 効果音の読み込み
        [self initSound];
    }
    return self;
}

// 初期化処理（Storyboardファイルから作成されたインスタンス）
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // インスタンス変数の初期化
        _quiz = nil;
        _rightSound = 0;
        _notRightSound = 0;
        
        // 効果音の読み込み
        [self initSound];
    }
    return self;
}

// 効果音を読み込む
- (void)initSound
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *url;
    
    // 正解時の効果音
    url = [bundle URLForResource:@"Right"
                   withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,
                                     &_rightSound);
    
    // 不正解時の効果音
    url = [bundle URLForResource:@"NotRight"
                   withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,
                                     &_notRightSound);
}

// 解放処理
- (void)dealloc
{
    // 「AudioServicesCreateSystemSoundID」関数で読み込んだサウンドは
    // 「AudioServicesDisposeSystemSoundID」関数で解放しなければいけない
    AudioServicesDisposeSystemSoundID(self.rightSound);
    AudioServicesDisposeSystemSoundID(self.notRightSound);
}

// ビューがロードされたときの処理
- (void)viewDidLoad
{
    
    //問題数の変更
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    kQuizCount = [d stringForKey:[NSString stringWithFormat:@"numOfQuest"]].integerValue;
    if(kQuizCount < 3){
        kQuizCount = 3;
    }
    NSLog(@"設問数は%dです。", kQuizCount);
    
    [super viewDidLoad];
    
//    以下参考：http://snippets.feb19.jp/?p=73
    //正解判定画像の初期化
//    UIImage *image = [UIImage imageNamed:@"maru"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIImage *maruImage = [UIImage imageNamed:@"maru"];
    maruImageView_ = [[UIImageView alloc] initWithImage:maruImage];
    maruImageView_.frame = CGRectMake(40,100,maruImage.size.width/1.7,maruImage.size.height/1.7);
    [self.view addSubview:maruImageView_];
    maruImageView_.hidden = YES;
    
    //不正解判定画像の初期化
    batuImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"batu"]];
    UIImage *batuImage = [UIImage imageNamed:@"batu"];
    batuImageView_.frame = CGRectMake(10,100,batuImage.size.width,batuImage.size.height);
    [self.view addSubview:batuImageView_];
    batuImageView_.hidden = YES;
    
    //誤答回数
    sumOfWrong = 0;
	
    // 最初の問題を表示する
    [self showNextQuiz];
}

// デバイスの回転対応
- (NSUInteger)supportedInterfaceOrientations
{
    // 縦方向のみ対応する
    return UIInterfaceOrientationMaskPortrait;
}

// 次の問題を表示する
- (void)showNextQuiz
{
    //正解不正解判定画像を隠す
    maruImageView_.hidden = YES;
    batuImageView_.hidden = YES;

    
    // クイズ情報を取得する
    QuizItem *item = nil;
    item = [self.quiz nextQuiz];
    
    //章番号を設定する
    sectorName = item.sectorName;
    
    //問題番号を設定する
    questionNo = item.questionNo;
    
    // 問題文を設定する
    self.questionTextView.text = item.question;
    
    // 選択肢を取得する
    NSArray *choices = item.randomChoicesArray;
    
    // ボタンを配列にする
    NSArray *buttons = [NSArray arrayWithObjects:
                        self.answerButton1,
                        self.answerButton2,
                        self.answerButton3,
                        self.answerButton4,
                        self.answerButton5,
                        nil];
    
    // ボタンのラベルに選択肢を設定する
    NSUInteger i;
    
    for (i = 0; i < [choices count] && i < [buttons count]; i++)
    {
        NSString *str = [choices objectAtIndex:i];
        UIButton *btn = [buttons objectAtIndex:i];
        
        [[btn titleLabel] setNumberOfLines:0];
        //[NSString stringWithFormat:@"(%d)%@",i+1,str]
        [btn setTitle:str
             forState:UIControlStateNormal];

        
        NSLog(@"%d", i);
    }
    

}

// 選択肢のボタンがタップされたときの処理
- (IBAction)answer:(id)sender
{
    // 正解か不正解かを見せる間、タップできないように、ボタンを無効表示に変更する
    self.answerButton1.enabled = NO;
    self.answerButton2.enabled = NO;
    self.answerButton3.enabled = NO;
    self.answerButton4.enabled = NO;
    self.answerButton5.enabled = NO;
    
    // タップされたボタンのラベルを取得する
    NSString *str = [[sender titleLabel] text];
    
    // 出題された問題の情報を取得する
    QuizItem *item = [self.quiz.usedQuizItems lastObject];
    
    //個々の問題の成績を格納
    NSUserDefaults* eachQuestionDefaults = [NSUserDefaults standardUserDefaults];
    //    NSLog(@"回答した問題は%@章の%@番",item.sectorName, item.questionNo );
    //(正誤に関わらず)回答した回数
    NSInteger answering = [eachQuestionDefaults stringForKey:[NSString stringWithFormat:@"Answer%@%@", item.sectorName, item.questionNo]].integerValue;
    //誤って回答した回数
    NSInteger UncorrectAns = [eachQuestionDefaults stringForKey:[NSString stringWithFormat:@"UncorrectAns%@%@", item.sectorName, item.questionNo]].integerValue;
    
//    NSLog(@"更新前回答数(%@) = %d",[NSString stringWithFormat:@"Answer%@%@", item.sectorName, item.questionNo], answering);
//    NSLog(@"更新前回答数(%@) = %d",[NSString stringWithFormat:@"UncorrectAns%@%@", item.sectorName, item.questionNo], UncorrectAns);
//    NSLog(@"%d", answering);
//    NSLog(@"%d", UncorrectAns);

    // 正解か判定する
    if ([item checkIsRightAnswer:str])
    {
        // 正解なので、「○」を先頭に追加する
        [sender setTitle:[NSString stringWithFormat:@"○ %@", str]
                forState:UIControlStateNormal];
        
        // 効果音を再生する
        AudioServicesPlaySystemSound(self.rightSound);
        
        
        // 正解画像を表示
        maruImageView_.hidden = NO;
        batuImageView_.hidden = YES;

    }
    else
    {
        // 不正解の場合のみsumOfWrongを増やす
        sumOfWrong++;
        
        //成績格納用誤答回数
        UncorrectAns ++;
        
        // 不正解なので、「×」を先頭に追加する
        [sender setTitle:[NSString stringWithFormat:@"× %@", str]
                forState:UIControlStateNormal];
        
        // 効果音を再生する
        AudioServicesPlaySystemSound(self.notRightSound);
        
        // さらにバイブレーションを使って本体を揺らす
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        // 不正解画像を表示
        maruImageView_.hidden = YES;
        batuImageView_.hidden = NO;
    }
    
    
    answering++;
//    NSLog(@"%d", answering);
//    NSLog(@"%d", UncorrectAns);
//    NSLog(@"%@", [NSString stringWithFormat:@"%d", answering]);
//    NSLog(@"%@", [NSString stringWithFormat:@"%d", UncorrectAns]);
    
    [eachQuestionDefaults setObject:[NSString stringWithFormat:@"%d", answering]
                             forKey:[NSString stringWithFormat:@"Answer%@%@", item.sectorName, item.questionNo]];
    [eachQuestionDefaults setObject:[NSString stringWithFormat:@"%d", UncorrectAns]
                             forKey:[NSString stringWithFormat:@"UncorrectAns%@%@", item.sectorName, item.questionNo]];
    
//    確認用
//    NSUserDefaults* eachQuestionDefaultsAfter = [NSUserDefaults standardUserDefaults];
//    NSInteger answeringAfter = [eachQuestionDefaultsAfter stringForKey:[NSString stringWithFormat:@"Answer%@%@", item.sectorName, item.questionNo]].integerValue;
//    NSInteger UncorrectAnsAfter = [eachQuestionDefaultsAfter stringForKey:[NSString stringWithFormat:@"UncorrectAns%@%@", item.sectorName, item.questionNo]].integerValue;
//    
//    NSLog(@"更新前回答数(%@) = %d",[NSString stringWithFormat:@"Answer%@%@", item.sectorName, item.questionNo], answeringAfter);
//    NSLog(@"更新前回答数(%@) = %d",[NSString stringWithFormat:@"UncorrectAns%@%@", item.sectorName, item.questionNo], UncorrectAnsAfter);

    // 次の問題を少し間を空けてから呼び出す
    [self performSelector:@selector(nextQuiz:)
               withObject:nil
               afterDelay:kNextQuizInterval];
}

// 遅延して呼び出されるメソッド
- (void)nextQuiz:(id)sender
{
    if (self.quiz.isKokuhukuMode){
        //弱点克服モードの場合、一問解答した後は画面を戻す
        [self dismissModalViewControllerAnimated:YES];
        
    }else if ([self.quiz.usedQuizItems count] >= kQuizCount){
        // 出題済み数を数えて、終了数になっている場合には、開始画面に戻る
        
        // 開始画面に戻る
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        NSLog(@"成績を格納");
        
        //注意：http://gintamansan.blog.fc2.com/blog-entry-10.html
        
        //章毎に配列を作成【年月日、回答数、正解数、誤答数カラム】
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];//出力用にも作成しているが、入力用も必要？
        
        //データを削除する場合
//        [defaults removeObjectForKey:sectorName];  // デフォルトデータを削除する
        //削除した場合に中身を確認する
//        NSArray* test_sector = [defaults arrayForKey:sectorName];
//        for(id object in test_sector){
//            if ( [object isKindOfClass:[NSArray class]] ) {
//                NSMutableArray* testAr = object;
//                NSLog(@"現在格納されているデータ数は%d", [testAr count]);
//            }
//        }
        
        
        // 新規に保存する配列の作成
        NSMutableArray* yyyymmddPreserved = [[NSMutableArray alloc] init];//[NSMutableArray array];
        NSMutableArray* kaitouPreserved = [[NSMutableArray alloc] init];//[NSMutableArray array];
        NSMutableArray* seikaiPreserved = [[NSMutableArray alloc] init];//[NSMutableArray array];
        NSMutableArray* gotouPreserved = [[NSMutableArray alloc] init];//[NSMutableArray array];
        
        
        //既に保存されている配列を取得
        NSUserDefaults* defaults_output = [NSUserDefaults standardUserDefaults];
        NSArray* sector = [defaults_output arrayForKey:sectorName];
//        NSMutableArray* sector = [NSMutableArray arrayWithArray:[defaults objectForKey:sectorName]];
        NSLog(@"読み込み章は%@", sectorName);
        
        
        //年月日、回答数、正解数、誤答数配列を過去の値を格納(注意：mutableCopyメソッドを使用しないと連続してaddObjectできなくなる！！)
        //mutableCopy参考：http://yoshiminu.blog.fc2.com/blog-entry-6.html
        int forNum = 0;
        for(id object in sector){//一つの章配列の中にymd,kaitou,seikai,gotou配列が格納されている。
//            NSLog(@"%@", [object isKindOfClass:[NSMutableArray class]] );
            if ( [object isKindOfClass:[NSMutableArray class]] ) {
                switch(forNum){
                    case 0:yyyymmddPreserved = [(NSMutableArray*)object mutableCopy];
                        break;
                    case 1:kaitouPreserved = [(NSMutableArray*)object mutableCopy];
                        break;
                    case 2:seikaiPreserved = [(NSMutableArray*)object mutableCopy];
                        break;
                    case 3:gotouPreserved = [(NSMutableArray*)object mutableCopy];
                        break;
                }
            }
            forNum ++;
        }
        
        //書き出し用のsector配列sectorForOutputを作成
        NSMutableArray* sectorForOutput = [NSMutableArray array];
        
        // 今日の日付を取得
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];// フォーマット指定
        NSString* today = [formatter stringFromDate:[NSDate date]];
        
        NSLog(@"本日の年月日%@格納", today);
        
        NSLog(@"格納前：%d", [yyyymmddPreserved count]);
        
        //上で代入するときにmutableCopyにしないとここでエラーが生じる
        
        
        [yyyymmddPreserved addObject:today];//年月日を格納
        [kaitouPreserved addObject:[[NSString alloc] initWithFormat:@"%d",kQuizCount]];
        [seikaiPreserved addObject:[[NSString alloc] initWithFormat:@"%d",(kQuizCount - (int)sumOfWrong)]];
        [gotouPreserved addObject:[[NSString alloc] initWithFormat:@"%d", (int)sumOfWrong]];
        
        //格納数が30個以上の場合は超過した個数分を最初の方から取り除く
        if([yyyymmddPreserved count] > 30){
            [yyyymmddPreserved removeObjectAtIndex:0];
            [kaitouPreserved removeObjectAtIndex:0];
            [seikaiPreserved removeObjectAtIndex:0];
            [gotouPreserved removeObjectAtIndex:0];
        }
        
        NSLog(@"格納後年月日数：%d", [yyyymmddPreserved count]);
        NSLog(@"格納後解答回数：%d", [kaitouPreserved count]);
        NSLog(@"格納後正解数：%d", [seikaiPreserved count]);
        NSLog(@"格納後誤答数：%d", [gotouPreserved count]);
        
        //作成した配列を出力用配列に格納する
        [sectorForOutput addObject:yyyymmddPreserved];
        [sectorForOutput addObject:kaitouPreserved];
        [sectorForOutput addObject:seikaiPreserved];
        [sectorForOutput addObject:gotouPreserved];
        
        //出力用配列を記憶領域に保存する
        [defaults setObject:sectorForOutput forKey:sectorName];
        
        NSLog(@"成績格納完了");
        //_/_/_/_/_/_/格納後のデータを確認_/_/_/_/_/_/_/_/_/
        NSUserDefaults* defaults_test = [NSUserDefaults standardUserDefaults];
        NSArray* sector_test = [defaults_test arrayForKey:sectorName];
        forNum = 0;
        for(id object in sector_test){
            if ( [object isKindOfClass:[NSArray class]] ) {
                for ( id object2 in object ) {
                    switch(forNum){
                        case 0:
                            NSLog(@"年月日 = %@", object2);
                            break;
                        case 1:
                            NSLog(@"回答数 = %@", object2);
                            break;
                        case 2:
                            NSLog(@"正解数 = %@", object2);
                            break;
                        case 3:
                            NSLog(@"誤答数 = %@", object2);
                            break;
                    }
                    
//                    NSLog(@"object2 : %d = %@", forNum, object2 );
                }
            }
            forNum++;
        }
                            
        
        //_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
    }
    else
    {
        // ボタンを有効にする
        self.answerButton1.enabled = YES;
        self.answerButton2.enabled = YES;
        self.answerButton3.enabled = YES;
        self.answerButton4.enabled = YES;
        self.answerButton5.enabled = YES;
        
        // 次の問題を表示する
        [self showNextQuiz];
    }
}

- (IBAction)pushExplain:(id)sender {
    [self performSegueWithIdentifier:@"explainSegue" sender:self];
}

- (IBAction)pushReturn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // 出題された問題の解説情報を取得する→解説文を取得してviewCon.explanationに渡す
    QuizItem *item = [self.quiz.usedQuizItems lastObject];

    if ([segue.identifier isEqualToString:@"explainSegue"]) {
        ExplainViewController *viewCon = segue.destinationViewController;
        viewCon.explanation = item.explanation;//渡すべき値(解説文)
    }
}
@end