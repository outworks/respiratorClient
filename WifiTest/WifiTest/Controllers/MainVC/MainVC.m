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
#import "SetVC.h"

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
    self.vc_tab = [[UITabBarController alloc] init];
    [_vc_tab.tabBar setBackgroundColor:UIColorFromRGB(0xefefe)];
    [_vc_tab.view setFrame:self.view.frame];
    [_vc_tab.tabBar setTranslucent:NO];
    [_vc_tab setDelegate:(id<UITabBarControllerDelegate>)self];
    [self.view addSubview:_vc_tab.view];
    
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeBottom attr2: NSLayoutAttributeBottom constant:0];
    [self setEdge:self.view view:_vc_tab.view attr1:NSLayoutAttributeTrailing attr2:NSLayoutAttributeTrailing constant:0];
        
    BreathVC *breathVC = [[BreathVC alloc] init];
    AirQualityVC *airQualityVC = [[AirQualityVC alloc] init];
    NearbyPharVC *nearbyPharVC = [[NearbyPharVC alloc] init];
    SetVC *setVC = [[SetVC alloc] init];
    
    
     UINavigationController *nav_breath = [[UINavigationController alloc]initWithRootViewController:breathVC];
     UINavigationController *nav_airQuality = [[UINavigationController  alloc]initWithRootViewController:airQualityVC];
     UINavigationController *nav_visitMap = [[UINavigationController alloc]initWithRootViewController:nearbyPharVC];
     UINavigationController *nav_set = [[UINavigationController alloc]initWithRootViewController:setVC];
    
    _vc_tab.viewControllers = @[nav_breath, nav_airQuality, nav_visitMap,nav_set];
    
    NSArray *ar = _vc_tab.viewControllers;
    NSMutableArray *arr_t = [NSMutableArray new];
    [ar enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop)
     {
         UITabBarItem *item = nil;
         switch (idx)
         {
             case 0:
             {
                 ;
                 item = [[UITabBarItem alloc] initWithTitle:@"呼吸测量" image:[UIImage imageNamed:@"主菜单栏_图标_首页_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_首页_选中.png"]];
                 break;
             }
             case 1:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"空气质量" image:[UIImage imageNamed:@"主菜单栏_图标_我的工作_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_我的工作_选中.png"]];
                 break;
             }
             case 2:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"附近药局" image:[UIImage imageNamed:@"主菜单栏_图标_走访地图_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_走访地图_选中.png"]];
                 break;
             }
             case 3:
             {
                 item = [[UITabBarItem alloc] initWithTitle:@"系统设置" image:[UIImage imageNamed:@"主菜单栏_图标_通讯录_未选中.png"] selectedImage:[UIImage imageNamed:@"主菜单栏_图标_通讯录_选中.png"]];
                 break;
             }
         }
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
