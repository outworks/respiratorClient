//
//  UserAgeVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserAgeVC.h"
#import "LRPicker.h"
#import "UserHeightVC.h"


@interface UserAgeVC ()

@property (nonatomic,strong) LRPicker *picker;

@property (weak, nonatomic) IBOutlet UIButton *btn_before;
@property (weak, nonatomic) IBOutlet UIButton *btn_after;


@end

@implementation UserAgeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"年龄";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark privateMethods

- (void)initUI{

    NSMutableArray *t_hour = [NSMutableArray array];
    NSArray *year = @[@"年"];
    NSMutableArray *t_min  = [NSMutableArray array];
    NSArray *month = @[@"月"];
    
    for (int i = 1800; i < 2100; i++) {
        [t_hour addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    for (int i = 1; i<13; i++) {
        [t_min addObject:[NSString stringWithFormat:@"%@%d",(i < 10)?@"0":@"",i]];
    }
    
    NSArray *arr_data       = @[t_hour,year,t_min,month];
    NSArray *arr_enbaled    = @[@(YES),@(NO),@(YES),@(NO)];
    
    NSValue *value_hour     = [NSValue valueWithCGRect:CGRectMake(20, 0, 90, 200)];
    NSValue *value_year     = [NSValue valueWithCGRect:CGRectMake(110, 0, 60, 200)];
    NSValue *value_min      = [NSValue valueWithCGRect:CGRectMake(170, 0, 60, 200)];
    NSValue *value_month    = [NSValue valueWithCGRect:CGRectMake(240, 0, 60, 200)];
    
    NSArray *arr_frame      = @[value_hour,value_year,value_min,value_month];
    
    _picker = [[LRPicker alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 200) withDataArray:arr_data withFrameArray:arr_frame withScrollEnabledArray:arr_enbaled withOptions:@{
                                                                                                                                                                                                        LRPickerOptionColonFont:[UIFont systemFontOfSize:27.f],
                                                                                                                                                                                                        LRPickerOptionColonHeight:@(40.f),
                                                                                                                                                                                                        LRPickerOptionSelectedColor:UIColorFromRGB(0x3EBACA),
                                                                                                                                                                                                        LRPickerOptionUnSelectedColor:[UIColor lightGrayColor]                                                                                                         }];
    _picker.backgroundColor = [UIColor clearColor];
    
    NSArray *arr_default = @[@"1900",@"年",@"01",@"月"];
    [_picker setDefaultData:arr_default];
    
    [self.view addSubview:_picker];
    
    
    
    UIImage *image_t = [UIImage imageNamed:@"icon_segment_righ_2"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/4, image_t.size.height/2, image_t.size.width*3/4);
    [_btn_before setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    UIImage *image_t2 = [UIImage imageNamed:@"icon_segment_right_h_2"];
    [_btn_before setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    [_btn_before setBackgroundImage:[image_t2 resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];
    
    image_t = [UIImage imageNamed:@"icon_segment_left"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width*3/4, image_t.size.height/2, image_t.size.width/4);
    [_btn_after setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    image_t2 = [UIImage imageNamed:@"icon_segment_left_h"];
    [_btn_after setBackgroundImage:[image_t2 resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];
    
}

#pragma mark -
#pragma mark buttonAction

- (IBAction)afterAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)beforeAction:(id)sender {
    
    NSArray *arr_data = [_picker getSelectedData];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
    
    _member.age = @([locationString longLongValue] - [(NSString *)arr_data[0] longLongValue]);;
    UserHeightVC *t_vc = [[UserHeightVC alloc] init];
    t_vc.member = _member;
    t_vc.isRegiest = _isRegiest;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc{

    NSLog(@"UserAgeVC dealloc");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
