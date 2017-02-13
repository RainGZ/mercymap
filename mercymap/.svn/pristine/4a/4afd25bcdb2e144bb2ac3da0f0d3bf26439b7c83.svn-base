//  LogViewController.m
//  MercyMap
//  Created by sunshaoxun on 16/4/12.
//  Copyright © 2016年 Wispeed. All rights reserved.
#import "LogViewController.h"
#import "AppDelegate.h"
#import "ButtonAdd.h"
#import "RegViewController.h"
#import "LoginService.h"
#import "PasswordViewController.h"
#import "Single.h"
#import "NSUserDefautSet.h"
#import <UMSocialCore/UMSocialCore.h>
@interface LogViewController (){
    LoginService *loginServic;
    Single *sing;
    NSUserDefautSet *defaultSet;
    AppDelegate *app;
}
@end
@implementation LogViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
//  self.userImageView.layer.cornerRadius =self.userImageView.frame.size.height/2;
    self.userImageView.layer.cornerRadius =10;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.masksToBounds =YES;
    
    self.regBtn1.layer.masksToBounds =YES;
    self.regBtn1.layer.cornerRadius =YES;
    self.regBtn1.layer.cornerRadius =10;
    
    loginServic = [[LoginService alloc]init];
    defaultSet = [[NSUserDefautSet alloc]init];
    sing = [Single Send];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"navBackBtn@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
     _weixinBtn.hidden = YES;
     _forgetpassWord.hidden = YES;
}

-(void)navLeftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logClick:(id)sender {
    ButtonAdd *length = [[ButtonAdd alloc]init];
    if ([length checkInput:self.telePhoneNumber.text]||[length checkInput:self.passwordText.text]) {
         [CommoneTools alertOnView:self.view content:@"请填写完整"];
    }
    else{
       NSString     *url = [NSString stringWithFormat:@"%@%@",USERURL,@"api/Account/MemberMobileLogin"];
       NSDictionary *dic =@{@"mobileNum":self.telePhoneNumber.text,@"password":self.passwordText.text};
       [self loginuser:url dic:dic title:@"Members"];
     }
}

- (IBAction)forgetPasswordBtn:(id)sender {
    
}

- (IBAction)regBtn:(id)sender {
    RegViewController *RegVC = [[RegViewController alloc]initWithNibName:@"RegViewController" bundle:nil];
    [self.navigationController pushViewController:RegVC animated:YES];
}

- (IBAction)QQLog:(id)sender {
    UMSocialPlatformType platformType = UMSocialPlatformType_Sina;
    [self sendUMeng:platformType ];
}

- (IBAction)weiboLog:(id)sender {
    UMSocialPlatformType platformType = UMSocialPlatformType_WechatSession;
    [self sendUMeng:platformType ];
}

- (IBAction)weixinlog:(id)sender{
    UMSocialPlatformType platformType = UMSocialPlatformType_Linkedin;
    [self sendUMeng:platformType ];
}

-(void)sendUMeng:(UMSocialPlatformType)PlatformType{
    [[UMSocialManager defaultManager] authWithPlatform:PlatformType currentViewController:self completion:^(id result, NSError *error) {
    UMSocialResponse *response = result;

        NSString *message = nil;
        if (error) {
            message = @"登录失败";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
//            [[UMSocialManager defaultManager]cancelAuthWithPlatform:PlatformType completion:^(id result, NSError *error) {
//            }];
            NSString     *url ;
            NSDictionary *dic ;
            switch (PlatformType) {
                case 0:
                    url = [NSString stringWithFormat:@"%@%@",USERURL,@"api/Account/MemberWeiboLogin"];
                    dic = @{
                            @"uid":response.uid,
                            @"access_token":response.accessToken
                            };
                    [self loginuser:url dic:dic title:@"Members"];
                break;
                    
                case 1:
                    url = [NSString stringWithFormat:@"%@%@",USERURL,@"api/Account/MemberWeixinLogin"];
                    dic = @{
                            @"openid":response.openid,
                            @"access_token":response.accessToken
                            };
                   [self loginuser:url dic:dic title:@"Members"];
                break;
                    
                default:
                    break;

            }
          }
    }];
}

-(void)loginuser:(NSString *)url dic:(NSDictionary *)dic title:(NSString *)title{
    [loginServic login:url dic:dic title:title successBlock:^(NSMutableDictionary *dic) {
        if ([dic[@"Flag"] isEqualToString:@"S"]) {
            sing.ID = [dic[@"UserID"] intValue];
            sing.Token =dic[@"Token"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
   //登录数据的基本存储
     [defaultSet loginDataStorage:sing.ID Token:sing.Token];
    } failuerBlock:^(NSString *str) {
        
    }];
}
@end
