//
//  UserSetVC.m
//  WifiTest
//
//  Created by nd on 15/6/25.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "UserSetVC.h"
#import "ShareValue.h"

@interface UserSetVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_height;
@property (weak, nonatomic) IBOutlet UITextField *tf_weight;

@property (weak, nonatomic) IBOutlet UIButton *btn_boy;
@property (weak, nonatomic) IBOutlet UIButton *btn_girl;

@property (weak, nonatomic) IBOutlet UITextField *tf_date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property(nonatomic,strong) NSString *birthDay;

@end

@implementation UserSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户信息";
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    _tf_date.text = [UserSetVC convertStringFromDate:self.datePicker.date];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private

-(void)updateUserInfo{
    MemberUpdateRequest *request = [[MemberUpdateRequest alloc] init];
    request.mid = _member.mid;
    if (_btn_boy.selected) {
        request.sex = @0;
    }else if(_btn_girl.selected){
        request.sex = @1;
    }
    request.weight = @([_tf_weight.text longLongValue]);
    request.height = @([_tf_height.text longLongValue]);
    request.birthday = _tf_date.text;
    [MemberAPI MemberUpdateWithRequest:request completionBlockWithSuccess:^(Member *data) {
        
        _member = data;
        [ShareValue sharedShareValue].member = _member;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } Fail:^(int code, NSString *failDescript) {
        
    }];


}

- (IBAction)dateChanged:(UIDatePicker *)sender {
    NSDate *date = sender.date;
    _tf_date.text = [UserSetVC convertStringFromDate:date];
}


+(NSString*) convertStringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}


#pragma mark - buttonAciton

- (IBAction)btnBoyAction:(id)sender {
    _btn_boy.selected = !_btn_boy.selected;
    if (_btn_boy.selected) {
        _btn_girl.selected = NO;
    }
    
}

- (IBAction)btnGirlAciton:(id)sender {
    _btn_girl.selected = !_btn_girl.selected;
    if (_btn_girl.selected) {
        _btn_boy.selected = NO;
    }
}

- (IBAction)OKAction:(id)sender {
    
    if (!_btn_girl.selected && !_btn_boy.selected) {
        [ShowHUD showError:@"请选择性别" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (_tf_height.text.length == 0) {
        [ShowHUD showError:@"请输入身高" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    if (_tf_weight.text.length == 0) {
        [ShowHUD showError:@"请输入体重" configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
        return;
    }
    
    [self updateUserInfo];
}



#pragma mark - dealloc 

-(void)dealloc{
    
    NSLog(@"UserSetVC dealloc");
    
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
