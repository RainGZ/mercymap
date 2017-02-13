//
//  LightTableViewController.m
//  MercyMap
//
//  Created by sunshaoxun on 16/4/7.
//  Copyright © 2016年 Wispeed. All rights reserved.
//
#import "AppDelegate.h"
#import "LightTableViewController.h"
#import "LightHeadTableViewCell.h"
#import "LightListTableViewCell.h"
#import "LightKindTableViewCell.h"
#import "LightKindTableViewController.h"
#import "LightListTableViewController.h"
#import "ButtonAdd.h"
#import "LoginService.h"
#import "MJRefresh.h"
#import "CityTableViewController.h"
#import "CityNameTableViewController.h"
#import "MapViewSet.h"
#import "YCXMenu.h"
#import "CreateTableViewController.h"
#import "SDCycleScrollView.h"
#import "LightDetailsViewController.h"
#import "YBPopupMenu.h"
#import "SDScanViewController.h"
@interface LightTableViewController ()<sendDelegate,UITextViewDelegate,SDCycleScrollViewDelegate,YBPopupMenuDelegate>{
    UIButton *cityBtn ,*rightBtn;
    int fag,pageNum;
    LoginService *SerVice;
    NSMutableArray *finallyArray,*headPArray;
    MapViewSet *mapviewSet;
    SDCycleScrollView *_cycleScrollView;
    UIScrollView *_demoContainerView;
    
}
@property(nonatomic,strong) LightHeadTableViewCell *headCell;
@property (nonatomic,strong) NSMutableArray *items;
@end

@implementation LightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:24/255.0 green:147/255.0 blue:30/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:0.6];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    SerVice =[[LoginService alloc]init];
    mapviewSet =[[MapViewSet alloc]init];
    headPArray   = [[NSMutableArray alloc] initWithCapacity:0];
    finallyArray = [[NSMutableArray alloc]initWithCapacity:0];
    pageNum =0;
    [self LightList];
    [self getHeadinfo];
    
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(setView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = rightItem ;
    self.tableView.showsVerticalScrollIndicator = NO;
    //刷新
    self.tableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self LightList];
        });
    }];
    self.tableView.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            pageNum =0;
            [self LightList];
            [self getHeadinfo];
             });
    }];
    self.tableView.footer.hidden =YES;
    _demoContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,kSCREENWIDTH,kSCREENWIDTH/2)];
    _demoContainerView.contentSize = CGSizeMake(MainScreen.size.width,120);
}

-(void)LightList{
   [SerVice getLightListInfonation:pageNum Pagesize:15 successBlock:^(NSArray *modelArray) {
     if (pageNum ==0) {
        [finallyArray removeAllObjects];
        }
        pageNum ++;
        [finallyArray addObjectsFromArray:modelArray];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        if (modelArray.count==0) {
            [self.tableView.footer endRefreshingWithNoMoreData];
        }
        [self.tableView reloadData];
    }Failuer:^(NSString *error) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"服务器异常";
//        [hud hide: YES afterDelay: 2];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}

-(void)citySet{
    UIView *CityChooseV = [[UIView alloc]initWithFrame:CGRectMake(-10, 0, 90, 30)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(30,6, 18, 18)];
    
    cityBtn =[[UIButton alloc]initWithFrame:CGRectMake(-20, 0, 60, 25)];
    cityBtn.titleLabel.font =[UIFont systemFontOfSize:14.0];
    
    cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    imageV.image = [UIImage imageNamed:@"jiantou"];
    
    NSString *str =[[NSUserDefaults standardUserDefaults]objectForKey:@"CityName"];
    
    if (str==nil){
        NSString *Lstr =[[NSUserDefaults standardUserDefaults]objectForKey:@"LocationCityName"];
       [cityBtn setTitle:Lstr forState:UIControlStateNormal];
    }
    else{
        [cityBtn setTitle:str forState:UIControlStateNormal];
    }
    [cityBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(cityChoose) forControlEvents:UIControlEventTouchUpInside];
    
    [CityChooseV addSubview:cityBtn];
    [CityChooseV addSubview:imageV];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:CityChooseV];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)cityChoose{
    CityTableViewController *CityVC = [[CityTableViewController alloc]initWithNibName:@"CityTableViewController" bundle:nil];
     CityVC.fag =1;
    [CityVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:CityVC animated:YES];
}

-(void)setView{
    NSArray *titles = @[@"创建商家",@"扫一扫"];
    NSArray *images =@[@"create_shop",@"saoyisao"];
    [YBPopupMenu showRelyOnView:rightBtn titles:titles  icons:images menuWidth:160 delegate:self];
}

-(void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    switch (index) {
        case 0:
            [self creatshop];
            break;
            
        default:
            [self scanAction];
            break;
    }
}

-(void)creatshop{
       if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"UserLogin"]boolValue]){
            UIViewController * createVC = [[CreateTableViewController alloc]initWithNibName:@"CreateTableViewController" bundle:nil];
            createVC.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:createVC animated:YES];
        }
        else{
           ButtonAdd *alterBtn =[[ButtonAdd alloc]init];
           [alterBtn AlterView:self];
        }
}

-(void)scanAction{
    SDScanViewController *desVc = [[SDScanViewController alloc] init];
    desVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:desVc animated:YES];
}

