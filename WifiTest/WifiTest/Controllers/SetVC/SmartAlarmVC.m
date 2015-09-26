//
//  SmartAlarmVC.m
//  WifiTest
//
//  Created by Hcat on 15/9/26.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SmartAlarmVC.h"
#import "SmartAlarmCell.h"
#import "ShareValue.h"
#import "LK_NSDictionary2Object.h"
#import "SmartAlarmSetVC.h"



@interface SmartAlarmVC ()

@property (nonatomic,strong) NSMutableArray *marr_alarms;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;

@end

@implementation SmartAlarmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alarmChangeNotification:) name:NOTIFICATION_ALARMCHANGE object:nil];
    _marr_alarms = [NSMutableArray array];
    
    
    
    [self initUI];
    [self initData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)initUI{

    self.navigationItem.title = @"智能闹钟";
    
    UIImage *image = [UIImage imageNamed:@"addBtn_normal"];
    CGRect buttonFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"addBtn_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"addBtn_normal"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"addBtn_normal"] forState:UIControlStateSelected];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [ShareFun getCorner:_btn_save withCorner:CGRectGetHeight(_btn_save.frame)/2 withBorderWidth:1.f withBorderColor:UIColorFromRGB(0x40BAC8)];
    
}

- (void)initData{

    NSArray *t_arr = [ShareValue sharedShareValue].arr_alarms;
    
    for (NSDictionary *t_dic in t_arr) {
        Alarm *t_alarm = [t_dic objectByClass:[Alarm class]];
        [_marr_alarms addObject:t_alarm];
    }

}


#pragma mark - buttonAction

- (void)addAction:(id)sender{
    
    SmartAlarmSetVC *t_vc = [[SmartAlarmSetVC alloc] init];
    t_vc.type = SmartAlarmSetTypeAdd;
    [t_vc setDeleaget:(id<SmartAlarmSetVCDelegate>)self];
    [ApplicationDelegate.nav pushViewController:t_vc animated:YES];

}


- (IBAction)btnSaveAction:(id)sender {
    
    NSMutableArray *t_arr = [NSMutableArray array];
    for (Alarm *t_alarm in _marr_alarms) {
        NSDictionary *t_dic = [t_alarm lkDictionary];
        [t_arr addObject:t_dic];
    }
    [[ShareValue sharedShareValue]  setArr_alarms:t_arr];
    
    [ShowHUD showSuccess:@"保存成功" configParameter:^(ShowHUD *config) {
    } duration:1.5f inView:ApplicationDelegate.window];
}

#pragma mark  - UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _marr_alarms.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString* identifier = @"SmartAlarmCell";
    
    SmartAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SmartAlarmCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0x1d2124);
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    
    if (indexPath.row != 0) {
        cell.imageV_topLine.hidden = YES;
    }
    
    Alarm *t_alarm = _marr_alarms[indexPath.row];
    
    cell.alarm = t_alarm;
    
    
    return cell;
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SmartAlarmSetVC *t_vc   = [[SmartAlarmSetVC alloc] init];
    t_vc.type               = SmartAlarmSetTypeSet;
    t_vc.alarm              = (Alarm *)_marr_alarms[indexPath.row];
    [ApplicationDelegate.nav pushViewController:t_vc animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView.contentOffset.y < 0) {
        CGPoint position = CGPointMake(0, 0);
        [scrollView setContentOffset:position animated:NO];
        return;
    }
    
    
}

#pragma mark - SmartAlarmSetDelegate

- (void)alarmIsdidAdded:(Alarm *)alarm{
    [_marr_alarms addObject:alarm];
    [_tableView reloadData];
    [self btnSaveAction:nil];
}

#pragma mark - NSNotification

-(void)alarmChangeNotification:(NSNotification *)note{
    [_tableView reloadData];
    
}


#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"SmartAlarmVC dealloc");
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
