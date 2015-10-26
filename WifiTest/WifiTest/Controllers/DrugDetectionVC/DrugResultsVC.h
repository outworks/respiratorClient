//
//  DrugResultsVC.h
//  WifiTest
//
//  Created by Hcat on 15/10/26.
//  Copyright © 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"
#import "DataAPI.h"

@interface DrugResultsVC : BasicVC

@property (nonatomic,strong) NSString *drugName;

@property (nonatomic,strong) Monidata *beforeMonidata;

@property (nonatomic,strong) Monidata *afterMonidata;

-(void)loadData;


@end
