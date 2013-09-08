//
//  TimeSeriesViewController.m
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/14.
//
//

#import "TimeSeriesViewController.h"
#import "ArrayStore.h"

@interface TimeSeriesViewController ()

@end

@implementation TimeSeriesViewController

@synthesize sectorName = _sectorName;

NSArray* YYYYMMDD = nil;
NSArray* kaitou = nil;
NSArray* seikai = nil;
NSArray* gotou = nil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//スワイプで戻る(http://labs.techfirm.co.jp/ipad/cho/466)
-(IBAction)swipeHandler:(UISwipeGestureRecognizer *)sender{
    //スワイプしてからすぐに別の章を表示させると前の章のデータがそのまま表示されてしまう(残っているからここで初期化しておく必要あり？)
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //スワイプジェスチャーを配置
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    gestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;//スワイプする方向は下方向(デフォルトは右)
    [self.view addGestureRecognizer:gestureRecognizer];
    
//    _sectorName = @"SECT00X";
    NSLog((NSString*)_sectorName);
    
    NSUserDefaults* defaults_output = [NSUserDefaults standardUserDefaults];
    // NSArrayの読み込み試験
    NSArray* array = [defaults_output arrayForKey:_sectorName];
    int forNum = 0;
    for ( NSString* object in array ) {
        if ( [object isKindOfClass:[NSArray class]] ) {
            switch(forNum){
                case 0:YYYYMMDD = (NSArray*)object;
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
    NSLog(@"データ格納完了");
    
    //確認用
//    for(forNum = 0;forNum < [YYYYMMDD count];forNum++){
//        NSLog(@"YYYYMMDD:%d = %@",forNum, [YYYYMMDD objectAtIndex:forNum]);
//    }
    
    
    
    //以下、ArrayStore「クラス」を作って、内部に成績データを格納しようとしたが、
    //配列を有効にするためには、alloc initを実行しなければならず、実行すると既に格納されていた配列データが消えてしまう。
    
//    //sector1を20130715に回答した結果をArrayStoreに格納
//    ArrayStore *as = [[ArrayStore alloc]initWithArrayStore:@"sect1"];
//    [as store:@"sect1" yyyymmdd:20130715 kaitou:5 seikai:4 gotou:1];
//    
//    //ArrayStoreをシステムファイルとして保存
//    NSData* classData = [NSKeyedArchiver archivedDataWithRootObject:as];
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:classData forKey:@"sect1"];//キーはsect1とする
//    
//    //取り出してみる
//    NSUserDefaults* defaults_output = [NSUserDefaults standardUserDefaults];
//    NSData* nsData_output = [defaults_output dataForKey:@"sect1"];
//    ArrayStore* as_output = [NSKeyedUnarchiver unarchiveObjectWithData:nsData_output];
//    if (as_output == nil){
//        NSLog(@"--------nil");
//    }else{
//        NSLog(@"nilではない");
//    }
//    NSLog(@"--------------");
//    NSLog([as_output.YYYYMMDD objectAtIndex:0]);
//    NSLog([as_output.YYYYMMDD objectAtIndex:1]);
//    NSLog([as_output.YYYYMMDD objectAtIndex:2]);
//    NSLog(@"--------------");

    
    
    
    
    
    
    //参考：http://d.hatena.ne.jp/paraches/20110826
    
    // Create graph from theme
	graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
	[graph applyTheme:theme];
	CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.view;
	hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
	hostingView.hostedGraph = graph;
    
    
    //丸角矩形で上下左右余白を10ピクセルにする(上記デフォルトでは20ピクセル)
    graph.paddingLeft = 10.0;
	graph.paddingTop = 10.0;
	graph.paddingRight = 10.0;
	graph.paddingBottom = 10.0;
    
    
    //太枠線を無くす(デフォルトではあり)
    graph.plotAreaFrame.borderLineStyle = nil;
    
    //現状ではPlotAreaFrameがそのままPlotAreaになっているのでx軸、y軸やタイトルを描く場所がない
    //そこでPlotAreaFrameのpadding設定をして、x軸とy軸を描く
    graph.plotAreaFrame.paddingLeft = 70.0;
	graph.plotAreaFrame.paddingTop = 80.0;
	graph.plotAreaFrame.paddingRight = 20.0;
	graph.plotAreaFrame.paddingBottom = 40.0;
    
    
    //以下：http://d.hatena.ne.jp/paraches/20110827
    
    // Add plot space for horizontal bar charts
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
//	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(100)];
//	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(31.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInteger(0) length:CPTDecimalFromInteger(31)];
    
    
    // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
	// Axes Line Style
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineColor = [CPTColor greenColor];
	lineStyle.lineWidth = 2.0f;
    
	// X Axis
	CPTXYAxis *x = axisSet.xAxis;
	x.majorIntervalLength = CPTDecimalFromString(@"5");//主値の目盛り感覚
	x.minorTicksPerInterval = 4;//主値の間の目盛りの個数
	x.majorTickLineStyle = lineStyle;
	x.minorTickLineStyle = lineStyle;
	x.axisLineStyle = lineStyle;
	x.minorTickLength = 5.0f;
	x.majorTickLength = 9.0f;
    
    
    //	Y Axis
	lineStyle.lineColor = [CPTColor yellowColor];
    
	CPTXYAxis *y = axisSet.yAxis;
	y.majorIntervalLength = CPTDecimalFromString(@"10");
	y.minorTicksPerInterval = 4;
	y.majorTickLineStyle = lineStyle;
	y.minorTickLineStyle = lineStyle;
	y.axisLineStyle = lineStyle;
	y.minorTickLength = 5.0f;
	y.majorTickLength = 9.0f;
	y.title = @"正解率";
	y.titleOffset = 35.0f;	//	move left from y axis. negative value is go right.
	lineStyle.lineWidth = 0.5f;
	y.majorGridLineStyle = lineStyle;
    
    
    
    //x軸、y軸ラベルの小数点以下を表示しない
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:0];
    x.labelFormatter = formatter;
    y.labelFormatter = formatter;
    
    
    
    
    // Graph title
	graph.title = [NSString stringWithFormat:@"(下方向にスワイプして戻って下さい)\n\n%@成績の推移", _sectorName];
	CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
	textStyle.color = [CPTColor cyanColor];
	textStyle.fontSize = 16.0f;
	textStyle.textAlignment = CPTTextAlignmentCenter;
	graph.titleTextStyle = textStyle;
	graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    
    //ちなみにtitlePlotAreaFrameAnchorの設定は以下の通り
    //    CPTRectAnchorBottomLeft	The bottom left corner
    //    CPTRectAnchorBottom	The bottom center
    //    CPTRectAnchorBottomRight	The bottom right corner
    //    CPTRectAnchorLeft	The left middle
    //    CPTRectAnchorRight	The right middle
    //    CPTRectAnchorTopLeft	The top left corner
    //    CPTRectAnchorTop	The top center
    //    CPTRectAnchorTopRigh	The top right
    //    CPTRectAnchorCenter	The center of the rect
    
    
	graph.titleDisplacement = CGPointMake(20.0f, -10.0f);
    
    
    
    //http://d.hatena.ne.jp/paraches/20110828
    // First bar plot
    //棒の色を指定して棒グラフを作成する
	CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO];
    
    //X軸の値の基本になる値は 0。これを変更すると棒グラフの棒が上下に動く
	barPlot.baseValue = CPTDecimalFromString(@"0");
    
    //データソースは自分自身（ViewController）とする。
	barPlot.dataSource = self;
    
    //この棒グラフの id は Bar Plot 1 とする
	barPlot.identifier = @"Bar Plot 1";
    
    //棒間隔の調整
    //    barPlot.barWidth = CPTDecimalFromFloat(0.1f);
    
    //棒を少し右にずらす(調整)
    barPlot.barOffset = CPTDecimalFromString(@"0.1f");
    
    
    //横軸を日付フォーマットにする
    //// Graph data prepare
//	NSDate *refDate = [NSDate date];
//	NSTimeInterval oneDay = 24.0f * 60.0f * 60.0f;
//    
//	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(oneDay * -1.0f)
//                                                    length:CPTDecimalFromFloat(oneDay*32.0f)];
//    
//	x.majorIntervalLength = CPTDecimalFromFloat(oneDay*14.0f);
//	x.minorTicksPerInterval = 13;
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
//	CPTTimeFormatter *timeFormatter = [[CPTTimeFormatter alloc] initWithDateFormatter:dateFormatter];
//    timeFormatter.referenceDate = refDate;
//    x.labelFormatter = timeFormatter;
//    
//    y.orthogonalCoordinateDecimal = CPTDecimalFromFloat(-24.0f*60.0f*60.0f/4.0f*3.0f);
//    
//    barPlot.barWidth = CPTDecimalFromFloat(oneDay);
    
    
    //この棒グラフ（CPTBarPlot）をグラフ（graph）のプロットスペースに加える
	[graph addPlot:barPlot toPlotSpace:plotSpace];
     
    
}

