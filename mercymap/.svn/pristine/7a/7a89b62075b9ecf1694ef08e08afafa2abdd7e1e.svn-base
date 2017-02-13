//
//  WalkMapTableViewCell.h
//  MercyMap
//
//  Created by sunshaoxun on 16/9/16.
//  Copyright © 2016年 Wispeed. All rights reserved.
//

#import "ZZBaseTableViewCell.h"
#import<MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "MapViewModel.h"
@interface WalkMapTableViewCell : ZZBaseTableViewCell<MAMapViewDelegate>
{
    int i;
    NSMutableArray *finallyArray;
}
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)UIButton  *timeChoose;
@property (nonatomic) CLLocationCoordinate2D Mapcoordinate;
@property(nonatomic,strong)NSMutableArray *timeitems;
-(void)sendDataMapView:(NSMutableArray *)dataArray;
@end
