//
//  MenuViewController.h
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/29.
//
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray* wrongList;

- (IBAction)cancelButtonPressed:(id)sender;
- (NSString*)getQuestSentence:(NSString*)questName;
- (int)getSectNo:(NSString*)questName;
- (int)getQuestNo:(NSString*)questName;
    

@end
