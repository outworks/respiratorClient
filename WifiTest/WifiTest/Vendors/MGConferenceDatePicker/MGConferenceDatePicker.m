//
//  MGConferenceDatePicker.m
//  MGConferenceDatePicker
//
//  Created by Matteo Gobbi on 09/02/14.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGConferenceDatePicker.h"
#import "MGConferenceDatePickerDelegate.h"
#import <QuartzCore/QuartzCore.h>

//Check screen macros
#define IS_WIDESCREEN (fabs ( (double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 )
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

//Editable macros
#define TEXT_COLOR [UIColor colorWithWhite:0.5 alpha:1.0]
#define SELECTED_TEXT_COLOR [UIColor blackColor]
#define SAVE_AREA_COLOR [UIColor colorWithWhite:0.95 alpha:1.0]
#define BAR_SEL_COLOR UIColorFromRGB(0xe34241)
//#define BAR_SEL_COLOR [UIColor colorWithRed:76.0f/255.0f green:172.0f/255.0f blue:239.0f/255.0f alpha:0.8]

//Editable constants
static const float VALUE_HEIGHT = 45.0;
static const float SV_START_WIDTH = 10.0;
static const float SV_YEARS_WIDTH = 80.0;
static const float SV_MONTH_WIDTH = 60.0;
static const float SV_COLON_WIDTH = 45.0;
static const float SV_DATE_WIDTH = 60.0;

//Editable values
float PICKER_HEIGHT = 300.0;
NSString *FONT_NAME = @"HelveticaNeue";
NSString *NOW = @"Now";

//Static macros and constants
#define SELECTOR_ORIGIN (PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0)
#define BAR_SEL_ORIGIN_Y PICKER_HEIGHT/2.0-VALUE_HEIGHT/2.0
//static const NSInteger SCROLLVIEW_MOMENTS_TAG = 0;


//Custom scrollView
@interface MGPickerScrollView ()

@property (nonatomic, strong) NSArray *arrValues;
@property (nonatomic, strong) UIFont *cellFont;
@property (nonatomic, assign) NSTextAlignment cellAlign;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end


@implementation MGPickerScrollView

//Constants
const float LBL_BORDER_OFFSET = 8.0;

//Configure the tableView
- (id)initWithFrame:(CGRect)frame andValues:(NSArray *)arrayValues
      withTextAlign:(NSTextAlignment)align andTextSize:(float)txtSize {
    
    if(self = [super initWithFrame:frame]) {
        [self setScrollEnabled:YES];
        [self setShowsVerticalScrollIndicator:NO];
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setContentInset:UIEdgeInsetsMake(BAR_SEL_ORIGIN_Y, 0.0, BAR_SEL_ORIGIN_Y, 0.0)];
        
        _cellFont = [UIFont fontWithName:FONT_NAME size:txtSize];
        
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


//Custom Data Picker
@interface MGConferenceDatePicker ()

@property (nonatomic, strong) NSArray *arrYears;
@property (nonatomic, strong) NSArray *arrColon;
@property (nonatomic, strong) NSArray *arrMonths;
@property (nonatomic, strong) NSArray *arrColon1;
@property (nonatomic, strong) NSArray *arrDates;
@property (nonatomic, strong) NSArray *arrColon2;

@property (nonatomic, strong) MGPickerScrollView *svYears;
@property (nonatomic, strong) MGPickerScrollView *svColon;
@property (nonatomic, strong) MGPickerScrollView *svMonths;
@property (nonatomic, strong) MGPickerScrollView *svColon1;
@property (nonatomic, strong) MGPickerScrollView *svDates;
@property (nonatomic, strong) MGPickerScrollView *svColon2;


@end


@implementation MGConferenceDatePicker

- (id)initWithFrame:(CGRect)frame withYearArr:(NSMutableArray *)YearArr withMonthArr:(NSMutableArray *)MonthArr withDateArr:(NSMutableArray *)DateArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrYears = [NSArray arrayWithArray:YearArr];
        _arrMonths = [NSArray arrayWithArray:MonthArr];
        _arrDates = [NSArray arrayWithArray:DateArr];
        [self initialize];
        [self buildControl];
    }
    return self;
}


-(void)drawRect:(CGRect)rect {
    
}

