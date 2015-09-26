//
//  DrugResultVC.m
//  WifiTest
//
//  Created by Hcat on 15/8/22.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DrugResultVC.h"
#import "DataAPI.h"
#import "DrugResultView.h"

@interface DrugResultVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation DrugResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr_data = [NSMutableArray array];

    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - privateMethods

- (void)setEdge:(UIView*)superview view:(UIView*)view attr1:(NSLayoutAttribute)attr1 attr2:(NSLayoutAttribute)attr2 constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:superview attribute:attr2 multiplier:1.0 constant:constant]];
}

-(void)loadData{
    
    DateDatasRequest *request = [[DateDatasRequest alloc]init];
    request.page = @1;
    request.mid = [ShareValue sharedShareValue].member.mid;
    request.inputType = @2;
    __weak __typeof(self) weakSelf = self;
    [DataAPI dateDatasWithRequest:request completionBlockWithSuccess:^(NSArray *datas) {
        
        if ([datas count]> 0 ) {
            DateMonidata *dateMonidata = datas[0];
            for (int i = 0; i < [dateMonidata.dataDetails count] ; i++) {
                Monidata *monidata_i = dateMonidata.dataDetails[i];
                if (i == [dateMonidata.dataDetails count]-1) {
                    break;
                }
                Monidata *monidata_j = dateMonidata.dataDetails[i+1];
                
                if ([monidata_i.saveTime isEqualToString:monidata_j.saveTime]) {
                    NSMutableDictionary *t_mutDic = [NSMutableDictionary dictionary];
                    if ([monidata_i.otherType isEqualToNumber:@1]) {
                        [t_mutDic setValue:monidata_i forKey:@"beforeDrug"];
                         [t_mutDic setValue:monidata_j forKey:@"afterDrug"];
                    }else{
                        [t_mutDic setValue:monidata_j forKey:@"beforeDrug"];
                        [t_mutDic setValue:monidata_i forKey:@"afterDrug"];
                    }
                    if ((i+1) != [dateMonidata.dataDetails count]-1) {
                        i++;
                    }
                    
                    [_arr_data addObject:t_mutDic];
                    
                }else{
                    
                    NSMutableDictionary *t_mutDic = [NSMutableDictionary dictionary];
                    if ([monidata_i.otherType isEqualToNumber:@1]) {
                        [t_mutDic setValue:monidata_i forKey:@"beforeDrug"];
                    }else{
                        [t_mutDic setValue:monidata_i forKey:@"afterDrug"];
                    }
                    
                    [_arr_data addObject:t_mutDic];
                }
                
            }
            
            
            for (int i = 0; i < [_arr_data count] ; i++) {
                NSMutableDictionary *t_dic = _arr_data[i];
                
                DrugResultView *t_drugResultView = [DrugResultView initCustomView];
                t_drugResultView.frame = CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight-64);
                Monidata *t_before = [t_dic objectForKey:@"beforeDrug"];
                Monidata *t_after = [t_dic objectForKey:@"afterDrug"];
                if (t_before) {
                    t_drugResultView.beforeMonidata = t_before;
                }
                if (t_after) {
                    t_drugResultView.afterMonidata = t_after;
                }
                [t_drugResultView loadData];
                t_drugResultView.tag = i+100;
                [_scrollView addSubview:t_drugResultView];
                               
            }
            
            [_scrollView setContentSize:CGSizeMake(_arr_data.count *ScreenWidth, ScreenHeight-64)];
            
            _pageControl.numberOfPages = _arr_data.count;//指定页面个数
            _pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
            _pageControl.pageIndicatorTintColor =[UIColor lightGrayColor];
            _pageControl.currentPageIndicatorTintColor = RGB(45, 169, 238);
        }
        
        
        
        
        
        
        
        
        
    } Fail:^(int code, NSString *failDescript) {
        [ShowHUD showError:failDescript configParameter:^(ShowHUD *config) {
        } duration:1.5f inView:self.view];
    }];



}


#pragma mark - buttonAction 

//返回
- (void)backAction{
    
    [ApplicationDelegate.nav popViewControllerAnimated:YES];
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
    NSLog(@"DrugResultVC dealloc");
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
