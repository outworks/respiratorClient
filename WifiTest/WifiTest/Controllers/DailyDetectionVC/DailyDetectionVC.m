//
//  DailyDetectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/4.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DailyDetectionVC.h"
#import "DailyFirstVC.h"
#import "DailySecondVC.h"
#import "DailyThirdVC.h"

#import "CommodityVC.h"


@interface DailyDetectionVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic,strong) DailyFirstVC *firstVC;
@property (nonatomic,strong) DailySecondVC *secondVC;
@property (nonatomic,strong) DailyThirdVC *thirdVC;


@end

@implementation DailyDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"日常检测";
    
    UIImage *image = [UIImage imageNamed:@"图标-商城-默认"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(commodityAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"图标-商城-默认"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"图标-商城-选中"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"图标-商城-选中"] forState:UIControlStateSelected];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self initUI];
   
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods

//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

- (void) initUI{
    
    _firstVC = [[DailyFirstVC alloc] init];
    _firstVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_firstVC.view];
    
    _secondVC = [[DailySecondVC alloc] init];
    _secondVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_secondVC.view];
    
    _thirdVC = [[DailyThirdVC alloc] init];
    _thirdVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_thirdVC.view];
    
    [self scrollViewAutolayout];
    
    _pageControl.numberOfPages = 3;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    _pageControl.pageIndicatorTintColor =UIColorFromRGB(0x131415);
    _pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x3fB4C4);
    
}

#pragma mark - button Methods

//返回
- (void)backAction{
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
}

//商品
- (IBAction)commodityAction:(id)sender {
    
    CommodityVC *t_vc = [[CommodityVC alloc] init];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    [ApplicationDelegate.nav presentViewController:t_nav animated:YES completion:^{
    }];
    
}


#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    NSInteger page = offset.x / bounds.size.width;
    
    [_pageControl setCurrentPage:page];
    
    if (page == 0) {
        self.navigationItem.title = @"日常检测";
    } else if( page == 1 ){
        self.navigationItem.title = @"日常监测记录";
    } else {
        self.navigationItem.title = @"尖峰呼气流量记录";
    }
    
    
}




#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = NO;
        
    }
    
}


#pragma mark - dealloc

-(void)dealloc{
    NSLog(@"DailyDetectionVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - autolayout

-(void)scrollViewAutolayout{
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:0];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_secondVC.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstVC.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:0];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdVC.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondVC.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_thirdVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    
    [self setEdge:_scrollView view:_thirdVC.view attr1:NSLayoutAttributeTrailing attr2:NSLayoutAttributeTrailing constant:0];
    [self setEdge:_scrollView view:_thirdVC.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_thirdVC.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:0];
    
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
