//
//  StarFirstViewController.m
//  MercyMap
//
//  Created by sunshaoxun on 16/4/21.
//  Copyright © 2016年 Wispeed. All rights reserved.
//

#import "StarFirstViewController.h"
#import "LoginService.h"
#import "Single.h"
#import "StarInfornationTableViewController.h"
@interface StarFirstViewController ()<UITextFieldDelegate>
{
    UIButton *rightBtn;
    LoginService *service;
    Single *single;
}

@end

@implementation StarFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_EditTextFile becomeFirstResponder];
    _EditTextFile.delegate =self;
    service = [[LoginService alloc]init];
    single = [Single Send];
    [self setTextLable];
    self.title =_titlename;
    
    rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setImage:[UIImage imageNamed:@"over2"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navBackBtn@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];

}

-(void)navLeftBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setTextLable{
    if (_tag==1) {
        
        if ([_textfiledname isKindOfClass:[NSNull class]]) {
          _EditTextFile.placeholder =@"请输入你的宣言";
        }
        else{
            _EditTextFile.text =_textfiledname;
        }
        _introduceLable.text =[NSString stringWithFormat:@"写下你的个人信条"];
    }
    else{
        if ([_textfiledname isKindOfClass:[NSNull class]]) {
            _EditTextFile.placeholder =@"你的昵称";
            }
        else{
            _EditTextFile.text =_textfiledname;
            }
    }
}



-(void)Over{
    if (_tag ==0) {
        NSDictionary *dic =@{@"NickName":self.EditTextFile.text};
        NSNumber *uid = [NSNumber numberWithInt:single.ID];
        NSDictionary *lastdic =@{
                                 @"_Members":dic,
                                 @"Token":single.Token,
                                 @"UID":uid,
                                 @"FormPlatform":@100,
                                 @"ClientType":@10
                                 };
        NSString *url = [NSString stringWithFormat:@"%@api/Account/MemberUpdate",USERURL];
        [service getDicData:url Dic:lastdic Title:nil SuccessBlock:^(NSMutableDictionary *dic) {
            [self.navigationController popViewControllerAnimated:YES];
        } FailuerBlock:^(NSString *str) {
            
        }];

//        [service fixUserMessage:single.ID Token:single.Token Parameters:self.EditTextFile.text Code:@"NickName" successBlock:^(NSDictionary *model) {
//            StarInfornationTableViewController *InfoVC =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//            [self.navigationController popToViewController:InfoVC animated:YES];
//        } Failuer:^(NSString *error) {
//        }];
    }
    if (_tag==1) {
//        [service fixUserMessage:single.ID Token:single.Token Parameters:self.EditTextFile.text Code:@"Idiograph" successBlock:^(NSDictionary *model) {
//            
//            StarInfornationTableViewController *InfoVC =[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
//            [self.navigationController popToViewController:InfoVC animated:YES];
        
//        } Failuer:^(NSString *error) {
//            
//        }];
        NSDictionary *dic =@{@"Idiograph":self.EditTextFile.text};
        NSNumber *uid = [NSNumber numberWithInt:single.ID];
        NSDictionary *lastdic =@{
                                 @"_Members":dic,
                                 @"Token":single.Token,
                                 @"UID":uid,
                                 @"FormPlatform":@100,
                                 @"ClientType":@10
                                 };
        NSString *url = [NSString stringWithFormat:@"%@api/Account/MemberUpdate",USERURL];
        [service getDicData:url Dic:lastdic Title:nil SuccessBlock:^(NSMutableDictionary *dic) {
            [self.navigationController popViewControllerAnimated:YES];
        } FailuerBlock:^(NSString *str) {
            
        }];

    }
    
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [rightBtn setEnabled:YES];
    [rightBtn setImage:[UIImage imageNamed:@"over"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(Over) forControlEvents:UIControlEventTouchUpInside];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [rightBtn setImage:[UIImage imageNamed:@"over2"] forState:UIControlStateNormal];
    [rightBtn setEnabled:NO];
    return YES;
}

@end