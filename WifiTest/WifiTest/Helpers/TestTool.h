//
//  TestTool.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestTool : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(TestTool)

@property(nonatomic,assign,readonly) float pef;
@property(nonatomic,assign,readonly) float fev1;
@property(nonatomic,assign,readonly) float fvc;


-(void)test;


@end