- (void)initialize {
    //Set the height of picker if isn't an iPhone 5 or 5s
    [self checkScreenSize];
    
    //Create array Moments and create the dictionary MOMENT -> TIME
    
    _arrColon = @[@"年"];
    _arrColon1 = @[@"月"];
    _arrColon2 = @[@"日"];
    
    //Create array Hours
//    NSMutableArray *arrHours = [[NSMutableArray alloc] initWithCapacity:24];
//    for(int i=0; i<=23; i++) {
//        [arrHours addObject:[NSString stringWithFormat:@"%@%d",(i<10) ? @"0":@"", i]];
//    }
//    _arrHours = [NSArray arrayWithArray:arrHours];
//    
//    //Create array Minutes
//    NSMutableArray *arrMinutes = [[NSMutableArray alloc] initWithCapacity:60];
//    NSArray *t_arr = @[@"00",@"05",@"10",@"15",@"20",@"25",@"30",@"35",@"40",@"45",@"50",@"55"];
//    [arrMinutes addObjectsFromArray:t_arr];
//    _arrMinutes = [NSArray arrayWithArray:arrMinutes];

}


- (void)buildControl {
    //Create a view as base of the picker
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, PICKER_HEIGHT)];
    [pickerView setBackgroundColor:self.backgroundColor];
    
    //Create separators lines
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH, BAR_SEL_ORIGIN_Y, SV_YEARS_WIDTH, 2.0)];
    [line setBackgroundColor:BAR_SEL_COLOR];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH, BAR_SEL_ORIGIN_Y + VALUE_HEIGHT - 2.0, SV_YEARS_WIDTH, 2.0)];
    [line2 setBackgroundColor:BAR_SEL_COLOR];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH+SV_YEARS_WIDTH+SV_COLON_WIDTH, BAR_SEL_ORIGIN_Y, SV_MONTH_WIDTH, 2.0)];
    [line3 setBackgroundColor:BAR_SEL_COLOR];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH+SV_YEARS_WIDTH+SV_COLON_WIDTH, BAR_SEL_ORIGIN_Y + VALUE_HEIGHT - 2.0, SV_MONTH_WIDTH, 2.0)];
    [line4 setBackgroundColor:BAR_SEL_COLOR];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH+SV_YEARS_WIDTH+SV_COLON_WIDTH+SV_MONTH_WIDTH+SV_COLON_WIDTH, BAR_SEL_ORIGIN_Y, SV_DATE_WIDTH, 2.0)];
    [line5 setBackgroundColor:BAR_SEL_COLOR];
    
    UIView *line6 = [[UIView alloc] initWithFrame:CGRectMake(SV_START_WIDTH+SV_YEARS_WIDTH+SV_COLON_WIDTH+SV_MONTH_WIDTH+SV_COLON_WIDTH, BAR_SEL_ORIGIN_Y + VALUE_HEIGHT - 2.0, SV_DATE_WIDTH, 2.0)];
    [line6 setBackgroundColor:BAR_SEL_COLOR];
    
    
    
    //Create the second column (hours) of the picker
    _svYears = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(SV_START_WIDTH, 0.0, SV_YEARS_WIDTH, PICKER_HEIGHT) andValues:_arrYears withTextAlign:NSTextAlignmentCenter  andTextSize:20.0];
    _svYears.tag = 1;
    [_svYears setDelegate:self];
    [_svYears setDataSource:self];
    
    //Create the fourth column (meridians) of the picker
    _svColon = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svYears.frame.origin.x+SV_YEARS_WIDTH, 0.0, SV_COLON_WIDTH, PICKER_HEIGHT) andValues:_arrColon withTextAlign:NSTextAlignmentLeft andTextSize:15.0];
    //_svColon.backgroundColor = [UIColor blueColor];
    _svColon.tag = 2;
    _svColon.scrollEnabled = NO;
    [_svColon setDelegate:self];
    [_svColon setDataSource:self];
    
    //Create the third column (minutes) of the picker
    _svMonths = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svColon.frame.origin.x+SV_COLON_WIDTH-5, 0.0, SV_MONTH_WIDTH, PICKER_HEIGHT) andValues:_arrMonths withTextAlign:NSTextAlignmentCenter andTextSize:20.0];
    _svMonths.tag = 3;
    [_svMonths setDelegate:self];
    [_svMonths setDataSource:self];
    
    _svColon1 = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svMonths.frame.origin.x+SV_MONTH_WIDTH, 0.0, SV_COLON_WIDTH, PICKER_HEIGHT) andValues:_arrColon1 withTextAlign:NSTextAlignmentLeft andTextSize:15.0];
    //_svColon1.backgroundColor = [UIColor blueColor];
    _svColon1.tag = 4;
    _svColon1.scrollEnabled = NO;
    [_svColon1 setDelegate:self];
    [_svColon1 setDataSource:self];
    
    _svDates = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svColon1.frame.origin.x+SV_COLON_WIDTH-5, 0.0, SV_DATE_WIDTH, PICKER_HEIGHT) andValues:_arrDates withTextAlign:NSTextAlignmentCenter andTextSize:20.0];
    _svDates.tag = 5;
    //[_svDates setBackgroundColor:[UIColor redColor]];
    [_svDates setDelegate:self];
    [_svDates setDataSource:self];
    
    _svColon2 = [[MGPickerScrollView alloc] initWithFrame:CGRectMake(_svDates.frame.origin.x+SV_DATE_WIDTH, 0.0, SV_COLON_WIDTH, PICKER_HEIGHT) andValues:_arrColon2 withTextAlign:NSTextAlignmentLeft andTextSize:15.0];
    //_svColon2.backgroundColor = [UIColor blueColor];
    _svColon2.tag = 6;
    _svColon2.scrollEnabled = NO;
    [_svColon2 setDelegate:self];
    [_svColon2 setDataSource:self];
    
    
    //Layer gradient
    CAGradientLayer *gradientLayerTop = [CAGradientLayer layer];
    gradientLayerTop.frame = CGRectMake(0.0, 0.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerTop.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (id)self.backgroundColor.CGColor, nil];
    gradientLayerTop.startPoint = CGPointMake(0.0f, 0.7f);
    gradientLayerTop.endPoint = CGPointMake(0.0f, 0.0f);
    
    CAGradientLayer *gradientLayerBottom = [CAGradientLayer layer];
    gradientLayerBottom.frame = CGRectMake(0.0, PICKER_HEIGHT/2.0, pickerView.frame.size.width, PICKER_HEIGHT/2.0);
    gradientLayerBottom.colors = gradientLayerTop.colors;
    gradientLayerBottom.startPoint = CGPointMake(0.0f, 0.3f);
    gradientLayerBottom.endPoint = CGPointMake(0.0f, 1.0f);
    
    
    //Add pickerView
    [self addSubview:pickerView];
    
    //Add separator lines
    [pickerView addSubview:line];
    [pickerView addSubview:line2];
    [pickerView addSubview:line3];
    [pickerView addSubview:line4];
    [pickerView addSubview:line5];
    [pickerView addSubview:line6];
    
    //Add scrollViews
    [pickerView addSubview:_svYears];
    [pickerView addSubview:_svColon];
    [pickerView addSubview:_svMonths];
    [pickerView addSubview:_svColon1];
    [pickerView addSubview:_svDates];
    [pickerView addSubview:_svColon2];
    
    //Add gradients
    [pickerView.layer addSublayer:gradientLayerTop];
    [pickerView.layer addSublayer:gradientLayerBottom];
    
    
