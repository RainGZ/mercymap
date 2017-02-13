//
//  WalkRouteTableViewController.m
//  MercyMap
//
//  Created by sunshaoxun on 16/4/12.
//  Copyright © 2016年 Wispeed. All rights reserved.
//

#import "WalkRouteTableViewController.h"
#import "WalkTextTableViewCell.h"
#import "WalkMapTableViewCell.h"
#import "LoginService.h"
#import "Single.h"
#import "MJRefresh.h"
#import "LightDetailsViewController.h"
@interface WalkRouteTableViewController ()
{
    UISegmentedControl * _segmentC;
    LoginService       *_service;
    Single             *_single;
    int i;
    NSMutableArray     *_dataArray;
}
@end

@implementation WalkRouteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [[LoginService alloc]init];
    _single = [Single Send];
    i=0;
    _dataArray= [NSMutableArray arrayWithCapacity:0];
    _segmentC = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"文字",@"地图",nil]];
    _segmentC.frame = CGRectMake(20, 20, 120, 30);
    _segmentC.tintColor = [UIColor whiteColor];
    _segmentC.backgroundColor = [UIColor blueColor];
    _segmentC.layer.cornerRadius = 5.0;
    _segmentC.layer.masksToBounds = YES;
    _segmentC.selectedSegmentIndex =0;
    [_segmentC addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentC;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navBackBtn@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
//    CGRect frame = self.tableView.frame;
//    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height  - 64);
    [self getWalkInfo];
    [self.tableView registerClass:NSClassFromString(@"WalkTextTableViewCell")forCellReuseIdentifier:@"WalkText"];
     [self.tableView registerClass:@[@"WalkMapTableViewCell"]];
    self.edgesForExtendedLayout =UIRectEdgeNone ;
    self.tableView.backgroundColor =[UIColor colorWithWhite:1.0 alpha:1.0];
    self.tableView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self performSelector:@selector(getWalkInfo) withObject:self afterDelay:0];
    }];
    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        i=0;
        [self getWalkInfo];
    }];

}
-(void)navLeftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger row;
    if (_segmentC.selectedSegmentIndex == 0) {
        row = _dataArray.count ;
    }else{
        row =1;
    }
    return row;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int height;
    if (_segmentC.selectedSegmentIndex == 0) {
        height = 70;
    }else{
        height = kSCREENHEIGTH;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (_segmentC.selectedSegmentIndex == 0) {
        WalkTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"WalkText" forIndexPath:indexPath];
        [textCell configData:_dataArray[indexPath.row]];
        textCell.number.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell = textCell;
    }else{
        WalkMapTableViewCell *walkCell  =[tableView dequeueReusableCellWithIdentifier:@"WalkMapTableViewCell" forIndexPath:indexPath];
        [walkCell sendDataMapView:_dataArray];
        cell = walkCell;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_segmentC.selectedSegmentIndex == 0) {
    LightDetailsViewController *detailsVC = [[LightDetailsViewController alloc]init];
    [detailsVC setHidesBottomBarWhenPushed:YES];
    detailsVC.ID =[_dataArray[indexPath.row][@"ShopID"]intValue];
    [self.navigationController pushViewController:detailsVC animated:YES];
    }
}

-(void)click:(UISegmentedControl *)segmetC{
    NSInteger selectedIndex = _segmentC.selectedSegmentIndex;
    if (selectedIndex == 0) {
        [self.tableView reloadData];
    }
    else{
        [self.tableView reloadData];
    }
}

-(void)getWalkInfo{
    MBProgressHUD * _Hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _Hud.labelText = @"加载中……";
    _Hud.labelFont = [UIFont systemFontOfSize:12];
    _Hud.margin = 10.f;
    _Hud.removeFromSuperViewOnHide = YES;
    NSDictionary *dic;
    NSNumber *uid =[NSNumber numberWithInt:_single.ID];
    NSString *Token = [NSString stringWithFormat:@"%@",_single.Token];
    NSNumber *index = [NSNumber numberWithInt:i];
    dic = @{@"UID":uid,@"pageIndex":index,@"pageSize":@20,@"Token":Token};
    NSString *url = [NSString stringWithFormat:@"%@api/Account/SignInList",URLM];
   [_service getArrayData:dic Url:url Title:@"ListUserSignInShop" SuccessBlock:^(NSArray *modelArray) {
       if(i==0){
           [_dataArray removeAllObjects];
       }
       i++;
       [_dataArray addObjectsFromArray:modelArray];
       [self.tableView.footer endRefreshing];
       [self.tableView.header endRefreshing];
       if(modelArray.count ==0){
           [self.tableView.footer endRefreshingWithNoMoreData];
       }
       [self.tableView reloadData];
       [_Hud hide:YES];
  } FailuerBlock:^(NSString *str) {
      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      hud.mode = MBProgressHUDModeText;
      hud.labelText = @"您的网络不给力!";
      [hud hide: YES afterDelay: 2];
  }];
}
@end
