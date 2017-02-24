//
//  SXMy.m
//  lawker
//
//  Created by ASW on 2016-12-6.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXMy.h"
#import "SXNetworkTools.h"
#import "AppDelegate.h"
#import "NSString+MD5.h"
#import "SXAddresCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AreaPickView.h"

@interface SXMy ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate,btnClicked2Delegate>

@property(nonatomic,strong) NSMutableArray *arrayList;

@property (weak, nonatomic) IBOutlet UITextField *user;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker2;

@property (weak, nonatomic) IBOutlet UIButton *tt2;
@property (weak, nonatomic) IBOutlet UIButton *tt3;
@property (weak, nonatomic) IBOutlet UITextField *tt4;
@property (weak, nonatomic) IBOutlet UIView *sex;
@property (weak, nonatomic) IBOutlet UITextField *tt5;
@property (weak, nonatomic) IBOutlet UITextField *tt6;
@property (weak, nonatomic) IBOutlet UITextField *tt7;
@property (weak, nonatomic) IBOutlet UITextField *tt8;
@property (weak, nonatomic) IBOutlet UIView *t1;

@property (weak, nonatomic) IBOutlet UIView *t3;
@property (weak, nonatomic) IBOutlet UITableView *t2;
@property (weak, nonatomic) IBOutlet UIButton *b11;
@property (weak, nonatomic) IBOutlet UIButton *b22;
@property (weak, nonatomic) IBOutlet UIButton *b33;
@property (weak, nonatomic) IBOutlet UIButton *b44;
@property (weak, nonatomic) IBOutlet UIButton *b55;
@property (weak, nonatomic) IBOutlet UIView *t4;
@property (weak, nonatomic) IBOutlet UIImageView *gou;

@property(nonatomic,assign)BOOL update;

@property (nonatomic,copy) NSString *xieyi;

@property (weak,nonatomic) NSString *pass2;
@property (weak, nonatomic) IBOutlet UITextField *at1;
@property (weak, nonatomic) IBOutlet UITextField *at2;
@property (weak, nonatomic) IBOutlet UITextField *at3;
@property (weak, nonatomic) IBOutlet UIButton *at4;
@property (weak, nonatomic) IBOutlet UIView *sf;
@property (weak, nonatomic) IBOutlet UITextField *p1;
@property (weak, nonatomic) IBOutlet UITextField *p2;
@property (weak, nonatomic) IBOutlet UITextField *p3;

@end

