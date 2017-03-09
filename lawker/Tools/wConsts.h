//
//  wConsts.h
//  wBaiJu
//  定义系统常用
//  Created by apple on 14-06-18.
//  Copyright 2014年 __MyCompanyName__. All rights reserved.
//

#import "UIColor+Hex.h"
#import "wConsts.h"

//登录接口返回支付密码状态,在有密码验证的情况下，要先判断密码启用状态
typedef NS_ENUM(NSInteger, PayPwdEnableType) {
    PayPwdTypeDisable,  //禁用
    PayPwdTypeEnable,   //启用
    PayPwdTypeNoSet,    //未设置
};

typedef NS_ENUM(NSInteger, SenderLuckMoneyType) {
    LuckMoneyTypeCoinReceive  = 100,      //收到聚币礼包
    LuckMoneyTypeCoinSender   = 101,       //发出聚币礼包
    LuckMoneyTypeReceive      = 102,       //收到现金红包
    LuckMoneyTypeSender       = 103,      //发出现金红包
};

typedef NS_ENUM(NSInteger, PaymentMethodType) {
    
    PaymentNont         = 0,        //无
    PaymentChange       = 1,        //零钱支付
    PaymentPayTreasure  = 2,        //支付宝支付
    PaymentWeChat       = 4,        //微信支付
    PaymentJuCar,       //聚卡支付
    PaymentApple,       //苹果支付
    PaymentBankCard,    //银行卡支付
    PayresultRequrest,    //支付结果查询
};

typedef NS_ENUM(NSInteger, ShareType) {
    Wechat = 0,   //微信
    QQ     = 1,       //qq
    Sina   = 2,     //新浪
};

typedef NS_ENUM(NSInteger, SelectBtnType) {
    leftBtnType,
    centerBtnType,
    rightBtnType
};

typedef NS_ENUM(NSInteger, InstructionsType) {
    InstructionsBonusType = 1,        //奖金说明
    InstructionsSliverType,       //银币说明
    InstructionsCharmType,        //魅力值说明
    InstructionsIntegralType,     //积分说明
    InstructionsXialebaType,      //下乐吧说明
    InstructionsGiftType,         //礼物红包说明
    InstructionsMostAttractiveType,//魅力榜说明
    InstructionsRichListType,     //8富豪榜说明
    InstructionsGoddessType,      //9女神榜说明
    InstructionsForEmojiOfGif,      //动画表情服务声明
};

typedef NS_ENUM(NSInteger, UrlFriendType) {
    FriendCircleOwnType,        //我的个人帖子列表
    FriendCircleFriendType,     //好友的个人帖子列表
    FriendCircleStrangerType,   //陌生人的个人帖子列表
};

typedef NS_ENUM(NSInteger, VideoPublishType) {
    VideoPublishHot,            //热门发布视频
    VideoPublishFriendCircle,   //微友圈发布视频
    VideoPublishIchat,          //聊天视频录制
    VideoPublishMine            //我的热门视频录制
};

typedef NS_ENUM(NSInteger, ScrollviewBacType)
{
    NearScrollType = 0,      //附近的人
    FriendScrollType,        //好友
    MineScrollType,          //我的
};

typedef NS_ENUM(NSInteger, Sex)
{
    sexGirl,
    sexBoy
};

//聊天 满天落花 几种状态
typedef NS_ENUM(NSInteger, CUSSenderTypes) {
    custNone,
    custBirthday,     //生日快乐
    custMissYou,      //想你
    custKiss,         //吻
    custProsperity,   //恭喜
    custSnow,         //下雪
    custRain,         //下雨
    custPresentGold,  //金币礼物
    custPresentSilver,//银币礼物
    custPressentCharm //魅力礼物
};

//礼物类型
typedef NS_ENUM(NSInteger, GiftType) {
    gtNone,
    gtGold,    //1 金币礼物
    gtSilver,  //2 银币礼物
    gtCharm    //3 魅力值礼物
};

typedef NS_ENUM(NSInteger, GiftSendType) {
    gsNone      = -1,
    gsOrdinary  = 0,//0 普通礼物
    gsBillionaire,  //1 土豪礼物
    gsFestival      //2 节日值礼物
};


//三个视频页签
typedef NS_ENUM(NSInteger, VideoPageType) {
    VideoPageHot,           //热门
    VideoPageNearBy,        //附近
    VideoPageAttention,     //关注
};

//消息声音 类型
typedef NS_ENUM(NSInteger, MessageSoundType) {
    mstNone = - 1, //声音关闭
    mstNormal,     //经典
    mstDiDi,       //叮咚
    mstSystem      //系统
};

typedef NS_ENUM(NSInteger, JuBiViewControllerStyle) {
    JuBiViewControllerStyleJucar,   //我的聚卡
    JuBiViewControllerStyleJubi,    //我的聚币
    JuBiViewControllerStyleSilver,  //我的银币
    JuBiViewControllerStyleTopup,   //充值(聚卡账单)
    JuBiViewControllerStyleCharge,  //零钱明细
    JuBiViewControllerStyleJudouManager,//我的聚豆明细
    JuBiViewControllerStyleIntegral     //我的积分明细
    
};

//礼物类型 文本Key
static NSString* const GiftTypeTextKeys[] =
{
    [gtNone]   = @"",
    [gtGold]   = @"PresentGold",      //1 金币礼物
    [gtSilver] = @"PresentSilver",    //2 银币礼物
    [gtCharm]  = @"PressentCharm"     //3 魅力值礼物
};


static NSString* const SexKeys[] =
{
    [sexGirl] = @"SexGirl",
    [sexBoy]  = @"SexBoy"
};

