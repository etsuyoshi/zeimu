//
//  ConfigViewController.h
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/25.
//
//

#import <UIKit/UIKit.h>

//picker:http://www.objectivec-iphone.com/UIKit/UIPickerView/UIPickerView.html

@interface ConfigViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *numQuestPicker;
    UIButton *deleteResultButton;
    NSArray *arrStatus;
}
//戻るボタン
//参考：http://masterka.seesaa.net/article/266594606.html
- (IBAction)toolBarButtonEvent:(id)sender;
- (IBAction)deleteResultButtonEvent:(id)sender;


@property (weak, nonatomic) IBOutlet UIPickerView *numQuestPicker;
@property (weak, nonatomic) IBOutlet UIButton *deleteResultButton;

@end
