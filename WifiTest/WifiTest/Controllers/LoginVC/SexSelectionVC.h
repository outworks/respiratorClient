//
//  SexSelectionVC.h
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"

@interface SexSelectionVC : BasicVC


@property (weak, nonatomic) IBOutlet UIButton *btn_boy;
@property (weak, nonatomic) IBOutlet UIButton *btn_girl;

@property(nonatomic,strong) Member *member;
@property(nonatomic,assign) BOOL isRegiest;

@end