//参考：http://d.hatena.ne.jp/paraches/20110828
#pragma mark -
#pragma mark Plot Data Source Methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    if ([YYYYMMDD count] > 30){
        return 30;
    }else{
        return [YYYYMMDD count];//作成するデータの個数
    }
}

    //そのプロット（CPTPlot）の field の recordIndex 番目のレコードの値を返す
-(NSNumber *)numberForPlot:(CPTPlot *)plot
                     field:(NSUInteger)fieldEnum
               recordIndex:(NSUInteger)index
{
	if(fieldEnum == CPTBarPlotFieldBarLocation)
		return [NSNumber numberWithDouble:index+1];
	else
	{
		if(plot.identifier == @"Bar Plot 1"){
            //indexの値に応じた返り値を出力する
//			return [NSNumber numberWithDouble:(index+1)*2.0f];//返すデータ
            NSLog(@"正解履歴%d = %@", index, [seikai objectAtIndex:index]);
            return [NSNumber numberWithDouble:
                    ([[seikai objectAtIndex:(index)] doubleValue] /
                     [[kaitou objectAtIndex:(index)] doubleValue] * 100 + 1
                    )];//返すデータ
        }
		else
			return 0;
	}
    
    //http://d.hatena.ne.jp/paraches/20110829
    

//    if(fieldEnum == CPTBarPlotFieldBarLocation){
////        NSLog( [NSNumber numberWithDouble:index*24.0*60.0*60.0] );
//        return [NSNumber numberWithDouble:index*24.0*60.0*60.0];
////        return [NSNumber numberWithDouble:3.0];
//    }
//    else
//    {
//        if(plot.identifier == @"Bar Plot 1")
//            return [NSNumber numberWithDouble:(index/2.0f+1.0f)*1.0f];
////            return [NSNumber numberWithDouble:3.0f];
//        else
//            return 0;
//    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
