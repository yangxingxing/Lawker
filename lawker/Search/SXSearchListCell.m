//
//  SXSearchListCell.m
//  lawker
//
//  Created by dongshangxian on 16/1/27.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXSearchListCell.h"
#import "UILabel+Wonderful.h"

@interface SXSearchListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation SXSearchListCell

//- (void)awakeFromNib {
    // Initialization code
//}

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *ID = @"SXSearchListCell";
    SXSearchListCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SXSearchListCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)setModel:(SXSearchListEntity *)model
{
    _model = model;
    NSMutableString *mstring = [model.title mutableCopy];
    [mstring replaceOccurrencesOfString:@"<em>" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstring.length)];
    [mstring replaceOccurrencesOfString:@"</em>" withString:@">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstring.length)];
    
    [self.titleLbl setColorText:mstring];
    self.timeLbl.text = model.ptime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
