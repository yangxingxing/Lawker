//
//  SXHcCell.m
//  lawker
//
//  Created by ASW on 2016-11-28.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "SXHcCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "ZFDownloadManager.h"

@interface SXHcCell ()

@end

@implementation SXHcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    CGFloat topEdge = 20 * ScreenRate;
    CGFloat viewHight = 110 * ScreenRate;
    CGFloat iconImgHeight = viewHight - 2 * topEdge;
    _iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(20, topEdge, iconImgHeight * 1.5, iconImgHeight)];
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImg];
    
    _titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame) + 10, _iconImg.y, SCREEN_W - CGRectGetMaxX(_iconImg.frame) - 30, iconImgHeight / 2 + 5)];
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = UITextFont;
    _titleLabel.textColor = textBlackColor;
    [self.contentView addSubview:_titleLabel];
    
    _downLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W - (SCREEN_W - 20) / 5 - 20, CGRectGetMaxY(_iconImg.frame) - 30, (SCREEN_W - 20) / 5, 30)];
    [_downLoadBtn setTitle:@"暂停缓存" forState:UIControlStateNormal];
    [_downLoadBtn setTitle:@"继续缓存" forState:UIControlStateSelected];
    [_downLoadBtn setTitleColor:textBlueWColor forState:UIControlStateNormal];
    _downLoadBtn.titleLabel.font = [UIView lightFontWithSize:16];
    _downLoadBtn.layer.borderWidth = 1;
    _downLoadBtn.layer.borderColor = [textBlueWColor CGColor]; //  #1c4d99
    _downLoadBtn.layer.cornerRadius = 2;
    _downLoadBtn.layer.masksToBounds = YES;
    [_downLoadBtn addTarget:self action:@selector(buttonClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_downLoadBtn];
    
    _cashLabel =  [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.x, _downLoadBtn.y, _downLoadBtn.x - _titleLabel.x - 5 , _downLoadBtn.height)];
    _cashLabel.numberOfLines = 2;
    _cashLabel.textColor = textBlueWColor;
    _cashLabel.font = [UIView lightFontWithSize:13];
    [self.contentView addSubview:_cashLabel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longGres{
    if (longGres.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressGestureClick:)]) {
            [self.delegate longPressGestureClick:self];
        }
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (void)buttonClick1:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
//        NSString *writtenSize = [self returnSize:(unsigned long long)_downLoadModel.progress.totalBytesWritten];
        NSUInteger receivedSize = ZFDownloadLength(_sessionModel.url);
        NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                                 [_sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                                 [_sessionModel calculateUnit:(unsigned long long)receivedSize]];
        self.cashLabel.text =[NSString stringWithFormat:@"已缓存：%@",writtenSize];
    } 
    if (self.downloadBlock) {
        self.downloadBlock(sender);
    }
}

/**
 *  model setter
 *
 *  @param sessionModel sessionModel
 */
- (void)setSessionModel:(ZFSessionModel *)sessionModel
{
    _sessionModel = sessionModel;
    self.titleLabel.text = sessionModel.hcModel.title;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:sessionModel.hcModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    NSUInteger receivedSize = ZFDownloadLength(sessionModel.url);
    NSString *writtenSize = [NSString stringWithFormat:@"%.1f%@",
                             [sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                             [sessionModel calculateUnit:(unsigned long long)receivedSize]];
//    CGFloat progress = 1.0 * receivedSize / sessionModel.totalLength;
    
    switch (sessionModel.state) {
        case DownloadStateStart:
        case DownloadStateSuspended:
            self.downLoadBtn.hidden = NO;
            self.downLoadBtn.selected = YES;
            self.cashLabel.text =[NSString stringWithFormat:@"已缓存：%@",writtenSize];
            break;
        case DownloadStateCompleted:
            self.cashLabel.text =[NSString stringWithFormat:@"下载完成%@",sessionModel.totalSize];
            self.cashLabel.textColor = GrayColor;
            break;
        case DownloadStateFailed:
            self.cashLabel.text = @"下载失败";
            self.cashLabel.textColor = GrayColor;
            self.downLoadBtn.hidden = NO;
            self.downLoadBtn.selected = NO;
            [self.downLoadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)setDownLoadModel:(TYDownloadModel *)downLoadModel {
    _downLoadModel = downLoadModel;
    self.titleLabel.text = downLoadModel.hcModel.title;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:downLoadModel.hcModel.imgsrc] placeholderImage:[UIImage imageNamed:@"302"]];
    NSString *writtenSize = [self returnSize:(unsigned long long)downLoadModel.progress.totalBytesWritten];
    NSString *totalSize = [self returnSize:(unsigned long long)downLoadModel.progress.totalBytesExpectedToWrite];
    
    switch (downLoadModel.state) {
        case TYDownloadStateNone:
        case TYDownloadStateReadying:
            self.cashLabel.text = @"等待下载";
            break;
        case TYDownloadStateRunning:
            self.downLoadBtn.hidden = NO;
            self.downLoadBtn.selected = NO;
            self.cashLabel.text = [NSString stringWithFormat:@"缓存中:%@/%@",writtenSize,totalSize];
            break;
        case TYDownloadStateSuspended:
            self.downLoadBtn.hidden = NO;
            self.downLoadBtn.selected = YES;
            self.cashLabel.text =[NSString stringWithFormat:@"已缓存：%@",writtenSize];
            break;
        case TYDownloadStateCompleted:
            self.cashLabel.text =[NSString stringWithFormat:@"下载完成%@",totalSize];
            self.cashLabel.textColor = GrayColor;
            break;
        case TYDownloadStateFailed:
            self.cashLabel.text = @"下载失败";
            self.cashLabel.textColor = GrayColor;
            self.downLoadBtn.hidden = NO;
            self.downLoadBtn.selected = NO;
            [self.downLoadBtn setTitle:@"重新下载" forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (NSString *)returnSize:(unsigned long long)totalBytesExpectedToWrite {
    return [NSString stringWithFormat:@"%.1f%@",
            [TYDownloadUtility calculateFileSizeInUnit:(unsigned long long)totalBytesExpectedToWrite],
            [TYDownloadUtility calculateUnit:(unsigned long long)totalBytesExpectedToWrite]];
}


@end