-(void)sendFag:(int)fag1{
    LightKindTableViewController *kindVC = [self.storyboard instantiateViewControllerWithIdentifier:@"kindS"];
    kindVC.fag1 = fag1;
    kindVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:kindVC animated:YES];
}
-(void)getHeadinfo{
    NSString *url =[NSString stringWithFormat:@"%@%@",URLM,@"api/Shop/GetShopStoryList"];
    NSDictionary *dic = @{
                          @"FormPlatform":@100,
                          @"ClientType":@10
                          };
    [SerVice sendRequestHttp:url parameters:dic Success:^(NSDictionary *dicData) {
        if ([dicData[@"OMsg"][@"Flag"]isEqualToString:@"S"]) {
             headPArray = dicData[@"ListShopList"];
            [self.tableView reloadData];
     }
    } Failuer:^(NSString *errorInfo) {
          }];
//  NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
//  [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated{
    [self citySet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     if (section==2){
         return finallyArray.count;
    }
    else
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0){
        return _headCell.pageScrollView.height +_headCell.StoryView.height;
    }
    else
        return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    CGFloat height;
    if (section == 0) {
        height = 0;
    }
    else{
        height =3;
    }
    return  height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =nil;
    if ( indexPath.section ==0){
         LightHeadTableViewCell *HeadCell =[tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        _headCell = HeadCell ;
        [self headImageScrollerView];
        cell =HeadCell;
    }
    else if (indexPath.section ==1){
        LightKindTableViewCell *kindCell =[tableView dequeueReusableCellWithIdentifier:@"kindCell"forIndexPath:indexPath];
        kindCell.delegate =self;
        cell = kindCell;
    }
    else{
        LightListTableViewCell *listCell =[tableView dequeueReusableCellWithIdentifier:@"listCell"forIndexPath:indexPath];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [self.tableView setSeparatorColor:[UIColor grayColor]];
        listCell.LightNameLable.text = finallyArray[indexPath.row][@"ShopName"];
        listCell.LightintroduceLable.text = finallyArray[indexPath.row][@"ShopStory"];
        listCell.dianzanLable.text = [NSString stringWithFormat:@"%d",[finallyArray[indexPath.row][@"LikedCount"] intValue]];
        listCell.commentLable.text =[NSString stringWithFormat:@"%d",[finallyArray[indexPath.row][@"CommentCount"]intValue]];
        NSString *str =[NSString stringWithFormat:@"%@",finallyArray[indexPath.row][@"ShopMainImg"]];
        NSString *Imgstr =[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@uploadfiles/%@",URLM,Imgstr]];
        listCell.LightImageView.clipsToBounds =YES;
        [listCell.LightImageView sd_setImageWithURL:imageUrl];
         cell = listCell;
     }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==2){
        LightDetailsViewController *detailsVC = [[LightDetailsViewController alloc]init];
        [detailsVC setHidesBottomBarWhenPushed:YES];
         detailsVC.ID =[finallyArray[indexPath.row][@"ID"]intValue];
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
   else{
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    CityNameTableViewController *VC  = segue.destinationViewController;
    VC.ReturnBlock = ^(NSString *str){
        [cityBtn setTitle:str forState:UIControlStateNormal];
        [cityBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    };
}

-(void)getVersion{
    BaseHttpRequest *serVice  =[[BaseHttpRequest alloc]init];
    NSString *url =[NSString stringWithFormat:@"%@api/Common/MercymapConfig",URLM];
    [serVice sendRequestHttp:url parameters:nil Success:^(NSDictionary *dicData) {
        NSDictionary *dicInfo = [[NSBundle mainBundle]infoDictionary];
        NSString *AppVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
        if (![dicData[@"MercyMapConfig"][@"VersionNumber"]isEqualToString:AppVersion]) {
            [self alterController:dicData];
        }
    } Failuer:^(NSString *errorInfo) {
    }];
}

-(void)headImageScrollerView{
    [_headCell addSubview:_demoContainerView];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    
    for(NSDictionary *dic in headPArray) {
         NSString *imageStr=[NSString stringWithFormat:@"%@uploadfiles/%@",URLM,dic[@"ShopMainImg"]];
         NSString *Imgstr =[imageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [imageArray addObject:Imgstr];
    }
    _cycleScrollView= [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,kSCREENWIDTH,_headCell.pageScrollView.height) delegate:self placeholderImage:nil];
    _cycleScrollView.pageControlAliment  = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor redColor];
    _cycleScrollView.autoScrollTimeInterval  = 4;
    [_demoContainerView addSubview:_cycleScrollView];
    
    if(headPArray.count != 0){
    _headCell.introduceLable.text = headPArray[0][@"ShopStory"];}
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _cycleScrollView.imageURLStringsGroup = imageArray;
    });
    
    __weak NSMutableArray *array = headPArray;
    __weak LightTableViewController *lightVC =self;
    _cycleScrollView.clickItemOperationBlock =  ^(NSInteger index){
        int  ID = [array[index][@"ID"] intValue];
        LightDetailsViewController *detailsVC = [[LightDetailsViewController alloc]init];
        [detailsVC setHidesBottomBarWhenPushed:YES];
        detailsVC.ID = ID;
        [lightVC.navigationController pushViewController:detailsVC animated:YES];
    };
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _headCell.introduceLable.text = headPArray[index][@"ShopStory"];
 });
}

-(void)alterController :(NSDictionary *)dic{
    NSString * str = [NSString stringWithFormat:@"更新版本 %@",dic[@"MercyMapConfig"][@"VersionNumber"]];
    UIAlertController *alterController =[UIAlertController alertControllerWithTitle:@"更新提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OK =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/le-shan-de-tu/id1137483629?l=en&mt=8"]];
    }];
    [alterController addAction:OK];
    [self presentViewController:alterController animated:YES completion:nil];
}
@end
