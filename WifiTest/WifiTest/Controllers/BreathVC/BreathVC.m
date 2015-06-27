//
//  BreathVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BreathVC.h"
#import "PEFFirstVC.h"
#import "PEFSecondVC.h"
#import "PEFThirdVC.h"

@interface BreathVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) PEFFirstVC *firstvc;
@property (nonatomic,strong) PEFSecondVC *secondevc;
@property (nonatomic,strong) PEFThirdVC *thirdvc;
@end

@implementation BreathVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"呼吸量测";
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private 

//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

-(void)loadUI{
    
    _firstvc = [[PEFFirstVC alloc] init];
    _firstvc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_firstvc.view];

    _secondevc = [[PEFSecondVC alloc] init];
    _secondevc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_secondevc.view];
    
    _thirdvc = [[PEFThirdVC alloc] init];
    _thirdvc.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_thirdvc.view];

    [self setEdge:_scrollView view:_firstvc.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
    [self setEdge:_scrollView view:_firstvc.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:_scrollView view:_firstvc.view attr1:NSLayoutAttributeBottom attr2: NSLayoutAttributeBottom constant:0];
    [self setEdge:_scrollView view:_firstvc.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_firstvc.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:-64];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_secondevc.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstvc.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_secondevc.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:_scrollView view:_secondevc.view attr1:NSLayoutAttributeBottom attr2: NSLayoutAttributeBottom constant:0];
    [self setEdge:_scrollView view:_secondevc.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_secondevc.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:-64];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdvc.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondevc.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_thirdvc.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:0];
    [self setEdge:_scrollView view:_thirdvc.view attr1:NSLayoutAttributeBottom attr2: NSLayoutAttributeBottom constant:0];
    [self setEdge:_scrollView view:_thirdvc.view attr1:NSLayoutAttributeTrailing attr2:NSLayoutAttributeTrailing constant:0];
    [self setEdge:_scrollView view:_thirdvc.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_thirdvc.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:-64];
    
    _pageControl.numberOfPages = 3;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = RGB(45, 169, 238);
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    
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
