//
//  MenuViewController.m
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/29.
//
//

#import "MenuViewController.h"
#import "WrongQuestion.h"
#import "Quiz.h"
#import "QuizItem.h"
#import "QuizRunningViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize wrongList = _wrongList;

NSMutableArray *sectQuestNameArray = nil;
NSMutableArray *sectQuestNoArray = nil;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    //参考：http://www.youtube.com/watch?v=2p8Gctq62oU
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.wrongList = [[NSMutableArray alloc] init];
    
    sectQuestNameArray = [[NSMutableArray alloc]init];
    sectQuestNoArray = [[NSMutableArray alloc] init];
    NSString *sectName = nil;
    NSString *questName = nil;
    //NSUserDefaultsを読取り、配列に格納(並べ替え後？)
    NSUserDefaults *nsud = [NSUserDefaults standardUserDefaults];
//    NSInteger uncorrectAns = nil;
    for(int sectNo = 1; sectNo <= 6;sectNo ++){
        
        sectName = [NSString stringWithFormat:@"%03d", sectNo];
        for(int questNo = 0; questNo < 100;questNo++){
            questName = [NSString stringWithFormat:@"%03d0", questNo];
            
            if([nsud stringForKey:[NSString stringWithFormat:@"UncorrectAnsSECT%@Q%@", sectName, questName]] != NULL){
                [sectQuestNameArray addObject:[NSString stringWithFormat:@"UncorrectAnsSECT%@Q%@", sectName, questName]];
                [sectQuestNoArray addObject:[nsud stringForKey:[NSString stringWithFormat:@"UncorrectAnsSECT%@Q%@", sectName, questName]]];
//              NSLog(@"%@章%@問誤答回数=%@", sectName, questName, [sectQuestArray lastObject]);//最後は常にnull
            
                NSLog(@"%@章%@:誤答回数=%@", sectName, questName, [nsud stringForKey:[NSString stringWithFormat:@"UncorrectAnsSECT%@Q%@", sectName, questName]]);
//                NSLog(@"%d", [sectQuestNameArray count]);
            }
        }
    }
    
