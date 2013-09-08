//
//  ResultViewController.h
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/09.
//
//

#import <UIKit/UIKit.h>
//追加部分
#import "CorePlot-CocoaTouch.h"

@interface ResultViewController : UIViewController

//追加部分
<CPTPieChartDataSource,CPTPieChartDelegate,CPTPlotDataSource>

//追加部分
@property (readwrite, nonatomic) NSMutableArray *pieChartData;

@property (nonatomic, weak) IBOutlet UIButton* bt1;
@property (nonatomic, weak) IBOutlet UIButton* bt2;
@property (nonatomic, weak) IBOutlet UIButton* bt3;
@property (nonatomic, weak) IBOutlet UIButton* bt4;
@property (nonatomic, weak) IBOutlet UIButton* bt5;

- (IBAction)pushRtn:(id)sender;
@end
