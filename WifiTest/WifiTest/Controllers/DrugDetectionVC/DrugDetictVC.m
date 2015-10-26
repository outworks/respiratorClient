//
//  DrugDetictVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugDetictVC.h"
#import "DrugDetailVC.h"
#import "DurgMeasureVC.h"

@interface DrugDetictVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_durg;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_drug;
@property (weak, nonatomic) IBOutlet UIButton *btn_drugDetail;
@property (weak, nonatomic) IBOutlet UIButton *btn_start;
@property (weak, nonatomic) IBOutlet UILabel *lb_drugDetail;


@end

@implementation DrugDetictVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用药物";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark privateMethods

- (void)initUI{

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(110, 85, 120),NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:21.0]}];
    
    UIImage *image_t = [UIImage imageNamed:@"image_gray"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
    [_imageV_drug setImage:[image_t resizableImageWithCapInsets:inset]];
    [_tf_durg setValue:[UIColor colorWithWhite:1.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    image_t = [UIImage imageNamed:@"icon_drug_start"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_start setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
    image_t = [UIImage imageNamed:@"icon_drug"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_drugDetail setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];

    image_t = [UIImage imageNamed:@"icon_drug_start_h"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_drugDetail setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];
    
}

#pragma mark -
#pragma mark ButtonAction

//返回
- (void)backAction{
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
}

- (IBAction)drugDetailAction:(id)sender {
    
    if (_tf_durg.text.length == 0) {
        _tf_durg.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_drug setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_drugDetail setText:@"请输入药物名称"];
        return;

    }
    
    DrugDetailVC *t_vc = [[DrugDetailVC alloc] init];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    [ApplicationDelegate.nav presentViewController:t_nav animated:YES completion:^{
        
    }];
    
}


- (IBAction)StartAction:(id)sender {
    
    if (_tf_durg.text.length == 0) {
        
        _tf_durg.textColor = UIColorFromRGB(0xfb7581);
        UIImage *image_t = [UIImage imageNamed:@"image_red"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_drug setImage:[image_t resizableImageWithCapInsets:inset]];
        [_lb_drugDetail setText:@"请输入药物名称"];
        return;
        
    }
    
    DurgMeasureVC *t_vc = [[DurgMeasureVC alloc] init];
    t_vc.drugName = _tf_durg.text;
    [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == _tf_durg) {
        _lb_drugDetail.text = @"";
        _tf_durg.textColor = RGB(110, 85, 120);
        UIImage *image_t = [UIImage imageNamed:@"icon_drug_bg"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_drug setImage:[image_t resizableImageWithCapInsets:inset]];
        
        image_t = [UIImage imageNamed:@"icon_drug_h"];
        inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_btn_drugDetail setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
        [_btn_drugDetail setTitleColor:RGB(110, 85, 120) forState:UIControlStateNormal];
        
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _tf_durg) {
        _tf_durg.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        UIImage *image_t = [UIImage imageNamed:@"image_gray"];
        UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_imageV_drug setImage:[image_t resizableImageWithCapInsets:inset]];
        
        image_t = [UIImage imageNamed:@"icon_drug"];
        inset = UIEdgeInsetsMake(image_t.size.height-2, image_t.size.width/2, image_t.size.height, image_t.size.width/2);
        [_btn_drugDetail setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
        [_btn_drugDetail setTitleColor:RGB(82, 87, 91) forState:UIControlStateNormal];
        
    }
    
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 
#pragma mark dealloc

- (void)dealloc{

    NSLog(@"DrugDetictVC dealloc");
    
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
