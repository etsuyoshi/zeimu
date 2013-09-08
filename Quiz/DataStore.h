//
//  DataStore.h
//  SampleDataPreserve
//
//  Created by 遠藤 豪 on 13/07/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStore : NSObject <NSCoding>
{
    //データ構造をちゃんと考えるべき！
    //結果グラフを作成するときは、章毎に集計(平均値)を取得する(時系列グラフも然り)
    //従って当該クラスを使用するときは、章毎のクラスを作成してDataStore *Sect1, *Sect2, ・・・とすべき。
    
    //クラスの内部フィールドは
    //横方向に日付、回答数、正解数、誤答数の四列、
    //縦方向に100回(100行)分の集計済サンプルとする二次元配列とする。
    
    //問題：
    @private
    NSMutableString* YYYYMMDD_;
    NSMutableString* kaitou_;
    NSMutableString* seikai_;
    NSMutableString* gotou_;
//    NSDate* date_;
//    NSInteger* num_;
}

@property(nonatomic, copy) NSMutableString* YYYYMMDD;
@property(nonatomic, copy) NSMutableString* kaitou;
@property(nonatomic, copy) NSMutableString* seikai;
@property(nonatomic, copy) NSMutableString* gotou;
//@property(nonatomic) int* num;

@end