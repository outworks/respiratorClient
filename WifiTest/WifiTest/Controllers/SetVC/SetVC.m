//
//  SetVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SetVC.h"
#import "SetCell.h"
#import "ShareValue.h"
#import "SexSelectionVC.h"
#import "DeviceVC.h"
#import "SmartAlarmVC.h"

@interface SetVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *data;


@end

@implementation SetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统设置";
    _data = @[@"我的设备",@"智能闹钟",@"基本资料",@"产品说明"];
}


#pragma mark  - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _data.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"SetCell";
    
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0x1d2124);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.lb_title.highlightedTextColor = [UIColor lightGrayColor];
    
    if (indexPath.row != 0) {
        cell.imageV_topLine.hidden = YES;
    }
    
    cell.lb_title.text = _data[indexPath.row];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DeviceVC *t_vc = [[DeviceVC alloc]init];
        [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
    } else if (indexPath.row == 1) {
        SmartAlarmVC *t_vc = [[SmartAlarmVC alloc]init];
        [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
    }else if (indexPath.row == 2) {
        SexSelectionVC *t_vc = [[SexSelectionVC alloc] init];
        t_vc.member = [ShareValue sharedShareValue].member;
        t_vc.isRegiest = NO;
        [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    

    if (scrollView.contentOffset.y < 0) {
        CGPoint position = CGPointMake(0, 0);
        [scrollView setContentOffset:position animated:NO];
        return;
    }
    
    
}




#pragma mark - navigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[self class]]) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - dealloc

-(void)dealloc{
    
    NSLog(@"SetVC dealloc");
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
