//
//  AreaPickView.m
//  AreaPickDemo
//


#import "AreaPickView.h"
#import "SXmy.h"
#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)

//当前tableview所处的状态
NS_ENUM(NSInteger,PickState) {
    ProvinceState,//选择省份状态
    CityState,//选择城市状态
};

@interface AreaPickView ()<UITableViewDelegate,UITableViewDataSource>

{
    NSString *selectedProvince;
}

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation AreaPickView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        [self initData];
        [self setUI];
        //首先赋值为选择省份状态
        PickState = ProvinceState;
    }
    return self;
}
#pragma mark 读取plist城市数据文件
-(void)initData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    //取出省份数据
    _provinceArr = [[NSArray alloc] initWithArray: provinceTmp];
    
}

-(void)setUI {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tableView];
    
    _selectLine = [[UIView alloc]initWithFrame:CGRectMake(10, 5, 1, 1)];
    _selectLine.backgroundColor = [UIColor blackColor];
    [self addSubview:_selectLine];
    _selectLine.hidden = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(PickState == ProvinceState) {
        
        return _provinceArr.count;
        
    }else{
        
        return _cityArr.count;
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(PickState == ProvinceState) {
        cell.textLabel.text = _provinceArr[indexPath.row];

    }else {
        cell.textLabel.text = _cityArr[indexPath.row];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectLine.hidden = NO;
    if(PickState == ProvinceState) {
        //当tableview所处为省份选择状态时，点击cell 进入城市选择状态
        PickState = CityState;
        selectedProvince = [_provinceArr objectAtIndex: indexPath.row];

        
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [_areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)indexPath.row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        //取出城市数据
        _cityArr = [[NSArray alloc] initWithArray: array];

    }else {
        
        [self.btnDelegate2 buttonClick2:[NSString stringWithFormat:@"%@-%@",selectedProvince,_cityArr[indexPath.row]]];
        
        self.hidden = YES;
    }

    [_tableView reloadData];
    
}
@end

