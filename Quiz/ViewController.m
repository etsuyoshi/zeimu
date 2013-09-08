#import "ViewController.h"
#import "QuizRunningViewController.h"
#import "Quiz.h"
#import <QuartzCore/QuartzCore.h>
#import "TransViewController.h"

// セグエの識別子
static NSString *kQuizSegue = @"quiz";

// クラスの内部専用のメソッドの宣言
@interface ViewController ()

@end

// クラスの実装
@implementation ViewController

// プロパティに対応するインスタンス変数とアクセッサメソッドの生成
@synthesize quiz = _quiz;
@synthesize imv;

// ロード完了時の処理
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //ボタン：00E8A6
    //http://jirox.net/AsButtonGen/
    
    srand(time(nil));//乱数初期化
//    NSLog(@"%d", time(nil));
    
//    //見た目
//    // UIImageViewの初期化
//    CGRect rect = CGRectMake(0, 0, 320, 500);
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:rect];
//
//    // 画像の読み込み
    int r = rand() % 100;
    if(r < 10){
        imv.image = [UIImage imageNamed:@"light.png"];//building
    }else if(r < 20){
        imv.image = [UIImage imageNamed:@"desk.png"];//building
    }else if(r < 30){
        imv.image = [UIImage imageNamed:@"sunset.png"];//building
    }else if(r < 40){
        imv.image = [UIImage imageNamed:@"building.png"];//building
    }else if(r < 50){
        imv.image = [UIImage imageNamed:@"building2.png"];//building
    }else if(r < 60){
        imv.image = [UIImage imageNamed:@"street.png"];//building
    }else if(r < 70){
        imv.image = [UIImage imageNamed:@"aman.png"];//building
    }else if(r < 80){
        imv.image = [UIImage imageNamed:@"bird.png"];//building
    }else if(r < 90){
        imv.image = [UIImage imageNamed:@"wood.png"];//building
    }else{
        
    }
//
//    // UIImageViewのインスタンスをビューに追加
//    [self.view addSubview:imageView];
    
    
    
    //imageviewの角を丸くする(影の濃さとの両立は不可)
//    self.imv.layer.cornerRadius = 10.0;
//    self.imv.clipsToBounds = YES;
    
    //imageviewに影を付ける
//    self.imv.layer.shadowOpacity = 1.0;//影の濃さ
//    self.imv.layer.shadowRadius = 2.0;//ぼかしの程度：０〜15
//    self.imv.layer.shadowOffset = CGSizeMake(4, 4);//影の方向
    
    // クイズデータを読み込む
    Quiz *quiz = [[Quiz alloc] init];
    
    // クイズデータのファイルパスを取得する
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path;
    
//    path = [bundle pathForResource:@"quiz"
//                            ofType:@"txt"];
    path = [bundle pathForResource:@"ios_test1"
                            ofType:@"csv"];

    
    // ファイルから読み込む
//    [quiz readFromFile:path];
    [quiz readFromCSV:path];

    
    // プロパティにセットする
//    self.quiz = quiz;
    
//    [self moveToTransViewCon];
}

// 回転への対応
- (NSUInteger)supportedInterfaceOrientations
{
    // 縦方向のみ対応する
    return UIInterfaceOrientationMaskPortrait;
}


//http://firstiphoneapp.blogspot.jp/2011/12/blog-post.html
-(void) moveToTransViewCon{
    NSLog(@"toTransViewCon");
    
    TransViewController* transViewController =
        [[TransViewController alloc]initWithNibName:@"TransViewController" bundle:nil];
    
    NSLog(@"1%@", transViewController);

//    UIWindow* keyWindow= [[UIApplication sharedApplication] keyWindow];
    
    NSLog(@"2%@", transViewController);
    
//    [keyWindow addSubview: TransViewController.view];
    
    
    NSLog(@"3%@", transViewController);
    
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:transViewController animated:YES completion:nil];
    NSLog(@"%@", transViewController);
//    [self presentModalViewController:transViewController animated:YES];
    
    [self presentViewController:transViewController animated:YES completion:nil];
    

    NSLog(@"toTransViewCon");
}

//ボタンがある場合にsegueを用いる方法
// セグエを使ってビューコントローラを開くときに呼ばれる
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    // 識別子をチェックして、クイズ画面を表示するときか確認する
    if ([segue.identifier isEqualToString:kQuizSegue])
    {
        // 2回目以降の場合があるので、出題済みの情報をクリアする
//        [self.quiz clear];
        
        // クイズ出題画面用のビューコントローラを取得する
        QuizRunningViewController *vc;
        vc = segue.destinationViewController;
        
        // クイズ情報を設定する
//        [vc setQuiz:self.quiz];
    }
}

@end