//    NSLog(@"確認%d", [sectQuestNameArray count]);
    
    //一つも格納されていない(過去履歴がない)場合はダイアログ表示後、終了する
    
    if ([sectQuestNameArray count] == 0){
        //ダイアログで解答問題数を修正するか確認する
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"解答履歴がありません。"
                                                         message:@"No Record..."
                                                        delegate:self
                                               cancelButtonTitle:@"終了(exit)"
                                               otherButtonTitles:nil,
                               nil];
        alert1.tag = 1;//ダイアログの識別子
        [alert1 show];
        

    }else{
    
        //bubble sort
        for(int i = 0; i< sectQuestNameArray.count-1;i++){
            for(int j = sectQuestNameArray.count-1;j > i;j--){
                //            NSLog(@"%d", j);
                //            NSLog(@"%@", [sectQuestNameArray objectAtIndex:j]);
                //大きい順(昇順)
                if([[sectQuestNoArray objectAtIndex:j] intValue] >
                   [[sectQuestNoArray objectAtIndex:j - 1] intValue]){
                    //                NSLog(@"%d", j);
                    //入れ替える
                    [sectQuestNoArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                    [sectQuestNameArray exchangeObjectAtIndex:j withObjectAtIndex:j - 1];
                    //                NSLog(@"%d", j);
                }
                //            NSLog(@"%d", j);
            }
        }
        
        int forNum = 0;
        //確認用
        //    for(id object in sectQuestNameArray){
        //        NSLog(@"%@ : %@", object, [sectQuestNoArray objectAtIndex:forNum]);
        //        forNum++;
        //    }
        
        
        //格納されているnsudの個数分だけメニューを追加する
        WrongQuestion *wrongQuestion = nil;
        forNum = 0;
        NSString* dispName = nil;//リストに表示する名前
        NSString* dispSentence = nil;
        NSString* dispNo = nil;
        NSRange searchLocation;
        for(id object in sectQuestNameArray){
            wrongQuestion = nil;
            dispName = nil;
            if([[sectQuestNoArray objectAtIndex:forNum] intValue] != 0){
                //            dispName = [NSString stringWithFormat:@"%@:%@",
                //                        [self getQuestSentence:(NSString*)object],
                //                        [sectQuestNoArray objectAtIndex:forNum]];
                dispNo = [NSString stringWithFormat:@"第%d章No%d",
                          [self getSectNo:(NSString*)object],
                          [self getQuestNo:(NSString*)object]];
                dispSentence = [self getQuestSentence:(NSString*)object];
                
                //正解率%以降の文字列
                searchLocation = [dispSentence rangeOfString:@"%"];
                
                if(searchLocation.location == NSNotFound){
                    //正解率表示がない場合
                }else{
                    dispSentence = [dispSentence substringWithRange:NSMakeRange(searchLocation.location+2,9)];
                }
                dispSentence = [NSString stringWithFormat:@"%@...", dispSentence];
                
                dispName = [NSString stringWithFormat:@"%@:%@", dispNo, dispSentence];
                dispName = [NSString stringWithFormat:@"【%@回】%@",
                            [sectQuestNoArray objectAtIndex:forNum],
                            dispName];
                
                //            NSLog(@"%@", [self getQuestSentence:dispName]);
                wrongQuestion = [[WrongQuestion alloc]initWithName:dispName done:NO];
                [self.wrongList addObject:wrongQuestion];
            }
            forNum ++;
        }
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



//問題文を返す(questName = UncorrectAnsSECTXXXQYYYY0)
- (NSString*)getQuestSentence:(NSString*)questName{
    NSString *tempStr = [questName substringFromIndex:16];
    int sectNo = [[tempStr substringWithRange:NSMakeRange(0, 3)] intValue];
    int questNo = [[tempStr substringWithRange:NSMakeRange(4,3)] intValue];
    NSLog(@"%@, %@, %d, %d", questName, tempStr, sectNo, questNo);
    if(questName != nil){
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:
                          [NSString stringWithFormat:@"homu%d", sectNo]
                                          ofType:@"csv"];
        Quiz *quiz = [[Quiz alloc] initWithKokuhukuMode:questNo];
        [quiz readFromCSV:path];
        QuizItem *item = [quiz nextQuiz];
        
        //問題文を抽出
        return item.question;
    }else{
        return nil;
    }
}
- (int)getSectNo:(NSString*)questName{
    NSString *tempStr = [questName substringFromIndex:16];
    return [[tempStr substringWithRange:NSMakeRange(0, 3)] intValue];
}

- (int)getQuestNo:(NSString*)questName{
    NSString *tempStr = [questName substringFromIndex:16];
    return [[tempStr substringWithRange:NSMakeRange(4,3)] intValue];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.wrongList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    WrongQuestion *wrongQuestion = [self.wrongList objectAtIndex:indexPath.row];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //UITableViewCellオブジェクトを取得
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //UITableViewCellオブジェクトのラベルを設定
    cell.textLabel.text = wrongQuestion.name;
    
    //UITableViewCellを返す
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //参考：http://stackoverflow.com/questions/12250848/performing-segue-with-prototype-cells
    [self performSegueWithIdentifier:@"menuSegue" sender:indexPath];
        

}

// セグエを使ってビューコントローラを開くときに呼ばれる
- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    
    //【課題】問題番号までを指定して解答する
    NSIndexPath *nip = (NSIndexPath*)sender;
    int selectedCellNo = nip.row;
    
    int selectedSectNo = [self getSectNo:[sectQuestNameArray objectAtIndex:selectedCellNo]];
    int selectedQuestNo = [self getQuestNo:[sectQuestNameArray objectAtIndex:selectedCellNo]];
    
    // クイズ出題画面用のビューコントローラを取得するための入れ物
    QuizRunningViewController *vc;
    
    
    // クイズデータのファイルパスを取得する
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path= [bundle pathForResource:[NSString stringWithFormat:@"homu%d",selectedSectNo]
                                     ofType:@"csv"];
    
    // クイズデータを読み込む
    Quiz *quiz = [[Quiz alloc] initWithKokuhukuMode:selectedQuestNo];
    
    // ファイルから読み込んで、ローカル変数quizデータに格納する
    [quiz readFromCSV:path];
    
    
    // 2回目以降の場合があるので、出題済みの情報をクリアする
    //        [self.quiz clear];
    
    // クイズ出題画面用のビューコントローラを取得する
    vc = segue.destinationViewController;
    
    // クイズ情報を設定する
    //        [vc setQuiz:self.quiz];
    [vc setQuiz:quiz];
}

- (void)cancelButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
