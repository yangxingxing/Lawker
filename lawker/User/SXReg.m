//
//  SXReg.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXReg.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"

@interface SXReg ()

@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *rpass;
@property (weak, nonatomic) IBOutlet UITextField *phone;

@property (nonatomic,copy) NSString *xieyi;
@property (weak, nonatomic) IBOutlet UIImageView *gou;

@end

@implementation SXReg

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([txt isEqualToString:@"注册成功"]){
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }
    }];
    
    [alertCtrl addAction:Action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}
- (IBAction)login2:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)login:(id)sender {
    
    if(_xieyi.length > 0){
        [self alert:@"必须同意用户协议"];
        return;
    }
    
    if(_user.text.length == 0){
        [_user becomeFirstResponder];
        [self alert:@"请输入用户名"];
        return;
    }
    
    if(_pass.text.length == 0){
        [_pass becomeFirstResponder];
        [self alert:@"请输入密码"];
        return;
    }
    
    if(_pass.text != _rpass.text){
        [_pass becomeFirstResponder];
        [self alert:@"两次密码不一致"];
        return;
    }
    
    if(_phone.text.length == 0){
        [_phone becomeFirstResponder];
        [self alert:@"请输入手机号"];
        return;
    }
    
    if(_pass.text.length < 6){
        [_pass becomeFirstResponder];
        [self alert:@"请输入6位以上密码"];
        return;
    }
    
    if(_phone.text.length != 11){
        [_phone becomeFirstResponder];
        [self alert:@"手机号错误"];
        return;
    }
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/reg/%@/%@/%@.html",_user.text,[NSString md5To32bit:_pass.text],_phone.text];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            [self alert:@"注册成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}
- (IBAction)xieyi:(id)sender {
    if(_xieyi.length == 0){
        [self.gou setImage:[UIImage imageNamed:@"ico_make"]];
        _xieyi = @"取消";
    }else{
        [self.gou setImage:[UIImage imageNamed:@"ico_make2"]];
        _xieyi = @"";
    }
}

@end
