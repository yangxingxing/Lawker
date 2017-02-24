//
//  SXWang.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXWang.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"

@interface SXWang ()

@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIView *npass;
@property (weak, nonatomic) IBOutlet UITextField *sms;
@property (weak, nonatomic) IBOutlet UITextField *xpass;
@property (weak, nonatomic) IBOutlet UITextField *rpass;

@end

@implementation SXWang

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([txt isEqualToString:@"重置成功"]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [alertCtrl addAction:Action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    
    //[self alert:@"未配置短信接口"];

    if(_user.text.length == 0){
        [_user becomeFirstResponder];
        [self alert:@"请输入用户名"];
        return;
    }
    
    if(_pass.text.length == 0){
        [_pass becomeFirstResponder];
        [self alert:@"请输入手机号"];
        return;
    }
    //http://lawker.cn/android/pass.php?phone=" + username + "&tel=" + the_tel
    NSString *allUrlstring = [NSString stringWithFormat:@"/wang/%@/%@.html",_user.text,_pass.text];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            _npass.hidden = NO;
            [self alert:@"发送成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}
- (IBAction)login2:(id)sender {
    if(_sms.text.length == 0){
        [_sms becomeFirstResponder];
        [self alert:@"请输入验证码"];
        return;
    }
    
    if(_xpass.text.length == 0){
        [_xpass becomeFirstResponder];
        [self alert:@"请输入新密码"];
        return;
    }
    
    if(_rpass.text.length == 0){
        [_rpass becomeFirstResponder];
        [self alert:@"请输入确认密码"];
        return;
    }
    
    if(_rpass.text!=_xpass.text){
        [_rpass becomeFirstResponder];
        [self alert:@"两次密码不一致"];
        return;
    }
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/wang2/%@/%@/%@/%@.html",_user.text,_pass.text,_sms.text,_rpass.text];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            [self alert:@"重置成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}

@end
