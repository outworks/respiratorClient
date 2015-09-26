//
//  LRPicker.h
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRPickerColon : UITableView

@property NSInteger tagLastSelected;

- (void)dehighlightLastCell;
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow;

@end


@interface LRPicker : UIView  <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (id)initWithFrame:(CGRect)frame withDataArray:(NSArray *)arr_data withFrameArray:(NSArray *)arr_frame withScrollEnabledArray:(NSArray *)arr_enabled withOptions:(NSDictionary *)options;

@property (nonatomic) UIColor *color_selected; // 选中颜色
@property (nonatomic) UIColor *color_unSelected; //未选中颜色

- (void)setDefaultData:(NSArray *)data;

- (NSArray *)getSelectedData;

extern NSString * const LRPickerOptionSelectedColor;               //选中颜色
extern NSString * const LRPickerOptionUnSelectedColor;             //未选中颜色
extern NSString * const LRPickerOptionColonFont;                   //单元格字体
extern NSString * const LRPickerOptionColonHeight;                 //单元格高

@end
