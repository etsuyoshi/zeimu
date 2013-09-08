//
//  WrongQuestion.h
//  Homu3
//
//  Created by 遠藤 豪 on 13/07/30.
//
//

#import <Foundation/Foundation.h>

@interface WrongQuestion : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) BOOL done;

-(id)initWithName:(NSString*)name done:(BOOL)done;


@end
