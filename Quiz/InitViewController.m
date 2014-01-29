//
//  InitViewController.m
//  Quiz
//
//  Created by 遠藤 豪 on 13/06/27.
//
//

#import "InitViewController.h"
#import "QuizRunningViewController.h"
#import "Quiz.h"

@interface InitViewController ()

@end

@implementation InitViewController

// プロパティに対応するインスタンス変数とアクセッサメソッドの生成
@synthesize quiz = _quiz;

// ロード完了時の処理
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //以下の実行はボタン押下時でも実施する(将来的には不要？)
    
    /*
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
    self.quiz = quiz;
     */
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// セグエを使ってビューコントローラを開くときに呼ばれる
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
    // クイズ出題画面用のビューコントローラを取得するための入れ物
    QuizRunningViewController *vc;
    
    
    
    // クイズデータを読み込む
    Quiz *quiz = [[Quiz alloc] init];
    
    // クイズデータのファイルパスを取得する
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path;
    
    
    
    // 識別子をチェックして、クイズ画面を表示するときか確認する
    if ([segue.identifier isEqualToString:@"segueSelect1"]){
        
        path = [bundle pathForResource:@"zeimu1"
                                ofType:@"csv"];
//        path = [bundle pathForResource:@"test0000"
//                                ofType:@"csv"];
        
        // ファイルから読み込んで、ローカル変数quizデータに格納する
        [quiz readFromCSV:path];
        
        
        // 2回目以降の場合があるので、出題済みの情報をクリアする
//        [self.quiz clear];
        
        // クイズ出題画面用のビューコントローラを取得する
        vc = segue.destinationViewController;
        
        // クイズ情報を設定する
        //        [vc setQuiz:self.quiz];
        [vc setQuiz:quiz];
    }else if([segue.identifier isEqualToString:@"segueSelect2"]){
        
        path = [bundle pathForResource:@"zeimu2"
                                ofType:@"csv"];
        
        // ファイルから読み込んで、ローカル変数quizデータに格納する
        [quiz readFromCSV:path];
        
        
        // 2回目以降の場合があるので、出題済みの情報をクリアする
//        [self.quiz clear];
        
        // クイズ出題画面用のビューコントローラを取得する
        vc = segue.destinationViewController;
        
        // クイズ情報を設定する
//        [vc setQuiz:self.quiz];
        [vc setQuiz:quiz];
    }else if([segue.identifier isEqualToString:@"segueSelect3"]){
        path = [bundle pathForResource:@"zeimu3"
                                ofType:@"csv"];
        [quiz readFromCSV:path];
        vc = segue.destinationViewController;
        [vc setQuiz:quiz];
    }else if([segue.identifier isEqualToString:@"segueSelect4"]){
        path = [bundle pathForResource:@"zeimu4"
                                ofType:@"csv"];
        [quiz readFromCSV:path];
        vc = segue.destinationViewController;
        [vc setQuiz:quiz];
    }else if([segue.identifier isEqualToString:@"segueSelect5"]){
        path = [bundle pathForResource:@"zeimu5"
                                ofType:@"csv"];
        [quiz readFromCSV:path];
        vc = segue.destinationViewController;
        [vc setQuiz:quiz];
    }else if([segue.identifier isEqualToString:@"segueSelect6"]){
        path = [bundle pathForResource:@"zeimu6"
                                ofType:@"csv"];
        [quiz readFromCSV:path];
        vc = segue.destinationViewController;
        [vc setQuiz:quiz];
    }
}

- (IBAction)pushRtn:(id)sender {
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
