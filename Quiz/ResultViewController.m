//
//  ResultViewController.m
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/09.
//
//

#import "ResultViewController.h"
#import "TimeSeriesViewController.h"


@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize pieChartData;

@synthesize bt1;
@synthesize bt2;
@synthesize bt3;
@synthesize bt4;
@synthesize bt5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//スワイプで戻る
-(IBAction)swipeHandler:(UISwipeGestureRecognizer *)sender{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    
//    [self.view addSubview:bt1];
    
    //スワイプジェスチャーを配置
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;//スワイプする方向は下方向(デフォルトは右)
    [self.view addGestureRecognizer:gestureRecognizer];
    
    //　ホスティングビューを生成します。引数：x座標、y座標、？、？
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc]
                                        initWithFrame:CGRectMake(0, -20, 320, 320)];
    
    // グラフを生成します。
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = graph;
    
    // 今回は円グラフなので、グラフの軸は使用しません。
    graph.axisSet = nil;
    
    // 円グラフのインスタンスを生成します。
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    
    // 円グラフの半径を設定します。
    pieChart.pieRadius = 80.0;
    
    // データソースを設定します。
    pieChart.dataSource = self;
    
    // デリゲートを設定します。
    pieChart.delegate = self;
    
    // グラフに円グラフを追加します。
    [graph addPlot:pieChart];
    
    
    //累積の誤答率を計算・・・章毎に用意する(NSArrayでは個別要素を変えることができない)
    NSMutableArray* ruisekiGotouritu =[NSMutableArray array];
    NSMutableArray* ruisekiGotoukaisu = [NSMutableArray array];
//    NSArray* initArray = [NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", nil];
    
    NSArray* sectorArray = nil;//各章の成績が格納されている二次元配列
    NSString* sectorName = nil;//各章の名前
    NSArray* yyyymmdd = nil;
    NSArray* kaitou = nil;
    NSArray* seikai = nil;//※使用しない
    NSArray* gotou = nil;
    int forNum = 0;
    long numG = 0;//累積の誤答回数
    long numK = 0;//累積の回答回数
    
    NSUserDefaults* defaults_output = [NSUserDefaults standardUserDefaults];
    
    for(int sectorNo = 1;sectorNo <= 6;sectorNo++){
        yyyymmdd = nil;
        kaitou = nil;
        gotou = nil;
//    for(int sectorNo = 1;sectorNo <= [ruisekiGotouritu count];sectorNo++){
        //名称の設定
        sectorName = [NSString stringWithFormat:@"SECT%@", [NSString stringWithFormat:@"%03d", sectorNo]];
        NSLog(@"成績読み出し中・・・%@", [NSString stringWithFormat:@"%03d", sectorNo]);//format:00X
        //【00i】章の成績(二次元配列)を取り出す
        sectorArray = [defaults_output arrayForKey:sectorName];
        
        //各配列を読み出し
        forNum = 0;
        for ( NSString* object in sectorArray ) {
            if ( [object isKindOfClass:[NSArray class]] ) {
                switch(forNum){
                    case 0:yyyymmdd = (NSArray*)object;
                        break;
                    case 1:kaitou = (NSArray*)object;
                        break;
                    case 2:seikai = (NSArray*)object;
                        break;
                    case 3:gotou = (NSArray*)object;
                        break;
                }
            }
            forNum ++;
        }
        
        
        numG = 0;//累積誤答回数の初期化
        numK = 0;//累積回答回数の初期化
        for(forNum = 0;forNum < [yyyymmdd count];forNum ++){//回答した回数だけ見て誤答回数をカウントする

            NSLog(@"%@ : yyyymmdd:%d = %@",sectorName, forNum, [yyyymmdd objectAtIndex:forNum]);
            if([yyyymmdd count] == 0){
                continue;
            }else{
                NSLog(@"%@", [gotou objectAtIndex:forNum]);
                numG += [[gotou objectAtIndex:forNum] longLongValue];
                numK += [[kaitou objectAtIndex:forNum] longLongValue];
//                NSLog(@"%d", numG);
            }
        }
//        NSLog(@"ruisekiGotouritu = %@",[NSString stringWithFormat:@"%f", (double)numG/(double)numK]);
//        [ruisekiGotouritu objectAtIndex:for]
//        [ruisekiGotouritu replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f", (double)numG/(double)numK]];
        double rg = (double)numG/(double)numK;
        NSLog(@"ruisekiGotouritu = %@", [NSString stringWithFormat:@"%.3f", rg]);//小数点以下３桁
//        [ruisekiGotouritu replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%.2f", rg]];
//        [ruisekiGotouritu replaceObjectAtIndex:1 withObject:@"a"];
        [ruisekiGotouritu addObject:[NSString stringWithFormat:@"%.3f", rg]];
        [ruisekiGotoukaisu addObject:[NSString stringWithFormat:@"%d", (int)numG]];
        NSLog(@"累積誤答回数%d", (int)numG);
//        NSLog(@"%d章累積誤答回数%d", sectorNo, [[ruisekiGotoukaisu objectAtIndex:sectorNo-1] intValue]);

        
    }
    
    // NSArrayの読み込み試験

    NSLog(@"データ読み込み完了");
    
    //確認用
    //    for(forNum = 0;forNum < [YYYYMMDD count];forNum++){
    //        NSLog(@"YYYYMMDD:%d = %@",forNum, [YYYYMMDD objectAtIndex:forNum]);
    //    }

    
    
    // グラフに表示するデータを生成します。
