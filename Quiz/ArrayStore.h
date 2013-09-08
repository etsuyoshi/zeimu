//
//  DataStore.h
//  SampleDataPreserve
//
//  Created by 遠藤 豪 on 13/07/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayStore : NSObject <NSCoding>
{
    //データ構造をちゃんと考えるべき！
    //結果グラフを作成するときは、章毎に集計(平均値)を取得する(時系列グラフも然り)
    //従って当該クラスを使用するときは、章毎のクラスを作成してDataStore *Sect1, *Sect2, ・・・とすべき。
    
    //クラスの内部フィールドは
    //横方向に日付、回答数、正解数、誤答数の四列、
    //縦方向に100回(100行)分の集計済サンプルとする二次元配列とする。
    
    //問題：
    @private
    NSString* SECTOR_;
    NSMutableArray* YYYYMMDD_;
    NSMutableArray* KAITOU_;
    NSMutableArray* SEIKAI_;
    NSMutableArray* GOTOU_;
}

@property(nonatomic, copy) NSString* SECTOR;
@property(nonatomic, copy) NSMutableArray* YYYYMMDD;
@property(nonatomic, copy) NSMutableArray* KAITOU;
@property(nonatomic, copy) NSMutableArray* SEIKAI;
@property(nonatomic, copy) NSMutableArray* GOTOU;

//イニシャライザ
-(id)initWithArrayStore:(NSString*)sector;

//各変数を格納するメソッド
-(void)store:(NSString*)sector
    yyyymmdd:(long)yyyymmdd
      kaitou:(long)kaitou
      seikai:(long)seikai
       gotou:(long)gotou;

@end