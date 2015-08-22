//
//  MotionDetectionVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/3.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "MotionDetectionVC.h"
#import "AppDelegate.h"
#import "MotionFirstVC.h"
#import "MotionSecondVC.h"
#import "MotionThirdVC.h"
#import "MainVC.h"

#import "CommodityVC.h"

@interface MotionDetectionVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btn_commodity;
@property (weak, nonatomic) IBOutlet UIButton *btn_back;

@property (weak, nonatomic) IBOutlet UIView *v_bottom;
@property (weak, nonatomic) IBOutlet UIButton *btn_upOrDown;
@property (nonatomic,assign) BOOL isUp;

@property (nonatomic,strong) MotionFirstVC *firstVC;
@property (nonatomic,strong) MotionSecondVC *secondVC;
@property (nonatomic,strong) MotionThirdVC *thirdVC;

@end

@implementation MotionDetectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    _isUp = NO;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [[self view] addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [[self view] addGestureRecognizer:recognizer];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - private methods 

//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

- (void) initUI{

    [ShareFun getCorner:_btn_commodity withCorner:_btn_commodity.frame.size.height/2 withBorderWidth:1.f withBorderColor:[UIColor clearColor]];
    [ShareFun getCorner:_btn_back];
    
    _firstVC = [[MotionFirstVC alloc] init];
    _firstVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_firstVC.view];
    
    _secondVC = [[MotionSecondVC alloc] init];
    _secondVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_secondVC.view];
    
    _thirdVC = [[MotionThirdVC alloc] init];
    _thirdVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addSubview:_thirdVC.view];
    
    [self scrollViewAutolayout];
    
    _pageControl.numberOfPages = 3;//指定页面个数
    _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = RGB(45, 169, 238);
    
    NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-64];
    t_bottom.identifier = @"1112";
    [self.view addConstraint:t_bottom];

}


#pragma mark - button Methods

//返回
- (IBAction)backAction:(id)sender {
    
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
}

//商品
- (IBAction)commodityAction:(id)sender {
    
    CommodityVC *t_vc = [[CommodityVC alloc] init];
    UINavigationController *t_nav = [[UINavigationController alloc] initWithRootViewController:t_vc];
    [ApplicationDelegate.nav presentViewController:t_nav animated:YES completion:^{
    }];
    
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        _isUp = NO;
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        _isUp = YES;
    }
    
    if (_isUp) {
        [_btn_upOrDown setTitle:@"向下" forState:UIControlStateNormal];
        NSArray *array = self.view.constraints;
        for (NSLayoutConstraint *constraint in array) {
            //NSLog(@"%@", constraint.identifier);
            if ([constraint.identifier isEqual:@"1112"]) {
                [self.view removeConstraint:constraint];
            }
        }
        
        NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:49];
        t_bottom.identifier = @"11121";
        [self.view addConstraint:t_bottom];
        
    }else{
        [_btn_upOrDown setTitle:@"向上" forState:UIControlStateNormal];
        NSArray *array = self.view.constraints;
        for (NSLayoutConstraint *constraint in array) {
            //NSLog(@"%@", constraint.identifier);
            if ([constraint.identifier isEqual:@"11121"]) {
                [self.view removeConstraint:constraint];
            }
        }
        
        NSLayoutConstraint * t_bottom = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_v_bottom attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-64];
        t_bottom.identifier = @"1112";
        [self.view addConstraint:t_bottom];
        
    }
    
}


//日常
- (IBAction)dailyAction:(id)sender {
    NSDictionary *t_dic = @{@"contentType":@"daily"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
}

//运动
- (IBAction)motionAction:(id)sender {
    NSDictionary *t_dic = @{@"contentType":@"motion"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
    
}

//用药
- (IBAction)DrugAction:(id)sender {
    NSDictionary *t_dic = @{@"contentType":@"drug"};
    [NotificationCenter postNotificationName:NOTIFICATION_FUNCTIONCHANGE object:nil userInfo:t_dic];
    
}


#pragma makr - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    [_pageControl setCurrentPage:offset.x / bounds.size.width];
    
}


#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationController.navigationBarHidden = YES;
        
    }
    
}


#pragma mark - dealloc 

-(void)dealloc{
    NSLog(@"MotionDetectionVC dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - autolayout

-(void)scrollViewAutolayout{
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeLeading attr2:NSLayoutAttributeLeading constant:0];
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:-20];
    [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
   [self setEdge:_scrollView view:_firstVC.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:0];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_secondVC.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_firstVC.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:-20];
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeWidth attr2:NSLayoutAttributeWidth constant:0];
    [self setEdge:_scrollView view:_secondVC.view attr1:NSLayoutAttributeHeight attr2:NSLayoutAttributeHeight constant:0];
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:_thirdVC.view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_secondVC.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    
    [self setEdge:_scrollView view:_thirdVC.view attr1:NSLayoutAttributeTop attr2:NSLayoutAttributeTop constant:-20];

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
