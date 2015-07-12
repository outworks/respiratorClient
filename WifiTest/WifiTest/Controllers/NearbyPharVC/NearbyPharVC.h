//
//  NearbyPharVC.h
//  WifiTest
//
//  Created by Hcat on 15/6/27.
//  Copyright (c) 2015年 CivetCatsTeam. All rights reserved.
//

#import "BasicVC.h"

#import <BaiduMapAPI/BMapKit.h>

@interface NearbyPharVC : BasicVC<BMKMapViewDelegate>{
    IBOutlet BMKMapView* mapView;

}

@end