//消息声音 类型 文本Key
static NSString* const MessageSoundTypeTextKeys[] =
{
    [mstNormal]   = @"MessageSoundNormal",      //经典
    //[mstDiDi]     = @"MessageSoundDiDi",      //叮咚
    //[mstSystem]   = @"System"                 //系统
};


static NSString *const SAppLocalDbName = @"ichat.db";
static NSString *const SAppUsersDbName = @"User%lld.db";

static NSString* const HSLanguageFix = @"";
static NSString* const HSLanguageFixCht = @"_cht";
static NSString* const HSLanguageFixEn = @"_en";

static NSString *const SSQLDateFormat = @"yyyy-MM-dd";
static NSString *const SSQLDateTimeFormat = @"yyyy-MM-dd HH:mm:ss";
static NSString *const SSQLTimeFormat = @"HH:mm:ss";

static NSString *const SStringEmpty = @"";


static NSString* const SSelectExpr = @"SELECT %@ FROM %@ %@ %@";
static NSString* const SDeleteExpr = @"DELETE FROM %@ %@ ";
static NSString* const SInsertExpr = @"INSERT INTO %@ (%@) VALUES (%@) ";

static NSString* const SStringMP4 = @".mp4";
//NSUserDefaults 保存 APNS token
static NSString* const DeviceTokenStringKey = @"DeviceTokenStringKEY";

//NSUserDefaults 保存 播放聊天语音,使用 听筒或扬声器 模式
#define PlayVoiceUseEarphone  @"PlayVoiceUseEarphone"

//视频上传结束通知
#define VideoUploaderFileNotification @"VideoUploaderFileNotification"

#define ExitWBaiJuAppTooRootTag "ExitWBaiJuAppTooRootTag"


//标准按钮高度
//#define UIButtonHeight              36.0


//用户头像 的宽
#define ICON_IMAGE_WIDTH        140.0

//用户头像 的高
#define ICON_IMAGE_HEIGHT       140.0

//用户大头像 的宽
#define ICON_BIG_IMAGE_WIDTH    800.0

//用户大头像 的高
#define ICON_BIG_IMAGE_HEIGHT   800.0

//用户大头像文件后缀
#define ICON_BIG_SUFFIX     @"_800"


//根据iPhone5效果图，对不同屏幕进行缩放的比例
#define ScreenMultiple [WBJUIFont screenRate]


//APP 短版本号
#define APP_Ver_SHORT [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


//Home 删除好友tag
#define RETURN_DELETE_FRIEND             "DeleteFriendWithFriendId"

//Home 读取好友消息
#define RETURN_READ_CONVERSATION_FRIEND  "ReadConversationWithFrienId"

//Home 检测APP更新
#define RETURN_CHECK_APPUPDATES          "CheckAppUpdates"

//Home 有消息来时，告诉home 检测群资料有没有
#define RETURN_CHECK_CHAT_GROUP_EXISTS   "CheckChatGroupExists"

//Home 开始连接服务器
#define RETURN_CONNECT_BEGIN             "BeginSocketConnectSvr"

//Home 开始登录
#define RETURN_LOGIN_BEGIN               "BeginSocketLoginSvr"

//开始上传 阿里文件（网络启用后，通知可以开始上传文件）
#define AliyunStartUploadFile            @"AliyunStartUploadFile"

//开始上传 阿里文件（消息）
#define AliyunStartUploadMsgFile         @"AliyunStartMsgUploadFile"

//上传 阿里文件 完成
//#define AliyunUploadFileFinished         @"AliyunUploadFileFinished"

//消息发送成功
#define WBJChatMessageFinished           @"WBJChatMessageFinished"
#define WBJChatMessageExists             @"WBJChatMessageExists"

//图片压缩处理 完成
#define WBJChatFileBuiled                @"WBJChatFileBuiled"


//收到新消息
#define WBJChatRecNewMessage             @"WBJChatRecNewMessage"

//收到 服务器 发过来的 Socket 消息
//#define WBJSocketMessageHandle           @"WBJSocketMessageHandle"

//动画表情，表情收藏 内容有变动时
#define WBJChatEmojiOfGifItemChanged  @"WBJChatEmojiOfGifItemChanged"

#define DistinguishGiftUpdated @"DistinguishGiftUpdated"    //哈系类（礼物类型）

//弧度转角度
#define RADIANS_DEGREES(radians) ((radians) * (180.0 / M_PI))

//角度转弧度
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)


#define UITableViewIndexTexts @[@"↑",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"]



//保存 版本Code
#define PreAppVerCodeKey @"PreAppVerCode"

//保存服务器端 IOS最大版本号
#define SvrIOSMaxVerCodeKey @"ServerIOSMaxVerCode"

//保存App Store 短版本号
#define AppStoreVerKey @"AppStoreVer"

#define MIN_VIDEO_DUR 2.0f  //视频播放最短时间

//i6设计图 与界面数据转化
#define ExchangeValuePx(X) 320.0 / 750.0 *(X)

//分割线:透明度:颜色;字体的限制数
#define  Transparency 0.4

//账号 分组名最长录入长度
#define  UserGroupNameInputMaxLen 20

//菊花超时
#define MAX_CIRCLES_TIME 2


//(40 * [WBJUIFont screenRate])
#define IProgressDefaultWidth  46

//红点大小
#define RedD 9.0
#define DEVICE_BOUNDS [[UIScreen mainScreen] applicationFrame]
#define DEVICE_SIZE [[UIScreen mainScreen] applicationFrame].size
#define DEVICE_OS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue] //获取版本号
#define DELTA_Y (DEVICE_OS_VERSION >= 7.0f? 20.0f : 0.0f)

//友盟反馈
#define UMAppkey @"545433f1fd98c5a740001ae0"



