//
//  MainVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "MainVC.h"

#import "BreathVC.h"
#import "AirQualityVC.h"
#import "NearbyPharVC.h"
#import "NearbyHospitalVC.h"
#import "SetVC.h"

#import "DataTools.h"

#import "MotionDetectionVC.h"
#import "DrugDetictVC.h"
#import "DailyDetectionVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    [_vc_tab setSelectedIndex:0];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - initTabBar

//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

-(void)initTabBar{
    if (self.vc_tab ) {
        [_vc_tab.view removeFromSuperview];
        self.vc_tab = nil;
    }
    
    self.vc_tab = [[UITabBarController alloc] init];
    
    UIView *bgView = [[UIView alloc] initWithFrame:_vc_tab.tabBar.bounds];
    bgView.backgroundColor = UIColorFromRGBA(0x1d2124,0.95f);
    [_vc_tab.tabBar insertSubview:bgView atIndex:0];
    UIImage* tabBarBackground = [UIImage imageNamed:@"菜单栏"];
    UIImageView *imageV_tabBarBg = [[UIImageView alloc] initWithImage:tabBarBackground];
    [imageV_tabBarBg setFrame:bgView.bounds];
    [bgView addSubview:imageV_tabBarBg];
    [_vc_tab.tabBar setBackgroundImage:tabBarBackground];
    _vc_tab.tabBar.opaque = YES;
    
    [_vc_tab.view setFrame:self.view.frame];
    [_vc_tab.tabBar setTranslucent:NO];
    [_vc_tab setDelegate:(id<UITabBarControllerDelegate>)self];
    [self.view addSubview:_vc_tab.view];
    
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeBottom attr2: NSLayoutAttributeBottom constant:0];
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeTrailing attr2:NSLayoutAttributeTrailing constant:0];
    
    UINavigationController *nav_breath;
    
    if (_contentType == DailyType) {
        DailyDetectionVC *breathVC  = [[DailyDetectionVC alloc] init];
        nav_breath                  = [[UINavigationController alloc]initWithRootViewController:breathVC];
    }else if (_contentType == MotionType){
        MotionDetectionVC *breathVC = [[MotionDetectionVC alloc] init];
        nav_breath                  = [[UINavigationController alloc]initWithRootViewController:breathVC];
    }else if (_contentType == MedicationType){
        DrugDetictVC *breathVC   = [[DrugDetictVC alloc] init];
        nav_breath                  = [[UINavigationController alloc]initWithRootViewController:breathVC];
    }
    AirQualityVC *airQualityVC          = [[AirQualityVC alloc] init];
    NearbyPharVC *nearbyPharVC          = [[NearbyPharVC alloc] init];
    NearbyHospitalVC *nearbyHospitalVC  = [[NearbyHospitalVC alloc] init];
    SetVC *setVC                        = [[SetVC alloc] init];
    
    
    
    UINavigationController *nav_airQuality      = [[UINavigationController  alloc]initWithRootViewController:airQualityVC];
    UINavigationController *nav_nearbyPhar      = [[UINavigationController alloc]initWithRootViewController:nearbyPharVC];
    UINavigationController *nav_nearbyHospital  = [[UINavigationController alloc]initWithRootViewController:nearbyHospitalVC];
    UINavigationController *nav_set             = [[UINavigationController alloc]initWithRootViewController:setVC];
    
    _vc_tab.viewControllers = @[nav_breath, nav_airQuality, nav_nearbyPhar,nav_nearbyHospital,nav_set];
    
    NSArray *ar = _vc_tab.viewControllers;
    NSMutableArray *arr_t = [NSMutableArray new];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
     {
         UITabBarItem *item = nil;
         switch (idx)
         {
             case 0:
             {
                 UIImage *image_normal = [[UIImage imageNamed:@"底部图标-呼吸量测-默认.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 UIImage *image_selected = [[UIImage imageNamed:@"底部图标-呼吸量测-选中.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 item = [[UITabBarItem alloc] initWithTitle:@"呼吸量测" image:image_normal selectedImage:image_selected];
                 
                 break;
             }
             case 1:
             {
                 
                 UIImage *image_normal = [[UIImage imageNamed:@"底部图标-空气质量-默认"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 UIImage *image_selected = [[UIImage imageNamed:@"底部图标-空气质量-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 item = [[UITabBarItem alloc] initWithTitle:@"空气质量" image:image_normal selectedImage:image_selected];
                 
                 break;
             }
             case 2:
             {
                 UIImage *image_normal = [[UIImage imageNamed:@"底部图标-附近药局-默认"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 UIImage *image_selected = [[UIImage imageNamed:@"底部图标-附近药局-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 item = [[UITabBarItem alloc] initWithTitle:@"附近药局" image:image_normal selectedImage:image_selected];
                 
                 break;
             }
             case 3:
             {
                 UIImage *image_normal = [[UIImage imageNamed:@"底部图标-附近医院-默认"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 UIImage *image_selected = [[UIImage imageNamed:@"底部图标-附近医院-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 item = [[UITabBarItem alloc] initWithTitle:@"附近医院" image:image_normal selectedImage:image_selected];
                 
                 break;
             }
             case 4:
             {
                 UIImage *image_normal = [[UIImage imageNamed:@"底部图标-系统设置-默认"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 UIImage *image_selected = [[UIImage imageNamed:@"底部图标-系统设置-选中"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                 item = [[UITabBarItem alloc] initWithTitle:@"系统设置" image:image_normal selectedImage:image_selected];
                 
                 break;
             }
         }
         
         [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       UIColorFromRGB(0x50c0c3), UITextAttributeTextColor,
                                       nil] forState:UIControlStateHighlighted];
         [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor whiteColor], UITextAttributeTextColor,
                                       nil] forState:UIControlStateNormal];
         
         viewController.tabBarItem = item;
         [arr_t addObject:viewController];
     }];
    _vc_tab.viewControllers = arr_t;
    
}


#pragma mark - UITabBarController

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    
    
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
        //self.navigationItem.leftBarButtonItem = nil;
        
    }
    
}

#pragma mark - dealloc

-(void)dealloc{
    NSLog(@"MainVC dealloc");
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
