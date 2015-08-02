//
//  UserInfoVC.h
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"

@interface UserInfoVC : BasicVC

@property(nonatomic,strong) NSNumber *sex;
@property(nonatomic,strong) Member *member;
@property(nonatomic,assign) BOOL isRegiest;

@end
