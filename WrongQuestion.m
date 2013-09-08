//
//  WrongQuestion.m
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/30.
//
//

#import "WrongQuestion.h"

@implementation WrongQuestion

@synthesize name = _name;
@synthesize done = _done;

-(id)initWithName:(NSString *)name done:(BOOL)done{
    
    self = [super init];
    
    if(self){
        self.name = name;
        self.done = done;
//        NSLog(@"WrongQuestion = %@", self.name);
    }
    
    return self;
}

@end
