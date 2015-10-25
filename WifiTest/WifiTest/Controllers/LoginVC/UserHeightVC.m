//
//  UserHeightVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserHeightVC.h"
#import "UserWeightVC.h"
#import "LRPicker.h"

@interface UserHeightVC ()

@property (nonatomic,strong) LRPicker *picker;

@property (weak, nonatomic) IBOutlet UIButton *btn_before;
@property (weak, nonatomic) IBOutlet UIButton *btn_after;

@end

@implementation UserHeightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"身高";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -
#pragma mark privateMethods

- (void)initUI{

    NSMutableArray *t_height = [NSMutableArray array];
    NSArray *tip = @[@"公分"];
    
    for (int i = 0; i<250; i++) {
        [t_height addObject:[NSString stringWithFormat:@"%@%d",(i < 10)?@"0":@"",i]];
    }
    
    NSArray *arr_data       = @[t_height,tip];
    NSArray *arr_enbaled    = @[@(YES),@(NO)];
    
    NSValue *value_height     = [NSValue valueWithCGRect:CGRectMake((ScreenWidth)/2-80, 0, 80, 200)];
    NSValue *value_tip     = [NSValue valueWithCGRect:CGRectMake((ScreenWidth)/2, 0, 90, 200)];
   
    
    NSArray *arr_frame      = @[value_height,value_tip];
    
    _picker = [[LRPicker alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 200) withDataArray:arr_data withFrameArray:arr_frame withScrollEnabledArray:arr_enbaled withOptions:@{
                                                                                                                                                                                                        LRPickerOptionColonFont:[UIFont systemFontOfSize:27.f],
                                                                                                                                                                                                        LRPickerOptionColonHeight:@(40.f),
                                                                                                                                                                                                        LRPickerOptionSelectedColor:UIColorFromRGB(0x3EBACA),
                                                                                                                                                                                                        LRPickerOptionUnSelectedColor:[UIColor lightGrayColor]                                                                                                         }];
    _picker.backgroundColor = [UIColor clearColor];
    
    NSArray *arr_default = @[@"170",@"公分"];
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
    
    _member.height =@([(NSString *)arr_data[0] integerValue]);
    
    UserWeightVC * t_vc = [[UserWeightVC alloc] init];
    t_vc.member = _member;
    t_vc.isRegiest = _isRegiest;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}



#pragma mark -
#pragma mark dealloc

- (void)dealloc{

    NSLog(@"UserHeightVC dealloc");
    
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
