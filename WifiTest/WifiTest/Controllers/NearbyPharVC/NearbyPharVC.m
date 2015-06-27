//
//  NearbyPharVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "NearbyPharVC.h"

@interface NearbyPharVC ()

@end

@implementation NearbyPharVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附近药局";
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