//    誤回答率
//    self.pieChartData = [NSMutableArray arrayWithObjects:
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:0] doubleValue]],
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:1] doubleValue]],
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:2] doubleValue]],
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:3] doubleValue]],
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:4] doubleValue]],
//                         [NSNumber numberWithDouble:[[ruisekiGotouritu objectAtIndex:5] doubleValue]],
//                         nil];
    if (
        [[ruisekiGotoukaisu objectAtIndex:0] intValue] +
        [[ruisekiGotoukaisu objectAtIndex:1] intValue] +
        [[ruisekiGotoukaisu objectAtIndex:2] intValue] +
        [[ruisekiGotoukaisu objectAtIndex:3] intValue] +
        [[ruisekiGotoukaisu objectAtIndex:4] intValue] +
        [[ruisekiGotoukaisu objectAtIndex:5] intValue] != 0){
        NSLog(@"誤答履歴あり");
        for(int i = 0; i< 6;i++){
//            NSLog(@"%d=%d", i, (int)[NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:i] intValue]]);
            NSLog(@"%d=%d", i, [[ruisekiGotoukaisu objectAtIndex:i] intValue]);
        }
        self.pieChartData = [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:0] intValue]],
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:1] intValue]],
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:2] intValue]],
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:3] intValue]],
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:4] intValue]],
                             [NSNumber numberWithInt:[[ruisekiGotoukaisu objectAtIndex:5] intValue]],
                             nil];
        
        // 画面にホスティングビューを追加します。
        [self.view addSubview:hostingView];

    }else{
        NSLog(@"誤答履歴なし");
        self.pieChartData = [NSMutableArray arrayWithObjects:
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:1],
                             nil];
        
        
        //ダイアログで解答問題数を修正するか確認する
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"解答履歴がありません。"
                                                         message:@"No Record..."
                                                        delegate:self
                                               cancelButtonTitle:@"終了(exit)"
                                               otherButtonTitles:nil,
                               nil];
        alert1.tag = 1;//ダイアログの識別子
        [alert1 show];
        

    }

    
    
    
}


//http://d.hatena.ne.jp/corrupt/20110419/1303204067
// pickerで値が変更された場合に呼び出されるダイアログ及び成績表削除ボタンが押された時のダイアログ
- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUserDefaults* defaults = nil;
    
    // 押されたボタンの確認
    switch (buttonIndex) {
        case 0:
            // 終了が押された場合の処理
            [self dismissModalViewControllerAnimated:YES];
            break;
        case 1:
            // このボタンはない。
            break;
            
        default:
            break;
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// グラフに使用するデータの数を返すように実装します。
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieChartData count];
}

// グラフに使用するデータの値を返すように実装します。
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return [self.pieChartData objectAtIndex:index];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TimeSeriesViewController *ts = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"resultSegue1"]) {
        ts.sectorName = @"SECT001";
    }else if ([segue.identifier isEqualToString:@"resultSegue2"]) {
        ts.sectorName = @"SECT002";
    }else if ([segue.identifier isEqualToString:@"resultSegue3"]) {
        ts.sectorName = @"SECT003";
    }else if ([segue.identifier isEqualToString:@"resultSegue4"]) {
        ts.sectorName = @"SECT004";
    }else if ([segue.identifier isEqualToString:@"resultSegue5"]) {
        ts.sectorName = @"SECT005";
    }else if ([segue.identifier isEqualToString:@"resultSegue6"]) {
        ts.sectorName = @"SECT006";
    }
}
- (IBAction)pushRtn:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


@end
