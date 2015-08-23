//
//  DrugResultView.h
//  WifiTest
//
//  Created by Hcat on 15/8/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAPI.h"

@interface DrugResultView : UIView

+ (DrugResultView *)initCustomView;

@property (nonatomic,strong) Monidata *beforeMonidata;
@property (nonatomic,strong) Monidata *afterMonidata;
-(void)loadData;

@end
