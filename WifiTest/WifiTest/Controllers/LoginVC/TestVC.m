//
//  TestVC.m
//  WifiTest
//
//  Created by nd on 15/6/25.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "TestVC.h"

#pragma mark - SecondDataItem


@interface SecondDataItem : NSObject

@property(nonatomic,assign) float maxDBC;
@property(nonatomic,assign) float areaSum;

@property(nonatomic,assign,readonly) float PEF;
@property(nonatomic,assign,readonly) float FEV1;


@end

@implementation SecondDataItem

-(float)FEV1{
    float y = 0.0547 * _areaSum + 1.0573;
    return y;
}

-(float)PEF{
    float y = 29.704*_maxDBC - 879.52;
    return y;
}


@end

#pragma mark - DataItem

@interface DataItem : NSObject

@property(nonatomic,assign) int db;
@property(nonatomic,assign) double timeInterval;

-(id)initWithDataString:(NSString *)dataString;

@end

@implementation DataItem

-(id)initWithDataString:(NSString *)dataString{
    self = [super init];
    if (self) {
        int db = [self getDBFromString:dataString];
        NSDate *date = [self dateFormString:dataString];
        NSTimeInterval timerInterval = [date timeIntervalSinceNow];
        self.db = db;
        self.timeInterval = timerInterval;
    }
    return self;
}

-(int)getDBFromString:(NSString *)dataString{
    NSRange rang = [dataString rangeOfString:@"LCPeak:"];
    NSString *dbString = [dataString substringFromIndex:rang.location];
    dbString = [dbString stringByReplacingOccurrencesOfString:@"LCPeak:" withString:@""];
    dbString = [dbString stringByReplacingOccurrencesOfString:@"db" withString:@""];
    dbString = [dbString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [dbString intValue];
}

-(NSDate *)dateFormString:(NSString *)dataString{
    NSString *dateString = [dataString substringToIndex:21];
    NSDate *date = [[self class] convertDateFromString:dateString];
    return date;
}


+(NSDate*) convertDateFromString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}

@end

#pragma mark - testVC


@interface TestVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_pef;
@property (weak, nonatomic) IBOutlet UILabel *lb_fev;
@property (weak, nonatomic) IBOutlet UILabel *lb_dbcMax;
@property (weak, nonatomic) IBOutlet UILabel *lb_arac;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong,nonatomic) NSMutableArray *data;

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [NSMutableArray array];
    
}

#pragma mark - private 


-(SecondDataItem *)getSecondDataItmeFormDatas:(NSArray *)datas{
    NSArray *array = [self getTestDatas];
    int maxdBC = 0;
    DataItem *tempItem = nil;
    float total = 0;
    for (NSString *string in array) {
        NSLog(@"%@",string);
        DataItem *item = [[DataItem alloc]initWithDataString:string];
        if (tempItem) {
            maxdBC = MAX(maxdBC, item.db);
            float tempDbc = (tempItem.db+item.db)*(item.timeInterval-tempItem.timeInterval)/2;
            NSLog(@"maxdbc:%d  tempdbc:%f\n",maxdBC,tempDbc);
            total += tempDbc;
        }
        tempItem = item;
    }
    SecondDataItem *s_time = [[SecondDataItem alloc]init];
    s_time.areaSum = total;
    s_time.maxDBC = maxdBC;
    return s_time;
}

-(NSArray *)getTestDatas{
    NSMutableArray *array = [NSMutableArray array];
    NSString *dataString1 = [[self class] convertStringFromDate:[NSDate date]];
    [array addObject:[NSString stringWithFormat:@"%@ 28 dBC(impuls) LCPeak:0 db",dataString1]];
    NSTimeInterval beginTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval nowTime = beginTime;
    while ((nowTime - beginTime) < 1.2) {
        int i = rand() % 2+1;
        [NSThread sleepForTimeInterval:i * 0.1f];
        NSString *dataString = [self getRandData];
        nowTime = [[NSDate date] timeIntervalSince1970];
        [array addObject:dataString];
    }
    return array;
}

+(NSString*) convertStringFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}


-(NSString *)getRandData{
    NSString *dateString = [[self class] convertStringFromDate:[NSDate date]];
    NSString *data = [NSString stringWithFormat:@"%@ 68 dBC(impuls) LCPeak:%d db",dateString,[self randLCP:25]];
    return data;
}

-(int)randLCP:(int)normal{
    return rand() % 10 + normal;
}


#pragma mark - buttonAction


- (IBAction)testAciton:(id)sender {
    
    [_data removeAllObjects];
    
    NSArray *arr = [self getTestDatas];
    [_data addObjectsFromArray:arr];
    
    NSString *string = @"";
    for (NSString* t_str in _data) {
        string =  [string stringByAppendingString:[NSString stringWithFormat:@"%@\n",t_str]];
    }
    _textView.text = string;
  
    
    SecondDataItem *item = [self getSecondDataItmeFormDatas:_data];
    _lb_dbcMax.text = [NSString stringWithFormat:@"%f",item.maxDBC];
    _lb_arac.text = [NSString stringWithFormat:@"%f",item.areaSum];
    _lb_pef.text = [NSString stringWithFormat:@"%f",item.PEF];
    _lb_fev.text = [NSString stringWithFormat:@"%f",item.FEV1];
    
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
