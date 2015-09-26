//
//  SetCell.m
//  WifiTest
//
//  Created by nd on 15/7/12.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _imageV_bottomLine.backgroundColor = [UIColor colorWithRed:170.f/255.f green:170.f/255.f blue:170.f/255.f alpha:0.5f];
    // Configure the view for the selected state
}

@end
