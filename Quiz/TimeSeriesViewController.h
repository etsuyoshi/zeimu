//
//  TimeSeriesViewController.h
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/14.
//
//

#import <UIKit/UIKit.h>
//追加部分
#import "CorePlot-CocoaTouch.h"

@interface TimeSeriesViewController : UIViewController
//追加部分
<CPTPieChartDataSource,CPTPieChartDelegate,CPTPlotDataSource>{
@private
    CPTXYGraph *graph;
    
    
    NSString* _myValue;
//    id<SecondViewDelegate> _delegate;
    
}

@property (nonatomic) NSString* sectorName;
@end
