//
//  ExplainViewController.m
//  Quiz
//
//  Created by 遠藤 豪 on 13/06/26.
//
//

#import "ExplainViewController.h"

@interface ExplainViewController ()

@end

@implementation ExplainViewController

//説明文
@synthesize explanation = _explanation;

//プロパティに対応するインスタンス変数とアクセッサメソッド
@synthesize explainTextView = _explainTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //改行を読み取って返すメソッド
    
    self.explainTextView.text = [self returnParagraph:_explanation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushBtn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)returnParagraph:(NSString*) arg{
    NSString* initStr = arg;
    NSString* returnStr = @"　";
    
    NSArray *eachInLine = [initStr componentsSeparatedByString:@"#"];
    if (!eachInLine ||[eachInLine count] == 0)
          return NO;
    
    for(NSString *term in eachInLine){
        returnStr = [returnStr stringByAppendingString:term];
        returnStr = [returnStr stringByAppendingString:@"\n　"];
    }
    
//    //なぜか改行が認識されない？
    return returnStr;
}
@end
