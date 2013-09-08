//
//  ConfigViewController.m
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/25.
//
//

#import "ConfigViewController.h"

@interface ConfigViewController ()

@end

//pickerの使い方：http://www.leesilver.net/1/post/2011/07/uipickerview-how-to-populate.html
@implementation ConfigViewController
    int numOfQuest = 3;


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
    [self setBarButtonItem];
    
    
    arrStatus = [[NSArray alloc] initWithObjects:@"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    
    
    // UIPickerのインスタンス化
//    picker = [[UIPickerView alloc]init];
    UIPickerView *picker = self.numQuestPicker;
    
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    int newValue = [d stringForKey:[NSString stringWithFormat:@"numOfQuest"]].integerValue;
    for(int i = 0; i < arrStatus.count; i++) {
        if (newValue == [[arrStatus objectAtIndex:i] intValue]){
            [picker selectRow:i inComponent:0 animated:YES];
        }
    }
    
    [picker reloadAllComponents];
//
//    // デリゲートを設定
//    picker.delegate = self;
//    
//    // データソースを設定
//    picker.dataSource = self;
//    
//    // 選択インジケータを表示
//    picker.showsSelectionIndicator = YES;
//    
//    // UIPickerのインスタンスをビューに追加
//    [self.view addSubview:picker];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// ツールバーボタンを設定
//参考：http://d.hatena.ne.jp/heppokose/20120618/1340006009
- (void) setBarButtonItem
{
    NSLog(@"setBarButtonItem");
    UIBarButtonItem *barButtonItem1 = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                       target:self action:@selector(buttonEvent1:)];
}

// ツールバー(戻る)ボタンが押された時のアクション
- (void) toolBarButtonEvent:(id)sender
{
    NSLog(@"toolbarButtonPressed->Return");
    [self dismissModalViewControllerAnimated:YES];
}


/*
 *以下、ピッカーの設定：http://www.objectivec-iphone.com/UIKit/UIPickerView/UIPickerView.html
 */
//ピッカーの表示する列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//ピッカーに表示する行数を返す
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [arrStatus count];
}

//行のサイズを変更
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 40.0;
            break;
            
            //        case 1: // 2列目
            //            return 100.0;
            //            break;
            //
            //        case 2: // 3列目
            //            return 150.0;
            //            break;
            
        default:
            return 0;
            break;
    }
}

//ピッカーに表示する値を返す
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
//            return [NSString stringWithFormat:@"%d", row];
            return [arrStatus objectAtIndex:row];
            break;
            
            //        case 1: // 2列目
            //            return [NSString stringWithFormat:@"%d行目", row];
            //            break;
            //
            //        case 2: // 3列目
            //            return [NSString stringWithFormat:@"%d列-%d行", component, row];
            //            break;
            
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーの選択行が決まったとき
 */
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 1列目の選択された行数を取得
    NSInteger val0 = [pickerView selectedRowInComponent:0];
    
    //    // 2列目の選択された行数を取得
    //    NSInteger val1 = [pickerView selectedRowInComponent:1];
    //
    //    // 3列目の選択された行数を取得
    //    NSInteger val2 = [pickerView selectedRowInComponent:2];
    
    NSLog(@"1列目:%d行目が選択", val0);
    numOfQuest = [[arrStatus objectAtIndex:val0] intValue];
    NSLog(@"%d", numOfQuest);
    //    NSLog(@"2列目:%d行目が選択", val1);
    //    NSLog(@"3列目:%d行目が選択", val2);
    
    //ダイアログで解答問題数を修正するか確認する
    UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"問題数変更が選択されました。"
                                                     message:@"変更を反映しますか？"
                                                    delegate:self
                                           cancelButtonTitle:@"いいえ(キャンセル)"
                                           otherButtonTitles:@"はい",
                           nil];
    alert1.tag = 1;
    [alert1 show];
}

    //http://d.hatena.ne.jp/corrupt/20110419/1303204067
// pickerで値が変更された場合に呼び出されるダイアログ及び成績表削除ボタンが押された時のダイアログ
- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    NSUserDefaults* defaults = nil;
    
    // 押されたボタンの確認
    switch (buttonIndex) {
        case 0:
            // いいえが押された場合の処理
            break;
        case 1:
            // はいが押された場合の処理
            defaults = [NSUserDefaults standardUserDefaults];
            if(alertView.tag == 1){//pickerの場合
                //個々の問題の成績を格納
                [defaults setObject:[NSString stringWithFormat:@"%d", numOfQuest]
                             forKey:[NSString stringWithFormat:@"numOfQuest"]];
                NSLog(@"設問数を変更完了");
            }else if(alertView.tag == 2){
                //成績を削除する
                [defaults removeObjectForKey:@"SECT001"];
                [defaults removeObjectForKey:@"SECT002"];
                [defaults removeObjectForKey:@"SECT003"];
                [defaults removeObjectForKey:@"SECT004"];
                [defaults removeObjectForKey:@"SECT005"];
                [defaults removeObjectForKey:@"SECT006"];
                
                //個別問題の回答数についても削除する->@Answer(UncorrectAns)SECT006Q0010？
//                NSLog(@"%d",[defaults stringForKey:[NSString stringWithFormat:@"AnswerSECT001Q0010"]].integerValue);
                NSString* sectorName = nil;
                NSString* questName = nil;
                for(int sectNo = 0; sectNo < 10;sectNo++){
                    sectorName = [NSString stringWithFormat:@"SECT%@", [NSString stringWithFormat:@"%03d", sectNo]];
                    for(int questNo = 0; questNo < 100;questNo++){
                        questName = [NSString stringWithFormat:@"Q%@0", [NSString stringWithFormat:@"%03d", questNo]];
                        [defaults removeObjectForKey:[NSString stringWithFormat:@"Answer%@%@", sectorName, questName]];
                        [defaults removeObjectForKey:[NSString stringWithFormat:@"UncorrectAns%@%@", sectorName, questName]];
//                        NSLog(@"%@", [NSString stringWithFormat:@"Answer%@%@", sectorName, questName]);
//                        NSLog(@"%@", [NSString stringWithFormat:@"UncorrectAns%@%@", sectorName, questName]);
                    }
                }
//                NSLog(@"%d",[defaults stringForKey:[NSString stringWithFormat:@"AnswerSECT001Q0010"]].integerValue);
                NSLog(@"成績を削除完了");
                
            }
            
            break;
            
        default:
            break;
    }
}

-(IBAction)deleteResultButtonEvent:(id)sender{
    //ダイアログで解答問題数を修正するか確認する
    UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"成績表削除が選択されました。" message:@"削除を実行しますか？" delegate: self cancelButtonTitle:@"いいえ(キャンセル)" otherButtonTitles:@"はい", nil];
    alert2.tag = 2;
    [alert2 show];
}


@end
