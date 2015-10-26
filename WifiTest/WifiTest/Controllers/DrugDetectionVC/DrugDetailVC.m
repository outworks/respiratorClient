//
//  DrugDetailVC.m
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugDetailVC.h"


@interface DrugDetailVC ()

@property (weak, nonatomic) IBOutlet UITextView *tf_drugDetail;

@property (weak, nonatomic) IBOutlet UIButton *btn_queding;

@end

@implementation DrugDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"药物资讯";
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -
#pragma mark privateMethods

- (void)initUI{

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(110, 85, 120),NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:21.0]}];
    
    UIImage * image_t = [UIImage imageNamed:@"icon_drug_start"];
    UIEdgeInsets inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    
    
    [_btn_queding setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    
    image_t = [UIImage imageNamed:@"icon_drug_start_h"];
    inset = UIEdgeInsetsMake(image_t.size.height/2, image_t.size.width/2, image_t.size.height/2, image_t.size.width/2);
    [_btn_queding setBackgroundImage:[image_t resizableImageWithCapInsets:inset] forState:UIControlStateHighlighted];

    

}


#pragma mark -
#pragma mark buttonAction

- (IBAction)quedingAction:(id)sender {
    
    [ApplicationDelegate.nav dismissViewControllerAnimated:YES completion:^{
    }];
    
}

#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationItem setHidesBackButton:YES];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc{


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
