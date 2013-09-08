//
//  DataStore.m
//  SampleDataPreserve
//
//  Created by 遠藤 豪 on 13/07/13.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "DataStore.h"

@implementation DataStore

//数字は目盛りに保存する時に型が分からなくなるので、文字列として保存を推奨する
@synthesize YYYYMMDD = YYYYMMDD_;
@synthesize kaitou = kaitou_;
@synthesize seikai = seikai_;
@synthesize gotou = gotou_;



- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:self.YYYYMMDD forKey:@"YYYYMMDD"];
    [coder encodeObject:self.kaitou forKey:@"KAITOU"];
    [coder encodeObject:self.seikai forKey:@"SEIKAI"];
    [coder encodeObject:self.gotou forKey:@"GOTOU"];
}

-(id)initWithCoder:(NSCoder*)coder {
    if((self = [super init])) {
        self.YYYYMMDD = [coder decodeObjectForKey:@"20130101"];
        self.kaitou = [coder decodeObjectForKey:@"KAITOU"];
        self.seikai = [coder decodeObjectForKey:@"SEIKAI"];
        self.gotou = [coder decodeObjectForKey:@"GOTOU"];
    }
    return self;
}
@end