@implementation SXMy

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(app.addres != 1){
        self.navigationItem.title = @"账户设置";
    }else{
        self.navigationItem.title = @"选择地址";
        _b11.hidden = YES;
        _b33.hidden = YES;
        _b55.hidden = NO;
        _b22.hidden = YES;
        _t2.hidden = NO;
        _t1.hidden = YES;
        _t3.hidden = YES;
        _b44.hidden = NO;
        _t4.hidden = YES;
        _sf.hidden = YES;
    }
    
    if(app.d3 == 1){
        _b33.hidden = YES;
        _t3.hidden = YES;
        self.b22.frame = CGRectMake(189, 0, 186, 35);
        self.b11.frame = CGRectMake(0, 0, 186, 35);
        self.b11.backgroundColor = [UIColor whiteColor];
        self.b22.backgroundColor = [UIColor whiteColor];
    }
    self.t2.delegate = self;
    self.t2.dataSource = self;
    self.t2.separatorStyle = NO;
    
    [self.t2 addHeaderWithTarget:self action:@selector(loadData2)];
    
    [self.t2 addFooterWithTarget:self action:@selector(loadMoreData2)];
    
    self.update = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _datePicker2.countDownDuration = 0;
    });
    
    [_datePicker2 addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [arr lastObject];
    
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    if(dic[@"uid"]){
        _user.text = dic[@"name"];
        _pass2 = dic[@"pass"];
        [_tt2 setTitle:dic[@"date"] forState:UIControlStateNormal];
        [_tt2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_tt3 setTitle:dic[@"sex"] forState:UIControlStateNormal];
        [_tt3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _tt4.text = dic[@"qq"];
        _tt5.text = dic[@"mail"];
        _tt6.text = dic[@"xue"];
        _tt7.text = dic[@"xiao"];
        _tt8.text = dic[@"nian"];
    }
}

-(void)dateChange:(id *)sender{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    [_tt2 setTitle:[dateformatter stringFromDate:_datePicker2.date] forState:UIControlStateNormal];
    _datePicker2.hidden = YES;
    [_tt2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([txt isEqualToString:@"密码修改成功"]){
            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        }else if([txt isEqualToString:@"保存成功"]){
            _t4.hidden = YES;
            _t2.hidden = NO;
            _t1.hidden = YES;
            _t3.hidden = YES;
            _b44.hidden = NO;
            self.navigationItem.title = @"账户设置";
            [self loadData2];
        }
    }];
    
    [alertCtrl addAction:Action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(void)buttonClick2:(NSString *)txt{
    [_at4 setTitle:txt forState:UIControlStateNormal];
    [_at4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _sf.hidden = YES;
}

- (IBAction)sf:(id)sender {
    AreaPickView *areaPick = [[AreaPickView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 323)];
    areaPick.backgroundColor = [UIColor whiteColor];
    areaPick.btnDelegate2=self;
    [_sf addSubview:areaPick];
    _sf.hidden = NO;
}

- (IBAction)xgmm:(id)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(_p1.text != app.pass){
        [self alert:@"原密码错误"];
        return;
    }
    if(_p2.text != _p3.text || _p3.text.length == 0){
        [self alert:@"确认密码与新密码不匹配"];
        return;
    }
    NSString *allUrlstring = [NSString stringWithFormat:@"/xgmm/%@/%ld/%@.html",_p3.text,(long)app.uid,app.pass];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [arr lastObject];
            
            NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
            
            NSDictionary *content = @{};
            
            [content writeToFile:filePath atomically:YES];
            
            AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            app.uid = 0;
            [self alert:@"密码修改成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

-(void)buttonClick:(int)sender{
    _t4.hidden = NO;
    _t2.hidden = YES;
    _t1.hidden = YES;
    _t3.hidden = YES;
    _b44.hidden = YES;
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    app.addid = sender;
    NSString *allUrlstring = [NSString stringWithFormat:@"/eaddres/%d/%ld/%@.html",sender,(long)app.uid,app.pass];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            _at1.text = temArray[0][@"name"];
            _at2.text = temArray[0][@"phone"];
            _at3.text = temArray[0][@"addres2"];
            [_at4 setTitle:temArray[0][@"addres"] forState:UIControlStateNormal];
            [_at4 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            if([temArray[0][@"tai"] isEqualToString:@"1"]){
                [self.gou setImage:[UIImage imageNamed:@"ico_make2"]];
                _xieyi = @"取消";
            }else{
                [self.gou setImage:[UIImage imageNamed:@"ico_make"]];
                _xieyi = @"";
            }
            
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    self.navigationItem.title = @"编辑地址";
}

- (IBAction)add2res:(id)sender {
    if(_at1.text.length == 0){
        [_at1 becomeFirstResponder];
        [self alert:@"请输入收货人"];
        return;
    }
    
    if(_at2.text.length == 0){
        [_at2 becomeFirstResponder];
        [self alert:@"请输入手机号"];
        return;
    }
    
    if(_at3.text.length == 0){
        [_at3 becomeFirstResponder];
        [self alert:@"请输入地址"];
        return;
    }
    
    if(_at4.titleLabel.text.length == 0){
        [self alert:@"请选择省市"];
        return;
    }
    
    if(_xieyi.length == 0){
        _xieyi = @"0";
    }else{
        _xieyi = @"1";
    }
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/add2res/%@/%@/%@/%@/%@/%ld/%ld/%@.html",[_at1.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_at2.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_at3.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_at4.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_xieyi,(long)app.addid,(long)app.uid,app.pass];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            [self alert:@"保存成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (IBAction)login:(id)sender {
    
    if(_user.text.length == 0){
        [_user becomeFirstResponder];
        [self alert:@"请输入姓名"];
        return;
    }
    
    if(_tt4.text.length == 0){
        [_tt4 becomeFirstResponder];
        [self alert:@"请输入qq"];
        return;
    }
    
    if(_tt5.text.length == 0){
        [_tt5 becomeFirstResponder];
        [self alert:@"请输入邮箱"];
        return;
    }
    
    if(_tt6.text.length == 0){
        [_tt6 becomeFirstResponder];
        [self alert:@"请输入学历"];
        return;
    }
    
    if(_tt7.text.length == 0){
        [_tt7 becomeFirstResponder];
        [self alert:@"请输入毕业院校"];
        return;
    }
    
    if(_tt8.text.length == 0){
        [_tt8 becomeFirstResponder];
        [self alert:@"请输入工作院校"];
        return;
    }
    
    if([self isValidateEmail:_tt5.text]==YES){
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/xg/%@/%@/%@/%@/%@/%@/%@/%@/%ld/%@.html",[_user.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt2.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt3.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt4.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt5.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt6.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt7.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[_tt8.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],(long)app.uid,app.pass];
    NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachePath = [arr lastObject];
            
            NSString *filePath = [cachePath stringByAppendingPathComponent:@"tese.plist"];
            
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
            
            NSDictionary *content = @{@"user":dic[@"user"],@"pass":dic[@"pass"],@"uid":dic[@"uid"],@"name":_user.text,@"qq":_tt4.text,@"sex":_tt3.titleLabel.text,@"date":_tt2.titleLabel.text,@"xue":_tt6.text,@"xiao":_tt7.text,@"nian":_tt8.text,@"mail":_tt5.text};
            
            [content writeToFile:filePath atomically:YES];
            [self alert:@"修改成功"];
        }else{
            [self alert:temArray[0][@"null"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
    }else{
        [_tt5 becomeFirstResponder];
        [self alert:@"邮箱格式错误"];
    }
}

- (IBAction)del:(UIButton*)sender {
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/daddres/%ld/%@/%ld.html",(long)app.uid,app.pass,(long)sender.tag];
    [self loadDataForType:3 withURL:allUrlstring];
}
- (IBAction)sex2:(id)sender {
    _sex.hidden = NO;
}
- (IBAction)date2:(id)sender {
    _datePicker2.hidden = NO;
}
- (IBAction)sex3:(id)sender {
    _sex.hidden = YES;
    [_tt3 setTitle:@"男" forState:UIControlStateNormal];
    [_tt3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
- (IBAction)sex4:(id)sender {
    _sex.hidden = YES;
    [_tt3 setTitle:@"女" forState:UIControlStateNormal];
    [_tt3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
- (IBAction)sex5:(id)sender {
    _sex.hidden = YES;
    [_tt3 setTitle:@"保密" forState:UIControlStateNormal];
    [_tt3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}
- (IBAction)b1:(id)sender {
    _t2.hidden = YES;
    _t1.hidden = NO;
    _t3.hidden = YES;
    _b44.hidden = YES;
    _t4.hidden = YES;
    _sf.hidden = YES;
    self.navigationItem.title = @"账户设置";
    [_b11 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)b2:(id)sender {
    _t2.hidden = NO;
    _t1.hidden = YES;
    _t3.hidden = YES;
    _b44.hidden = NO;
    _t4.hidden = YES;
    _sf.hidden = YES;
    self.navigationItem.title = @"账户设置";
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
- (IBAction)b3:(id)sender {
    _t2.hidden = YES;
    _t1.hidden = YES;
    _t3.hidden = NO;
    _b44.hidden = YES;
    _t4.hidden = YES;
    _sf.hidden = YES;
    self.navigationItem.title = @"账户设置";
    [_b11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b22 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_b33 setTitleColor:[UIColor colorWithRed:28.0f/255.0f green:77.0f/255.0f blue:153.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
}

- (IBAction)add:(id)sender {
    _t4.hidden = NO;
    _t2.hidden = YES;
    _t1.hidden = YES;
    _t3.hidden = YES;
    _b44.hidden = YES;
    
    _at1.text = @"";
    _at2.text = @"";
    _at3.text = @"";
    [_at4 setTitle:@"请选择省份" forState:UIControlStateNormal];
    [_at4 setTitleColor:[UIColor colorWithRed:199.0f/255.0f green:199.0f/255.0f blue:205.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    self.navigationItem.title = @"添加地址";
}

- (IBAction)xieyi:(id)sender {
    if(_xieyi.length == 0){
        [self.gou setImage:[UIImage imageNamed:@"ico_make2"]];
        _xieyi = @"取消";
    }else{
        [self.gou setImage:[UIImage imageNamed:@"ico_make"]];
        _xieyi = @"";
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/addres/%ld/%@.html",(long)app.uid,app.pass];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/addres/%ld/%@/%ld-20.html",(long)app.uid,app.pass,(long)(20 * app.navid)];
    
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.tableView headerBeginRefreshing];
        NSMutableArray *arrayM = [SXAddresModel objectArrayWithKeyValuesArray:temArray];
        
        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.t2 headerEndRefreshing];
            [self.t2 reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.t2 footerEndRefreshing];
            [self.t2 reloadData];
            app.navid = app.navid +1;
        }else{
            self.arrayList = arrayM;
            [self.t2 headerEndRefreshing];
            [self.t2 reloadData];
            //[self viewDidLoad];
            
            //SXOldiewController *load2 =[[SXOldiewController alloc]init];
            //load2.self.arrayList = arrayM;
            //[load2.self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.t2 headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //if(app.addres != 1){
    //    self.tabBarController.tabBar.hidden = NO;
    //}else{
    //    self.tabBarController.tabBar.hidden = YES;
    //}
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
    //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.t2 headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXAddresModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXAddresCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"addres";
    }
    SXAddresCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
   
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXAddresModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXAddresCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 130;
    }
    
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}


@end
