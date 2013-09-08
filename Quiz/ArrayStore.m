//
//  DataStore.m
//  SampleDataPreserve
//
//  Created by 遠藤 豪 on 13/07/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "ArrayStore.h"

@implementation ArrayStore

//数字は目盛りに保存する時に型が分からなくなるので、文字列として保存を推奨する
@synthesize SECTOR = SECTOR_;
@synthesize YYYYMMDD = YYYYMMDD_;
@synthesize KAITOU = KAITOU_;
@synthesize SEIKAI = SEIKAI_;
@synthesize GOTOU = GOTOU_;

- (id)initWithArrayStore:(NSString*)sector  {
    
    //各章番号の初期化
    self.SECTOR = sector;
    
    
    
//    これが間違え？！
//    YYYYMMDD_ =  [NSMutableArray array];
//    self.YYYYMMDD =  [NSMutableArray array];
    
    
    //既に保存されているArrayStoreデータを読み込んで格納する
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSData* classDataReturn = [defaults dataForKey:sector];
//    ArrayStore* testReturn = [NSKeyedUnarchiver unarchiveObjectWithData:classDataReturn];
//    
//    if(testReturn == nil){
//        NSLog(@"nil @ initWithArrayStore");
//    }else{
//        NSLog(@"not nil @ initWithArrayStore");
//    }
//    NSLog(testReturn.SECTOR);
    
	return self;
}
- (void)store:(NSString*)sector
     yyyymmdd:(long)yyyymmdd
       kaitou:(long)kaitou
       seikai:(long)seikai
        gotou:(long)gotou
{
    NSLog(@"executing...");
    NSLog([[NSNumber numberWithInt:[self.YYYYMMDD count]] stringValue]);
    
    
    /*
    //過去にyyyymmddが格納されていないか確認
    
    for(int i = 0;i < [self.YYYYMMDD count] ; i++){
        NSLog ([[NSNumber numberWithInt:i] stringValue]);
    }
    //格納されていれば当該配列個所に足す
    
    //格納されていなければ最後を除去して、一つずつずらして最初に挿入
     */
    
    
    //クラス内に配列を作って要素を追加するためにはallc　initを実行しなくてはならない。
    //NSMutableArrayはallc initを実行しないと要素を追加できない。
    //NSArrayはどうか？
    //クラスではなく、最初から配列を格納するようにしてしまえばどうか？＝＞実行！
    NSMutableArray *anArray = [[NSMutableArray alloc] init];
    NSString *str = @"テストで挿入した文字列";
    [anArray addObject:str];
    
    NSLog(@"=============================");
    NSLog(@"配列要素数 : %d", [anArray count]);
//    [ NSString stringWithFormat : @"%d", 100]; 
    NSLog(@"%@",[anArray objectAtIndex:[anArray count] - 1]);//最後の要素を出力する
    NSLog(@"=============================");
    
    //上記の作業は全てNSMutableArrayのaddObjectで代用可
    [self.YYYYMMDD addObject:([[NSNumber numberWithLong:yyyymmdd] stringValue])];
    [self.KAITOU addObject:([[NSNumber numberWithLong:kaitou] stringValue])];
    [self.SEIKAI addObject:([[NSNumber numberWithLong:seikai] stringValue])];
    [self.GOTOU addObject:([[NSNumber numberWithLong:gotou] stringValue])];
    
    NSLog(@"格納後　%d",[self.YYYYMMDD count]);
    
    
//    [YYYYMMDD_ addObject:([[NSNumber numberWithLong:yyyymmdd] stringValue])];
//    [KAITOU_ addObject:([[NSNumber numberWithLong:kaitou] stringValue])];
//    [SEIKAI_ addObject:([[NSNumber numberWithLong:seikai] stringValue])];
//    [GOTOU_ addObject:([[NSNumber numberWithLong:gotou] stringValue])];
    
    
    NSLog([[NSNumber numberWithLong:yyyymmdd] stringValue]);
    NSLog([[NSNumber numberWithLong:kaitou] stringValue]);
    NSLog([[NSNumber numberWithLong:seikai] stringValue]);
    NSLog([[NSNumber numberWithLong:gotou] stringValue]);
    
    //以下の結果からaddObjectできていない？！
    NSLog(@"%d番目に格納した値は%@",[YYYYMMDD_ count]-1,[YYYYMMDD_ objectAtIndex:[YYYYMMDD_ count]-1]);
    NSLog(@"%d番目に格納した値は%@",[YYYYMMDD_ count],[YYYYMMDD_ objectAtIndex:[YYYYMMDD_ count]]);
}


- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:self.YYYYMMDD forKey:@"YYYYMMDD"];
    [coder encodeObject:self.KAITOU forKey:@"KAITOU"];
    [coder encodeObject:self.SEIKAI forKey:@"SEIKAI"];
    [coder encodeObject:self.GOTOU forKey:@"GOTOU"];
}

-(id)initWithCoder:(NSCoder*)coder {
    if((self = [super init])) {
        self.YYYYMMDD = [coder decodeObjectForKey:@"YYYYMMDD"];
        self.KAITOU = [coder decodeObjectForKey:@"KAITOU"];
        self.SEIKAI = [coder decodeObjectForKey:@"SEIKAI"];
        self.GOTOU = [coder decodeObjectForKey:@"GOTOU"];
    }
    return self;
}
@end