//    UIImageView *t_topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 1)];
//    //[t_topImage setImage:[UIImage imageNamed:@"bbjh_line2.png"]];
//    [t_topImage setBackgroundColor:UIColorFromRGB(0xb8b8b8)];
//    [pickerView addSubview:t_topImage];
    
    UIImageView *t_botomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(pickerView.frame)-1, ScreenWidth, 1)];
    //[t_botomImage setImage:[UIImage imageNamed:@"bbjh_line2.png"]];
    [t_botomImage setBackgroundColor:UIColorFromRGB(0xb8b8b8)];
    [pickerView addSubview:t_botomImage];
    
    
    [self setUserInteractionEnabled:YES];
}



#pragma mark - Other methods

//Center the value in the bar selector
- (void)centerValueForScrollView:(MGPickerScrollView *)scrollView {
    
    //Takes the actual offset
    float offset = scrollView.contentOffset.y;
    
    //Removes the contentInset and calculates the prcise value to center the nearest cell
    offset += scrollView.contentInset.top;
    int mod = (int)offset%(int)VALUE_HEIGHT;
    float newValue = (mod >= VALUE_HEIGHT/2.0) ? offset+(VALUE_HEIGHT-mod) : offset-mod;
    
    //Calculates the indexPath of the cell and set it in the object as property
    NSInteger indexPathRow = (int)(newValue/VALUE_HEIGHT);
    
    //Center the cell
    [self centerCellWithIndexPathRow:indexPathRow forScrollView:scrollView];
}

