//
//  ShareValue.h
//  HelloToy
//
//  Created by nd on 15/4/21.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface ShareValue : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(ShareValue)

@property(nonatomic,strong) Member *member;

@end
