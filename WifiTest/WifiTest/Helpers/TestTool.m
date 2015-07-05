//
//  TestTool.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "TestTool.h"



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


@interface TestTool()

@property(nonatomic,assign) float maxDBC;
@property(nonatomic,assign) float areaSum;


@end

@implementation TestTool

SYNTHESIZE_SINGLETON_FOR_CLASS(TestTool)

-(float)pef{
    float y = 29.704*_maxDBC - 879.52;
    return y;
}

-(float)fev1{
    float y = 0.0547 * _areaSum + 1.0573;
    return y;
}

-(float)fvc{
    float y = 8.88*_maxDBC+1.123;
    return y;
}



-(void)test{

    NSArray *arr = [self getTestDatas];
    [self getSecondDataItmeFormDatas:arr];
}



-(void)getSecondDataItmeFormDatas:(NSArray *)datas{
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
    
    self.areaSum = total;
    self.maxDBC = maxdBC;
    
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
    NSString *data = [NSString stringWithFormat:@"%@ 68 dBC(impuls) LCPeak:%d db",dateString,[self randLCP:rand() % 6 + 32]];
    NSLog(@"%@ 68 dBC(impuls) LCPeak:%d db",dateString,[self randLCP:56]);
    return data;
}

-(int)randLCP:(int)normal{
    return rand() % 10 + normal;
}


@end
