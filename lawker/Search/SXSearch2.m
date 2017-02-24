//
//  SXSearch2.m
//  lawker
//
//  Created by dongshangxian on 16/1/26.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXSearch2.h"
#import "UIView+Frame.h"
#import "NSString+Base64.h"
#import "SXSearchListEntity.h"
#import "SXSearchListCell.h"
#import "SXNewsModel.h"
#import "SXDetailController.h"
#import "UIImageView+WebCache.h"

@interface SXSearch2 ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *beginView;
@property (weak, nonatomic) IBOutlet UIScrollView *hotWordView;

@property(nonatomic,assign)CGFloat maxRight;
@property(nonatomic,assign)CGFloat maxBottom;

@property(nonatomic,strong)NSArray<SXSearchListEntity *> *searchListArray;
@property(nonatomic,strong)NSArray *hotwordArray;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation SXSearch2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = 80;
    self.hotWordView.bounces = YES;
    self.maxRight = 0;
    self.maxBottom = 10;
    self.hotWordView.contentSize = self.hotWordView.frame.size;
    

    self.navigationItem.title = @"观看记录";
    
    if (self.keyword.length > 0) {
        //self.searchBar.text = self.keyword;
        //[self searchBarSearchButtonClicked:self.searchBar];
    }
    
    NSString *url = [NSString stringWithFormat:@"http://localhost/hotword/2.html"];
    [[SXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        self.hotwordArray = responseObject[@"hotWordList"];
        [self addKeyWordBtnWithTitle:self.hotwordArray];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXSearchListCell *cell = [SXSearchListCell cellWithTableView:tableView];
    cell.model = self.searchListArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SXSearchListCell" owner:nil options:nil][1];
    return cell;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    //NSLog(@"%@",searchBar.text);
    [searchBar resignFirstResponder];
    
    NSString *searchKeyWord = [searchBar.text base64encode];
    NSString *url = [NSString stringWithFormat:@"http://localhost/ss.php?ss=%@",searchKeyWord];
    //http://c.3g.163.com/search/comp/MA==/20/%@.html
    //    __weak SXSearchPage *weakSelf = self;
    [[SXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSArray *dictArray = responseObject[@"doc"][@"result"];
        self.searchListArray = [SXSearchListEntity objectArrayWithKeyValuesArray:dictArray];
        [self.tableView reloadData];
        self.beginView.hidden = YES;
        self.tableView.hidden = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"%@",error.userInfo);
    }];
}

- (void)addKeyWordBtnWithTitle:(NSArray *)title
{
    _lblTitle.text = title[0][@"title"];
    
    [_imgIcon sd_setImageWithURL:[NSURL URLWithString:title[0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.maxRight, self.maxBottom, 0, 0)];
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:15];
//    //    [button setBackgroundImage:[UIImage imageNamed:@"night_contentview_votebutton"] forState:UIControlStateNormal];
//    button.layer.borderWidth = 0.5;
//    button.layer.borderColor = SXRGBColor(220, 220, 220).CGColor;
//    button.layer.cornerRadius = 2;
//    button.layer.masksToBounds = YES;
//    [button sizeToFit];
//    
//    button.width += 15;
//    button.height = 34 ;
//    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.hotWordView addSubview:button];
//    self.maxRight = button.width + button.x + 10;
//    
//    if (self.maxRight > self.hotWordView.width) {
//        self.maxRight = 0;
//        self.maxBottom += 48;
//        button.x = self.maxRight;
//        button.y = self.maxBottom;
//        self.maxRight = button.width + button.x + 10;
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SXNewsModel *model = [[SXNewsModel alloc]init];
    model.docid = [self.searchListArray[indexPath.row] docid];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"News" bundle:nil];
    SXDetailController *devc = (SXDetailController *)[sb instantiateViewControllerWithIdentifier:@"SXDetailController"];
    devc.newsModel = model;
    [self.navigationController pushViewController:devc animated:YES];
    
}

- (void)buttonClick:(UIButton *)sender
{
    self.searchBar.text = sender.titleLabel.text;
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
