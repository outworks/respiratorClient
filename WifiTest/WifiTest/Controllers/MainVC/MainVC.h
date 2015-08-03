//
//  MainVC.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"

typedef NS_ENUM(NSInteger, ContentType){
    MotionType = 0,
    DailyType,
    MedicationType,
};

@interface MainVC : BasicVC

@property(strong,nonatomic)UITabBarController *vc_tab;
@property(nonatomic,assign) ContentType contentType;

@end
