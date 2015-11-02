//
//  UserWeightVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserWeightVC.h"
#import "LRPicker.h"
#import "SetVC.h"
#import "RegiestSuccessVC.h"
#import "MemberAPI.h"

@interface UserWeightVC (){
    ShowHUD *_hud;
}

@property (nonatomic,strong) LRPicker *picker;

@property (weak, nonatomic) IBOutlet UIButton *btn_before;
@property (weak, nonatomic) IBOutlet UIButton *btn_after;


@end

@implementation UserWeightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"体重";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark privateMethods

- (void)initUI{
    
    NSMutableArray *t_weight = [NSMutableArray array];
    NSArray *tip = @[@"公斤"];
    
    for (int i = 0; i<250; i++) {
        [t_weight addObject:[NSString stringWithFormat:@"%@%d",(i < 10)?@"0":@"",i]];
    }
    
    NSArray *arr_data       = @[t_weight,tip];
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
    
    NSArray *arr_default = @[@"70",@"公斤"];
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


-(void)updateUserInfo{
    
    __weak __typeof(*&self) weakSelf = self;
    
    MemberUpdateRequest *request = [[MemberUpdateRequest alloc] init];
    request.mid = _member.mid;
    request.sex = _member.sex;
    request.nickname = _member.nickname;
    request.weight = _member.weight;
    request.height = _member.height;
    request.age = _member.age;
    
    _hud = [ShowHUD showText:@"请求中" configParameter:^(ShowHUD *config) {
    } inView:ApplicationDelegate.window];
    
    
    [MemberAPI MemberUpdateWithRequest:request completionBlockWithSuccess:^(Member *data) {
        if (_hud) {
            [_hud hide];
        }
        
        [ShowHUD showSuccess:@"提交成功" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:ApplicationDelegate.window];
        
        _member = data;
        [ShareValue sharedShareValue].member = _member;
        
        if (_isRegiest) {
            RegiestSuccessVC *t_vc = [[RegiestSuccessVC alloc] init];
            [weakSelf.navigationController pushViewController:t_vc animated:YES];
        }else{
            for (UIViewController *t_vc in self.navigationController.viewControllers) {
                if ([t_vc isKindOfClass:[self.navigationController.viewControllers[self.navigationController.viewControllers.count-6] class]]) {
                    [weakSelf.navigationController popToViewController:t_vc animated:YES];
                    return;
                }

            }
        }
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];
    
}




#pragma mark -
#pragma mark buttonAction

- (IBAction)afterAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)beforeAction:(id)sender {
    
    NSArray *arr_data = [_picker getSelectedData];
    
    _member.weight =@([(NSString *)arr_data[0] integerValue] * 2 );
    
    [self updateUserInfo];
    
}


#pragma mark -
#pragma mark dealloc

- (void)dealloc{

    NSLog(@"UserWeightVC dealloc");
    
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
