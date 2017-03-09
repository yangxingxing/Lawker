//
//  WTPayManager.m
//  WT_Pay
//
//  Created by Mac on 16/7/5.
//  Copyright © 2016年 wutong. All rights reserved.
//

#import "WTPayManager.h"
#import "payRequsestHandler.h"
#import "Order.h"
#import "DataSigner.h"

@interface WTPayManager ()<NSCopying,WXApiDelegate>
@property (nonatomic, copy)WTPayResultBlock result;
@end

@implementation WTPayManager

+ (void)initialize
{
    [WTPayManager shareWTPayManager];
}


static WTPayManager * _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance setRegisterApps];
    });
    return _instance;
}

+ (instancetype)shareWTPayManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
        [_instance setRegisterApps];
    });
    return _instance;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    return _instance;
}



// 注册appid
- (void)setRegisterApps
{    // 微信注册
    [WXApi registerApp:kWXAppID];
}

+ (void)wtPayOrderItem:(WTPayOrderItem *)orderItem payType:(WTPayType)type result:(WTPayResultBlock)result
{
    [WTPayManager shareWTPayManager].result = result;
    if (type == WTPayTypeWeixin) {
        [WTPayManager weixinPayWithOrderItem:orderItem];
    }else if (type == WTPayTypeAli){
        [WTPayManager aliPayWithOrderItem:orderItem];
    }
}
+ (void)aliPayWithOrderItem:(WTPayOrderItem *)orderItem
{
    
}

- (void)handleAlipayResponse:(NSDictionary *)resultDic
{
    
//    resultDic;
    NSLog(@"%@", resultDic);
    
    if ([resultDic[@"resultStatus"] integerValue] != WTPayAilPayResultTypeSucess) {
        
        NSString * errorStr;
        errorStr = resultDic[@"memo"] ? resultDic[@"memo"] : @"支付失败";
        self.result(nil, errorStr);
    }else{
        NSDictionary * response = @{@"result":@"支付宝支付成功!"};
        self.result(response,nil);
    }
    
    
}




+ (void)weixinPayWithOrderItem:(WTPayOrderItem *)orderItem
{

    payRequsestHandler *payObj = [payRequsestHandler sharedInstance];
    //1. 拿到prepayId 和 sign, 其他参数写在外面都行
    NSDictionary * dict = [payObj sendPay:orderItem.orderName orderPrice:orderItem.orderPrice outTradeNo:orderItem.orderOutTradeNO];


    // 2.调起微信支付
    if(dict != nil){
        NSMutableString *retcode = [dict objectForKey:@"retcode"];
        if (retcode.intValue == 0){
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            
            //调起微信支付
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            
            BOOL success = [WXApi sendReq:req];
            if(!success){
                NSLog(@"调微信失败");
            }
            return;
        }else{
            NSLog(@"%@",[dict objectForKey:@"retmsg"]);
        }
    }else{
        NSLog(@"服务器返回错误");
    }


    
}




-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        
        
        if (response.errCode == WXSuccess) {
            NSDictionary * response = @{@"result":@"微信支付成功!"};
            self.result(response,nil);

        }else{
            NSLog(@"支付失败，retcode=%d",resp.errCode);
            
            self.result(nil,@"支付失败");
            
        }
    }
}

@end



@implementation WTPayOrderItem
@end
