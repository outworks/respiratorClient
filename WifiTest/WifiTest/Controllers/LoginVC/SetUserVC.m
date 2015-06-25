//
//  SetUserVC.m
//  WifiTest
//
//  Created by Hcat on 15/6/23.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "SetUserVC.h"
#import "TRSDialScrollView.h"

@interface SetUserVC ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TRSDialScrollView *dialView;


@end

@implementation SetUserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[TRSDialScrollView appearance] setMinorTicksPerMajorTick:10];
    [[TRSDialScrollView appearance] setMinorTickDistance:10];
    
    [[TRSDialScrollView appearance] setBackgroundColor:[UIColor clearColor]];
    [[TRSDialScrollView appearance] setOverlayColor:[UIColor clearColor]];
    
    [[TRSDialScrollView appearance] setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setLabelStrokeWidth:0.1f];
    [[TRSDialScrollView appearance] setLabelFillColor:[UIColor whiteColor]];
    
    [[TRSDialScrollView appearance] setLabelFont:[UIFont fontWithName:@"Avenir" size:18]];
    
    [[TRSDialScrollView appearance] setMinorTickColor:[UIColor whiteColor]];
    [[TRSDialScrollView appearance] setMinorTickLength:11.0];
    [[TRSDialScrollView appearance] setMinorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setMajorTickColor:[UIColor colorWithRed:0.098 green:0.220 blue:0.396 alpha:1.000]];
    [[TRSDialScrollView appearance] setMajorTickLength:22.0];
    [[TRSDialScrollView appearance] setMajorTickWidth:1.0];
    
    [[TRSDialScrollView appearance] setShadowColor:[UIColor colorWithRed:0.593 green:0.619 blue:0.643 alpha:1.000]];
    [[TRSDialScrollView appearance] setShadowOffset:CGSizeMake(0, 1)];
    [[TRSDialScrollView appearance] setShadowBlur:0.9f];
    
    [_dialView setDialRangeFrom:0 to:50];
    
    _dialView.currentValue = 20;
    
    _dialView.delegate = self;
    
    NSLog(@"Current Value = %li", (long)_dialView.currentValue);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating: %li", (long)_dialView.currentValue);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging: %li", (long)_dialView.currentValue);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    static NSInteger last_value = 0;
    
    // Calculate the value based on the content offset
    NSInteger value = self.dialView.currentValue;
    
    if (value != last_value) {
        NSLog(@"Metric: value=%li", (long)value);
    }
    
    last_value = value;
}




#pragma mark - dealloc

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
