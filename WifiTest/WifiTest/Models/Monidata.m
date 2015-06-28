//
//  Monidata.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "Monidata.h"

@implementation Monidata

-(NSString *)stateString{
    if ([_level integerValue]==1) {
        return @"良好";
    }else if ([_level integerValue]==2) {
        return @"正常";
    }else if ([_level integerValue]==3) {
        return @"危险";
    }
    return @"";
}

@end
