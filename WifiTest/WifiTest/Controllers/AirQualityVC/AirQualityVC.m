//
//  AirQualityVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "AirQualityVC.h"
#import "ShareFun.h"

@interface AirQualityVC ()

@property(nonatomic,strong)  BlueClientVC *blueClient;

@end

@implementation AirQualityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"空气质量";
    
//    _blueClient = [[BlueClientVC alloc] init];
//    _blueClient.view.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:_blueClient.view];
//    
//    [ShareFun setEdge:self.view view:_blueClient.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
//    [ShareFun setEdge:self.view view:_blueClient.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
//    [ShareFun setEdge:self.view view:_blueClient.view attr1:NSLayoutAttributeBottom attr2:NSLayoutAttributeBottom constant:0];
//    [ShareFun setEdge:self.view view:_blueClient.view attr1:NSLayoutAttributeTrailing attr2:NSLayoutAttributeTrailing constant:0];
    
    
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - dealloc

-(void)dealloc{
    
    
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
