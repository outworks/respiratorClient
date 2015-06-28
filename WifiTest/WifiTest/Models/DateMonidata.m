//
//  DateMonidata.m
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "DateMonidata.h"


@implementation DateMonidata

+(Class)__dataDetailsClass{
    return [Monidata class];
}

-(Monidata *)bestMonidata{
    Monidata *data = nil;
    if(_dataDetails.count>0){
        for (Monidata *monidata in _dataDetails) {
            if (!data) {
                data = monidata;
            }
            if (monidata.pef >data.pef) {
                data = monidata;
            }
        }
    }
    return data;
}

@end
