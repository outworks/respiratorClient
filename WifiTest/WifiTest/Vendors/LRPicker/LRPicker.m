//
//  LRPicker.m
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "LRPicker.h"



@interface LRPickerColon ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSTextAlignment cellAlign;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation LRPickerColon

- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues withFont:(UIFont *)font
      withTextAlign:(NSTextAlignment)align withCellHeight:(CGFloat)cellHeight{
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake((CGRectGetHeight(self.bounds)-_cellHeight)/2.0, 0.0, (CGRectGetHeight(self.bounds)-_cellHeight)/2.0, 0.0)];
        
        _cellFont = font;
        _cellHeight = cellHeight;
        _cellAlign = align;
        
        if(arrayValues)
            _arrValues = [arrayValues copy];
    }
    return self;
}


//Dehighlight the last cell
- (void)dehighlightLastCell {
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self setTagLastSelected:-1];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

//Highlight a cell
- (void)highlightCellWithIndexPathRow:(NSUInteger)indexPathRow {
    [self setTagLastSelected:indexPathRow];
    NSArray *paths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:_tagLastSelected inSection:0], nil];
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}


@end


@interface LRPicker()

@property (nonatomic,strong) NSMutableArray *marr_data;
@property (nonatomic,strong) NSMutableArray *marr_frame;
@property (nonatomic,strong) NSMutableArray *marr_enabled;
@property (nonatomic,strong) NSMutableArray *marr_colon;

@property (nonatomic,assign) CGFloat cellHeight;
@property (nonatomic,strong) UIFont *cellFont;

@end

@implementation LRPicker

NSString * const LRPickerOptionSelectedColor    = @"LRPickerOptionSelectedColor";               //选中颜色
NSString * const LRPickerOptionUnSelectedColor  = @"LRPickerOptionUnSelectedColor";               //未选中颜色
NSString * const LRPickerOptionColonFont        = @"LRPickerOptionColonFont";               //单元格字体
NSString * const LRPickerOptionColonHeight      = @"LRPickerOptionColonHeight";               //单元格高

- (id)initWithFrame:(CGRect)frame withDataArray:(NSArray *)arr_data withFrameArray:(NSArray *)arr_frame withScrollEnabledArray:(NSArray *)arr_enabled withOptions:(NSDictionary *)options{

    self = [super initWithFrame:frame];
    if (self) {
        _marr_data          = [NSMutableArray array];
        _marr_frame         = [NSMutableArray array];
        _marr_enabled       = [NSMutableArray array];
        _marr_colon         = [NSMutableArray array];
        _color_unSelected   = [UIColor whiteColor];
        _color_selected     = [UIColor blueColor];
        if (arr_data) {
            [_marr_data addObjectsFromArray:arr_data];
        }
        
        if (arr_frame) {
            [_marr_frame addObjectsFromArray:arr_frame];
        }
        
        if (arr_enabled) {
            [_marr_enabled addObjectsFromArray:arr_enabled];
        }
        
        
        if (options) {
            for (NSString *key in options) {
                if ([key isEqualToString:LRPickerOptionSelectedColor]) {
                    _color_selected = (UIColor *)options[key];
                } else if ([key isEqualToString:LRPickerOptionUnSelectedColor]) {
                    _color_unSelected = (UIColor *)options[key];
                } else if ([key isEqualToString:LRPickerOptionColonFont]) {
                    _cellFont = (UIFont *)options[key];
                } else if ([key isEqualToString:LRPickerOptionColonHeight]) {
                    _cellHeight = [options[key] floatValue];
                }
            }
        }
        
        
        [self buildControl];
    }
    return self;

}


#pragma mark - public methods

- (void)setDefaultData:(NSArray *)data{

    for (int i = 0; i < [data count]; i++) {
        LRPickerColon *colon = _marr_colon[i];
        [colon dehighlightLastCell];
        
        NSInteger index = 0;
        
        for (NSString *t_data in colon.arrValues) {
            if ([t_data isEqualToString:data[i]]) {
                index = [colon.arrValues indexOfObject:t_data];
                
                [self centerCellWithIndexPathRow:index forScrollView:colon];
            }
        }
    }
    
}

