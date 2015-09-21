//
//  NearbyHospitalVC.m
//  WifiTest
//
//  Created by Hcat on 15/9/21.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "NearbyHospitalVC.h"

@interface NearbyHospitalVC ()

@end

@implementation NearbyHospitalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附近医院";
    // Do any additional setup after loading the view from its nib.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}


#pragma mark - dealloc 

- (void)dealloc{
    NSLog(@"NearbyHospitalVC dealloc");

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
