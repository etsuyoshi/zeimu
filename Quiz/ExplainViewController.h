//
//  ExplainViewController.h
//  Quiz
//
//  Created by 遠藤 豪 on 13/06/26.
//
//

#import <UIKit/UIKit.h>

@interface ExplainViewController : UIViewController{
    NSString* _explanation;
}

//テキストビュー(解説文)
@property (weak, nonatomic) IBOutlet UITextView *explainTextView;


//説明文
@property (nonatomic) NSString* explanation;

- (IBAction)pushBtn:(id)sender;

@end