//Center phisically the cell
- (void)centerCellWithIndexPathRow:(NSUInteger)indexPathRow forScrollView:(MGPickerScrollView *)scrollView {
    
    if(indexPathRow >= [scrollView.arrValues count]) {
        indexPathRow = [scrollView.arrValues count]-1;
    }
    
    float newOffset = indexPathRow*VALUE_HEIGHT;
    
    //Re-add the contentInset and set the new offset
    newOffset -= BAR_SEL_ORIGIN_Y;
    
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        
        //Highlight the cell
        [scrollView highlightCellWithIndexPathRow:indexPathRow];
        
    }];
    
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
    
    [CATransaction commit];
}

//Set the time automatically
- (void)setTime:(NSString *)time {
    //Get the string
    NSString *strTime;
    strTime = (NSString *)time;
        
    
    //Split
    NSArray *comp = [strTime componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]];
    
    //Set the tableViews
    [_svYears dehighlightLastCell];
    [_svMonths dehighlightLastCell];
    [_svDates dehighlightLastCell];
    NSInteger t_yearIndex = 0;
    for (NSString *t_year in _arrYears) {
        if ([t_year isEqualToString:comp[0]]) {
            t_yearIndex = [_arrYears indexOfObject:t_year];
        }
    }
    
    NSInteger t_monthIndex = 0;
    for (NSString *t_month in _arrMonths) {
        if ([t_month isEqualToString:comp[1]]) {
            t_monthIndex = [_arrMonths indexOfObject:t_month];
        }
    }
    
    NSInteger t_dateIndex = 0;
    for (NSString *t_date in _arrMonths) {
        if ([t_date isEqualToString:comp[2]]) {
            t_dateIndex = [_arrMonths indexOfObject:t_date];
        }
    }
    
    //Center the other fields
    [self centerCellWithIndexPathRow:t_yearIndex forScrollView:_svYears];
    [self centerCellWithIndexPathRow:t_monthIndex forScrollView:_svMonths];
     [self centerCellWithIndexPathRow:t_dateIndex forScrollView:_svDates];
    
    
}


//Check the screen size
- (void)checkScreenSize {
//    if(IS_WIDESCREEN) {
//        PICKER_HEIGHT = 300.0;
//    } else {
//        PICKER_HEIGHT = 130.0;
//    }
    PICKER_HEIGHT = self.bounds.size.height;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (![scrollView isDragging]) {
        NSLog(@"didEndDragging");
        [(MGPickerScrollView *)scrollView setScrolling:NO];
        [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"didEndDecelerating");
    [(MGPickerScrollView *)scrollView setScrolling:NO];
    [self centerValueForScrollView:(MGPickerScrollView *)scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    MGPickerScrollView *sv = (MGPickerScrollView *)scrollView;
    [sv setScrolling:YES];
    [sv dehighlightLastCell];
}

#pragma - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    return [sv.arrValues count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"reusableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    MGPickerScrollView *sv = (MGPickerScrollView *)tableView;
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setFont:sv.cellFont];
        [cell.textLabel setTextAlignment:sv.cellAlign];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell.textLabel setTextColor:(indexPath.row == sv.tagLastSelected) ? SELECTED_TEXT_COLOR : TEXT_COLOR];
    [cell.textLabel setText:sv.arrValues[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return VALUE_HEIGHT;
}

- (NSString *)getSelectedDate{
    
    return [NSString stringWithFormat:@"%@-%@-%@",[_arrYears objectAtIndex:_svYears.tagLastSelected],[_arrMonths objectAtIndex:_svMonths.tagLastSelected],[_arrDates objectAtIndex:_svDates.tagLastSelected]];
}

@end
