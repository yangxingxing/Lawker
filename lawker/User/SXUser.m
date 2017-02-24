//
//  SXUser.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXUser.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD.h"

@interface SXUser ()

@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UIView *user2;
@property (weak, nonatomic) IBOutlet UIView *user1;

@property (weak, nonatomic) IBOutlet UILabel *tuser;

@property (weak, nonatomic) IBOutlet UILabel *tuser2;

@property (weak, nonatomic) IBOutlet UILabel *size;

@end

@implementation SXUser

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(app.reh){
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
    
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if(dic[@"user"]&&dic[@"pass"]&&dic[@"uid"]){
        _user1.hidden = YES;
        _user2.hidden = NO;
        _user.text = dic[@"user"];
        _pass.text = dic[@"pass"];
        [self login:dic[@"uid"]];
    }
    
}

- (IBAction)qchc:(id)sender {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *docdir = [NSString stringWithFormat:@"%@/Documents/xz",NSHomeDirectory()];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docdir error:NULL];
    
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [docdir stringByAppendingPathComponent:aPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",docdir,aPath] error:nil];
        }
    }
    [self hcsize];
    [self alert:@"清除完成"];
}

-(void)hcsize{
    NSString *docdir = [NSString stringWithFormat:@"%@/Documents/xz",NSHomeDirectory()];
    
    NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docdir error:NULL];
    
    NSFileManager * fileManger = [NSFileManager defaultManager];
    NSInteger fileTotalSize = 0;
    //NSLog(@"%@",docdir);
    for (NSString *aPath in contentOfFolder) {
        NSString * fullPath = [docdir stringByAppendingPathComponent:aPath];
        BOOL isDir;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir)
        {
            NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",docdir,aPath] error:nil];
            fileTotalSize += [fileAttributes[NSFileSize] integerValue]/1000.0/1000;
            
        }
    }
    NSString *docdir2 = [NSString stringWithFormat:@"%@/Documents/hc",NSHomeDirectory()];
    
    NSArray *contentOfFolder2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docdir2 error:NULL];
    //NSLog(@"%@",docdir);
    for (NSString *aPath in contentOfFolder2) {
        NSString * fullPath = [docdir2 stringByAppendingPathComponent:aPath];
        BOOL isDir2;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir2] && !isDir2)
        {
            NSDictionary * fileAttributes = [fileManger attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",docdir2,aPath] error:nil];
            fileTotalSize += [fileAttributes[NSFileSize] integerValue]/1000.0/1000;
            
        }
    }
    if(fileTotalSize>1000){
        _size.text = [NSString stringWithFormat:@"%.1fGB",(float)fileTotalSize / (float)1000];
    }else{
        _size.text = [NSString stringWithFormat:@"%ldMB",(long)fileTotalSize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if(dic[@"user"]&&dic[@"pass"]&&dic[@"uid"]){
        _user1.hidden = YES;
        _user2.hidden = NO;
        _user.text = dic[@"user"];
        _pass.text = dic[@"pass"];
        [self login:dic[@"uid"]];
    }
    
    [self hcsize];
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil];
    
    [alertCtrl addAction:Action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(_user.text.length == 0){
        [_user becomeFirstResponder];
        [self alert:@"请输入用户名"];
        [hud hide:YES];
        return;
    }
    
    if(_pass.text.length == 0){
        [_pass becomeFirstResponder];
        [self alert:@"请输入密码"];
        [hud hide:YES];
        return;
    }
    
    NSString *allUrlstring = [NSString stringWithFormat:@"/login/%@/%@.html",[_user.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_pass.text];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            app.uid = [temArray[0][@"uid"] intValue];
            app.pass = _pass.text;
            app.addres = 0;
            app.wan = 0;
           [hud hide:YES];
            if([_user.text isEqualToString:@"QQ快捷登录用户"]||[_user.text isEqualToString:@"WX快捷登录用户"]||[_user.text isEqualToString:@"WB快捷登录用户"]){
            app.d3 = 1;
            }else{
            app.d3 = 0;
            }
            NSString *suid = [NSString stringWithFormat:@"%d",[temArray[0][@"uid"] intValue]];
            _user1.hidden = YES;
            _user2.hidden = NO;
            [self.view endEditing:YES];
            
            if(app.reh){
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            _tuser.text = [NSString stringWithFormat:@"%@ 您好",temArray[0][@"name"]];
            _tuser2.text = [NSString stringWithFormat:@"用户名 %@",temArray[0][@"user"]];
            
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [arr lastObject];
            
            NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
            
            NSDictionary *content = @{@"user":_user.text,@"pass":_pass.text,@"uid":suid,@"name":temArray[0][@"name"],@"qq":temArray[0][@"qq"],@"sex":temArray[0][@"sex"],@"date":temArray[0][@"date"],@"xue":temArray[0][@"xue"],@"xiao":temArray[0][@"xiao"],@"nian":temArray[0][@"nian"],@"mail":temArray[0][@"mail"]};
            
            [content writeToFile:filePath atomically:YES];
            
        }else{
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [arr lastObject];
            
            NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
            
            NSDictionary *content = @{};
            
            [content writeToFile:filePath atomically:YES];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            app.uid = 0;
            [hud hide:YES];
            _user1.hidden = NO;
            _user2.hidden = YES;
            _user.text = @"";
            _pass.text = @"";
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    
}
- (IBAction)wxlogin:(id)sender {
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             //NSLog(@"uid=%@",user.uid);
             //NSLog(@"%@",user.credential);
             //NSLog(@"token=%@",user.credential.token);
             //NSLog(@"nickname=%@",user.nickname);
             NSString *allUrlstring = [NSString stringWithFormat:@"/d2login/%@/%@.html",user.uid,[user.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             NSLog(@"%@",allUrlstring);
             [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
                 NSString *key = [responseObject.keyEnumerator nextObject];
                 
                 NSArray *temArray = responseObject[key];
                 
                 if([temArray[0][@"null"] isEqualToString:@"ok"]){
                     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                     app.uid = [temArray[0][@"uid"] intValue];
                     app.pass = user.uid;
                     app.addres = 0;
                     app.wan = 0;
                     app.d3 = 1;
                     NSString *suid = [NSString stringWithFormat:@"%d",[temArray[0][@"uid"] intValue]];
                     _user1.hidden = YES;
                     _user2.hidden = NO;
                     
                     if(app.reh){
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     
                     _tuser.text = [NSString stringWithFormat:@"%@ 您好",temArray[0][@"name"]];
                     _tuser2.text = [NSString stringWithFormat:@"用户名 %@",temArray[0][@"user"]];
                     
                     NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                     NSString *cachePath = [arr lastObject];
                     
                     NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
                     
                     NSDictionary *content = @{@"user":temArray[0][@"user"],@"pass":user.uid,@"uid":suid,@"name":temArray[0][@"name"],@"qq":temArray[0][@"qq"],@"sex":temArray[0][@"sex"],@"date":temArray[0][@"date"],@"xue":temArray[0][@"xue"],@"xiao":temArray[0][@"xiao"],@"nian":temArray[0][@"nian"],@"mail":temArray[0][@"mail"]};
                     
                     [content writeToFile:filePath atomically:YES];
                     
                 }else{
                     [self alert:temArray[0][@"null"]];
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 //NSLog(@"%@",error);
             }] resume];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         [hud hide:YES];
     }];
}
- (IBAction)wblogin:(id)sender {
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             //NSLog(@"uid=%@",user.uid);
             //NSLog(@"%@",user.credential);
             //NSLog(@"token=%@",user.credential.token);
             //NSLog(@"nickname=%@",user.nickname);
             NSString *allUrlstring = [NSString stringWithFormat:@"/d1login/%@/%@.html",user.uid,[user.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             NSLog(@"%@",allUrlstring);
             [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
                 NSString *key = [responseObject.keyEnumerator nextObject];
                 
                 NSArray *temArray = responseObject[key];
                 
                 if([temArray[0][@"null"] isEqualToString:@"ok"]){
                     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                     
                     app.uid = [temArray[0][@"uid"] intValue];
                     app.pass = user.uid;
                     app.addres = 0;
                     app.wan = 0;
                     app.d3 = 1;
                     NSString *suid = [NSString stringWithFormat:@"%d",[temArray[0][@"uid"] intValue]];
                     _user1.hidden = YES;
                     _user2.hidden = NO;
                     
                     if(app.reh){
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     
                     _tuser.text = [NSString stringWithFormat:@"%@ 您好",temArray[0][@"name"]];
                     _tuser2.text = [NSString stringWithFormat:@"用户名 %@",temArray[0][@"user"]];
                     
                     NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                     NSString *cachePath = [arr lastObject];
                     
                     NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
                     
                     NSDictionary *content = @{@"user":temArray[0][@"user"],@"pass":user.uid,@"uid":suid,@"name":temArray[0][@"name"],@"qq":temArray[0][@"qq"],@"sex":temArray[0][@"sex"],@"date":temArray[0][@"date"],@"xue":temArray[0][@"xue"],@"xiao":temArray[0][@"xiao"],@"nian":temArray[0][@"nian"],@"mail":temArray[0][@"mail"]};
                     
                     [content writeToFile:filePath atomically:YES];
                     
                 }else{
                     [self alert:temArray[0][@"null"]];
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 //NSLog(@"%@",error);
             }] resume];
         }
         
         else
         {
             [self alert:@"获取授权失败"];
         }
         [hud hide:YES];
     }];
}

- (IBAction)qqlogin:(id)sender {
    //例如QQ的登录
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             //NSLog(@"uid=%@",user.uid);
             //NSLog(@"%@",user.credential);
             //NSLog(@"token=%@",user.credential.token);
             //NSLog(@"nickname=%@",user.nickname);
             NSString *allUrlstring = [NSString stringWithFormat:@"/d3login/%@/%@.html",user.uid,[user.nickname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
             NSLog(@"%@",allUrlstring);
             [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
                 NSString *key = [responseObject.keyEnumerator nextObject];
                 
                 NSArray *temArray = responseObject[key];
                 
                 if([temArray[0][@"null"] isEqualToString:@"ok"]){
                     AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                     
                     app.uid = [temArray[0][@"uid"] intValue];
                     app.pass = user.uid;
                     app.addres = 0;
                     app.wan = 0;
                     app.d3 = 1;
                     NSString *suid = [NSString stringWithFormat:@"%d",[temArray[0][@"uid"] intValue]];
                     _user1.hidden = YES;
                     _user2.hidden = NO;
                     
                     if(app.reh){
                         [self.navigationController popViewControllerAnimated:YES];
                     }
                     
                     _tuser.text = [NSString stringWithFormat:@"%@ 您好",temArray[0][@"name"]];
                     _tuser2.text = [NSString stringWithFormat:@"用户名 %@",temArray[0][@"user"]];
                     
                     NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                     NSString *cachePath = [arr lastObject];
                     
                     NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
                     
                     NSDictionary *content = @{@"user":temArray[0][@"user"],@"pass":user.uid,@"uid":suid,@"name":temArray[0][@"name"],@"qq":temArray[0][@"qq"],@"sex":temArray[0][@"sex"],@"date":temArray[0][@"date"],@"xue":temArray[0][@"xue"],@"xiao":temArray[0][@"xiao"],@"nian":temArray[0][@"nian"],@"mail":temArray[0][@"mail"]};
                     
                     [content writeToFile:filePath atomically:YES];

                 }else{
                     [self alert:temArray[0][@"null"]];
                 }
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 //NSLog(@"%@",error);
             }] resume];
         }
         
         else
         {
             [self alert:@"获取授权失败"];
         }
         [hud hide:YES];
     }];
}

- (IBAction)logout:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    app.uid = 0;
    _user1.hidden = NO;
    _user2.hidden = YES;
    _user.text = @"";
    _pass.text = @"";
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
    
    NSDictionary *content = @{};
    
    [content writeToFile:filePath atomically:YES];
}

@end
