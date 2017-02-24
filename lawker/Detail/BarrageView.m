//
//  BarrageView.h
//  BarrageTest
//
//  Created by victor on 9/8/15.
//  Copyright © 2015 vcitor. All rights reserved.
//

#import "BarrageView.h"

@interface BarrageView()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *attributedCommentArray;

@end

@implementation BarrageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attributedCommentArray = [NSMutableArray new];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.attributedCommentArray = [NSMutableArray new];
    }
    return self;
}
-(void)openBarrage
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    for(NSString *string in self.commentArray){
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedStr addAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor] ,NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]} range:NSMakeRange(0, string.length)];
        [self.attributedCommentArray addObject:attributedStr];
        
    }
    [self initLayer];
}

-(void)addMyComment:(NSString *)comment
{
    NSMutableAttributedString *attrComment = [[NSMutableAttributedString alloc] initWithString:comment];
    [attrComment addAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]} range:NSMakeRange(0, comment.length)];
    [self.attributedCommentArray addObject:attrComment];
}

-(void)closeBarrage
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        [self.attributedCommentArray removeAllObjects];
    }
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
}

-(void)initLayer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(createLabel) userInfo:nil repeats:YES];
}

-(void)createLabel
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    
    NSMutableAttributedString *textObject = [self.attributedCommentArray lastObject];
    label.attributedText = textObject;
    [self.attributedCommentArray removeLastObject];
    [self.attributedCommentArray insertObject:textObject atIndex:0];
    
  
    [self addSubview:label];
    
    CGSize size = [label.attributedText.string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:15.0f]}];
    
    CGFloat windowHeight = self.frame.size.height;
    CGFloat windowWidth = self.frame.size.width;
    
    CGFloat yPosition = arc4random()%(((int)windowHeight)/20) * 20.0;
    
    
    CGRect frame = CGRectMake(windowWidth, yPosition, size.width, size.height);
    label.frame = frame;
    
    [self animationWithView:label];
    
}

-(void)animationWithView:(UIView *)view
{
    int random = arc4random()%6;
    CGFloat duration = random + 3.0;
    CGPoint endPoint = CGPointMake(0 - view.frame.size.width, view.frame.origin.y);
    CGRect endRect = CGRectMake(endPoint.x, endPoint.y, view.frame.size.width, view.frame.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        //[self translationToLeftWithView:view];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [view setFrame:endRect];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}



-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
@end
