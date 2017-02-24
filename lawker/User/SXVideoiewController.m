//
//  SXVideoiewController.m
//  lawker
//
//  Created by ASW on 2016-11-26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//


#import "SXVideoiewController.h"
#import "SXVideoCell.h"
#import "SXNetworkTools.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface SXVideoiewController ()<UITableViewDataSource,UITableViewDelegate,btnClickedDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) NSMutableArray *arrayList;

@property(nonatomic,assign)BOOL update;
@property (weak, nonatomic) IBOutlet UIView *a1;
@property (weak, nonatomic) IBOutlet UITableView *t3;
@property (weak, nonatomic) IBOutlet UIButton *b2;
@property (weak, nonatomic) IBOutlet UIView *a4;
@property (weak, nonatomic) IBOutlet UIImageView *i5;
@property (weak, nonatomic) IBOutlet UIButton *a6;
@property (weak, nonatomic) IBOutlet UIImageView *i7;
@property (weak, nonatomic) IBOutlet UITextField *t8;
@property (weak, nonatomic) IBOutlet UITextField *t9;
@property (weak, nonatomic) IBOutlet UILabel *i7img;
@property (weak, nonatomic) IBOutlet UIImageView *noimg;

@end

@implementation SXVideoiewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.t3.delegate = self;
    self.t3.dataSource = self;
    self.t3.separatorStyle = NO;
    
    [self.t3 addHeaderWithTarget:self action:@selector(loadData2)];
    
    self.update = YES;
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [self.t3 addFooterWithTarget:self action:@selector(loadMoreData2)];
    self.navigationItem.title = @"我的视频";
    //[self.t3 setEditing:YES animated:YES];

    app.navid = 1;
    
}
- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)loadData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/video/%ld/%@.html",(long)app.uid,app.pass];
    [self loadDataForType:1 withURL:allUrlstring];
}

- (void)loadMoreData2
{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/video/%ld/%@/%ld-20.html",(long)app.uid,app.pass,(long)(20 * app.navid)];
   
    [self loadDataForType:2 withURL:allUrlstring];
}

- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        //[self.t3 headerBeginRefreshing];
        NSMutableArray *arrayM = [SXVideoModel objectArrayWithKeyValuesArray:temArray];

        AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.t3 headerEndRefreshing];
            [self.t3 reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.t3 footerEndRefreshing];
            [self.t3 reloadData];
            app.navid = app.navid +1;
        }else{
            self.arrayList = arrayM;
            [self.t3 headerEndRefreshing];
            [self.t3 reloadData];
            //[self viewDidLoad];
            
            //SXVideoiewController *load2 =[[SXVideoiewController alloc]init];
            //load2.self.arrayList = arrayM;
            //[load2.self.t3 reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

- (void)welcome
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"update"];
    [self.t3 headerBeginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"update"]) {
        return;
    }
        //NSLog(@"bbbb");
    if (self.update == YES) {
        [self.t3 headerBeginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

-(void)buttonClick{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
        UIViewController *jview = [storyboard instantiateViewControllerWithIdentifier:@"AdvancedBarrageController"];
        [self.navigationController pushViewController:jview animated:YES];    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.arrayList.count==0){_noimg.hidden = NO;}else{_noimg.hidden = YES;}
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXVideoModel *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXVideoCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"Video";
    }
    SXVideoCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    cell.btnDelegate =self;
    
    return cell;
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXVideoModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [SXVideoCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 200;
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
- (IBAction)addv:(id)sender {
    _t3.hidden = YES;
    _a1.hidden = YES;
    _a4.hidden = NO;
    _b2.hidden = YES;
}
- (IBAction)alertShow:(id)sender {
    [self alertControllerShow];
}

#pragma mark - UIAlertController
- (void) alertControllerShow {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *cameralButton = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imageCameral = [[UIImagePickerController alloc] init];
            imageCameral.sourceType = sourceType;
            imageCameral.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imageCameral.delegate = self;
            imageCameral.allowsEditing = YES;
            [self presentViewController:imageCameral animated:YES completion:nil];
            
        }else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持照相功能" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction *photoButton = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIImagePickerController *imagePhoto = [[UIImagePickerController alloc] init];
        imagePhoto.sourceType = sourceType;
        imagePhoto.delegate = self;
        imagePhoto.allowsEditing = YES;
        [self presentViewController:imagePhoto animated:YES completion:nil];
        
    }];
    
    [alert addAction:cancelButton];
    [alert addAction:cameralButton];
    [alert addAction:photoButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIAlertControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _i7.image = image;
    _a6.hidden = YES;
    _i7.hidden = NO;
    _i5.hidden = YES;
    [self saveImage:image withName:[self currentDate]];
}

#pragma mark - action
//设置头像
- (void)setIconImage {
    [self alertControllerShow];
}

//保存图片
- (void) saveImage:(UIImage *)image withName:(NSString *)imageName {
    NSData *currentImage = UIImageJPEGRepresentation(image, 1.0);
    NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"photoAlbum"];
    NSString *photoPath = [file stringByAppendingPathComponent:imageName];
    [currentImage writeToFile:photoPath atomically:YES];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self uploadPhotoAndController:image];
}

-(void)alert:(NSString *)txt{
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"lawker提示" message:txt preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([txt isEqualToString:@"添加成功"]){
            [self loadData2];
            _t3.hidden = NO;
            _a1.hidden = NO;
            _a4.hidden = YES;
            _b2.hidden = NO;
            
            _a6.hidden = NO;
            _i7.hidden = YES;
            _i5.hidden = NO;
            _t8.text = @"";
            _t9.text = @"";
        }
    }];
    
    [alertCtrl addAction:Action];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (IBAction)addve:(id)sender {
    if(_t8.text.length == 0){
        [_t8 becomeFirstResponder];
        [self alert:@"请输入标题"];
        return;
    }
    
    if(_t9.text.length == 0){
        [_t9 becomeFirstResponder];
        [self alert:@"请输入视频地址"];
        return;
    }
    
    if (_i7img.text.length == 0) {
        [self alert:@"还没有上传图片"];
        return;
    }
    
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *allUrlstring = [NSString stringWithFormat:@"/addv/%ld/%@/%@/%@/%@.html",(long)app.uid,app.pass,_t8.text,_t9.text,_i7img.text];
    //NSLog(@"%@",allUrlstring);
    [[[SXNetworkTools sharedNetworkTools]GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        if([temArray[0][@"null"] isEqualToString:@"ok"]){
            [self alert:@"添加成功"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //NSLog(@"%@",error);
    }] resume];
}

//设置照片的名称保存格式
- (NSString *) currentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    return currentDateString;
}

//上传图片(单张)
-(void)uploadPhotoAndController:(UIImage*)image
{
    MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString * url = [NSString stringWithFormat:@"http://lawker.cn/update"];
    
    //4. 发起网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        NSData *data = UIImagePNGRepresentation(image);
        //这个就是参数
        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        //NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
        hud.labelText = [NSString stringWithFormat:@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        _i7img.text = result;
        [hud hide:YES];
        //NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hud hide:YES];
        //请求失败
        //NSLog(@"请求失败：%@",error);
    }];
}

@end
