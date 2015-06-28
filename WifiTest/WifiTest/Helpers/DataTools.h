//
//  DataTools.h
//  WifiTest
//
//  Created by ilikeido on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DateMonidata.h"
#import "Monidata.h"
#import "ARCSingletonTemplate.h"

@interface DataTools : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(DataTools)

@property(nonatomic,strong) NSArray *dateDatas;

@end
