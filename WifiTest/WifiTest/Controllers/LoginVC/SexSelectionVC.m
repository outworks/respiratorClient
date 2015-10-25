//
//  SexSelectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/1.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SexSelectionVC.h"
#import "UserAgeVC.h"

typedef NS_ENUM(NSUInteger, SexType) {
    SexTypeWoman = 0,
    SexTypeMan = 1,
};

@interface SexSelectionVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_woman;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_man;
@property (weak, nonatomic) IBOutlet UILabel *lb_woman;
@property (weak, nonatomic) IBOutlet UILabel *lb_man;
@property (nonatomic,assign) SexType sexType;

@property (weak, nonatomic) IBOutlet UIButton *btn_after;
@property (weak, nonatomic) IBOutlet UIButton *btn_before;



@end

@implementation SexSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"性别";

    [self initUI];
    [self SexChange:_sexType];
    
    if (_member) {
        if ([_member.sex integerValue] == 0) {
            _sexType = SexTypeMan;
            [self SexChange:_sexType];
            
        }else{
            _sexType = SexTypeWoman;
            [self SexChange:_sexType];
        }
    }
}

#pragma mark -
#pragma mark - privateMethods


- (void)initUI{

    _lb_woman.layer.cornerRadius = _lb_woman.frame.size.height/2;
    _lb_woman.layer.masksToBounds = YES;
    
    _lb_man.layer.cornerRadius = _lb_man.frame.size.height/2;
    _lb_man.layer.masksToBounds = YES;
    

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

- (void)SexChange:(SexType) sexType{
    if (_sexType == SexTypeMan) {
        
        [_imageV_man setImage:[UIImage imageNamed:@"icon_man_h"]];
        [_imageV_woman setImage:[UIImage imageNamed:@"icon_woman"]];
        [_lb_man setBackgroundColor:RGB(74, 109, 168)];
        [_lb_woman setBackgroundColor:RGB(81, 86, 90)];
        
    }else if(_sexType == SexTypeWoman){
        
        [_imageV_man setImage:[UIImage imageNamed:@"icon_man"]];
        [_imageV_woman setImage:[UIImage imageNamed:@"icon_woman_h"]];
        [_lb_man setBackgroundColor:RGB(81, 86, 90)];
        [_lb_woman setBackgroundColor:RGB(252, 129, 134)];
    }
    

}


#pragma mark - buttonAction 

- (IBAction)btnBoyAction:(id)sender {
    _sexType = SexTypeMan;
    [self SexChange:_sexType];
}

- (IBAction)btnGirlAction:(id)sender {
    _sexType = SexTypeWoman;
    [self SexChange:_sexType];
}

- (IBAction)afterAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)beforeAction:(id)sender {
    
    if (_sexType == SexTypeMan) {
        _member.sex = @0;
    }else if(_sexType == SexTypeWoman){
        _member.sex = @1;
    }
    
    UserAgeVC *t_vc = [[UserAgeVC alloc] init];
    t_vc.member = _member;
    t_vc.isRegiest = _isRegiest;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - dealloc 

-(void)dealloc{

    NSLog(@"SexSelectionVC dealloc");

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