- (NSArray *)getSelectedData{
    
    NSMutableArray * t_marr = [NSMutableArray array];

    for (int i = 0; i < [_marr_colon count] ; i++) {
        LRPickerColon *colon = _marr_colon[i];
        id objt = [colon.arrValues objectAtIndex:colon.tagLastSelected];
        [t_marr addObject:objt];
    }
    
    return t_marr;
}


#pragma mark - private methods 

- (void)buildControl {
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, CGRectGetHeight(self.bounds))];
    [pickerView setBackgroundColor:self.backgroundColor];

    for (int i = 0; i < [_marr_data count]; i++) {
        CGRect frame = [(NSValue *)_marr_frame[i] CGRectValue];
        
        LRPickerColon * colon = [[LRPickerColon alloc] initWithFrame:frame andValues:_marr_data[i] withFont:_cellFont withTextAlign:NSTextAlignmentCenter withCellHeight:_cellHeight];
        colon.backgroundColor = [UIColor clearColor];
        colon.scrollEnabled = [(NSNumber *)_marr_enabled[i] boolValue];
        [colon setDelegate:self];
        [colon setDataSource:self];
        [pickerView addSubview:colon];
        [_marr_colon addObject:colon];
    }
    
    [self addSubview:pickerView];
    
    UIImage *image_left = [UIImage imageNamed:@"picker_left"];
    UIImageView *imageV_left = [[UIImageView alloc] initWithImage:image_left];
    imageV_left.frame = CGRectMake(0, 0, image_left.size.width, image_left.size.height);
    imageV_left.center = CGPointMake(CGRectGetWidth(imageV_left.bounds)/2, CGRectGetHeight(self.bounds)/2.0);
    [self addSubview:imageV_left];
    
    UIImage *image_right = [UIImage imageNamed:@"picker_right"];
    UIImageView *imageV_rigth = [[UIImageView alloc] initWithImage:image_right];
    imageV_rigth.frame = CGRectMake(0, 0, image_right.size.width, image_right.size.height);
    imageV_rigth.center = CGPointMake([[UIScreen mainScreen] bounds].size.width - CGRectGetWidth(imageV_rigth.frame)/2.0, CGRectGetHeight(self.bounds)/2.0);
    [self addSubview:imageV_rigth];
    
    
    [self setUserInteractionEnabled:YES];

}


- (void)centerValueForScrollView:(LRPickerColon *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)_cellHeight;
    float newValue = (mod >= _cellHeight/2.0) ? offset+(_cellHeight-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/_cellHeight);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}


- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(LRPickerColon *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*_cellHeight;
    
    //Re-add the contentInset and set the new offset
    newOffset -= (CGRectGetHeight(self.bounds)-_cellHeight)/2.0;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:1.0f] forKey:kCATransactionAnimationDuration];
    [CATransaction setCompletionBlock:^{
        
        //Highlight the cell
        [scrollView highlightCellWithIndexPathRow:indexPathRow];
        
    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    [CATransaction commit];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        
        [(LRPickerColon *)scrollView setScrolling:NO];
        [self centerValueForScrollView:(LRPickerColon *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [(LRPickerColon *)scrollView setScrolling:NO];
    [self centerValueForScrollView:(LRPickerColon *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    LRPickerColon *colon = (LRPickerColon *)scrollView;
    [colon setScrolling:YES];
    [colon dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LRPickerColon *colon = (LRPickerColon *)tableView;
    return [colon.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    LRPickerColon *colon = (LRPickerColon *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:colon.cellFont];
        [cell.textLabel setTextAlignment:colon.cellAlign];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setTextColor:(indexPath.row == colon.tagLastSelected) ? _color_selected : _color_unSelected];
    [cell.textLabel setText:colon.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}


#pragma mark - drawRect

- (void)drawRect:(CGRect)rect {
    
}


@end
