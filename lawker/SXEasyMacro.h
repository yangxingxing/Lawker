//
//  SXEasyMacro.h
//  SXEasyMacroDemo
//
//  Created by dongshangxian on 15/10/8.
//  Copyright © 2015年 Sankuai. All rights reserved.
//

#ifndef SXEasyMacro_h
#define SXEasyMacro_h

#define Prefix SX
/** 开发模式 */
static BOOL const DEVELOPER_MODE = NO;

/** 字体*/
#define SXFont(x) [UIFont systemFontOfSize:x]
#define SXBoldFont(x) [UIFont boldSystemFontOfSize:x]

/** 颜色*/
#define SXRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define SXRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define SXRGB16Color(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** 输出*/
#ifdef DEBUG
#define SXLog(...) NSLog(__VA_ARGS__)
#else
#define SXLog(...)
#endif

/** 获取硬件信息*/
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define CurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define ScreenRate  SCREEN_W / 375.0;

//判断是否为iPad
#define ISIPAD [[[UIDevice currentDevice].model substringToIndex:4] isEqualToString:@"iPad"]

//屏幕高度
#define SCREEN_HEIGHT ( ISIPAD ? 480 : [[UIScreen mainScreen] currentMode].size.height / 2 )

//屏幕宽度
#define SCREEN_WIDTH ( ISIPAD ? 320 : [[UIScreen mainScreen] currentMode].size.width / 2 )

// OS Version
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define iOS102 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.2)
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS6 ((([[UIDevice currentDevice].systemVersion intValue] >= 6) && ([[UIDevice currentDevice].systemVersion intValue] < 7)) ? YES : NO )
#define iOS5 ((([[UIDevice currentDevice].systemVersion intValue] >= 5) && ([[UIDevice currentDevice].systemVersion intValue] < 6)) ? YES : NO )


/** 适配*/
#define SXiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define SXiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define SXiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define SXiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define SXiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define SXiPhone4_OR_4s    (SCREEN_H == 480)
#define SXiPhone5_OR_5c_OR_5s   (SCREEN_H == 568)
#define SXiPhone6_OR_6s   (SCREEN_H == 667)
#define SXiPhone6Plus_OR_6sPlus   (SCREEN_H == 736)
#define SXiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 弱指针*/
#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

/** 加载本地文件*/
#define SXLoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define SXLoadArray(file,type) [UIImage arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define SXLoadDict(file,type) [UIImage dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

/** 多线程GCD*/
#define SXGlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define SXMainGCD(block) dispatch_async(dispatch_get_main_queue(),block)

/** 数据存储*/
#define SXUserDefaults [NSUserDefaults standardUserDefaults]
#define SXCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define SXDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define SXTempDir NSTemporaryDirectory()

#pragma mark 颜色
#define color(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//UIPageControl 当前页颜色
#define COLOR_PageControlCurrentPage  [textOrangeColor colorWithAlphaComponent: 0.8]           //[UIColor greenColor]

#define sureBtnColor                  color(254, 156, 1, 1)     //[UIColor colorWithHexString:@"#fe9c01"]
#define textBlackColor                [UIColor blackColor]      //[UIColor colorWithHexString:@"#606060"]
#define textGrayColor                 [UIColor grayColor]       //[UIColor colorWithHexString:@"#949494"]
#define textOrangeColor               color(254, 156, 1, 1)     //[UIColor colorWithHexString:@"#fe9c01"]
#define YellowColor                   color(255, 216, 34, 1)    //[UIColor colorWithHexString:@"#ffd822"]
#define textGreenColor                color(96, 217, 78, 1)     //[UIColor colorWithHexString:@"#60d94e"]
#define textRedColor                  color(255, 84, 84, 1)     //[UIColor colorWithHexString:@"#fe5454"]
#define textLightGrayColor            [UIColor lightGrayColor]
#define GrayColor                     color(145, 145, 145, 1)      //[UIColor colorWithHexString:@"#919191"]
#define AshenColor                    color(245, 206, 147, 1)      //[UIColor colorWithHexString:@"#f5ce93"]//土色
#define textWhiteColor                [UIColor whiteColor]
#define textBlueWColor                [UIColor blueColor]

//网格中 时间 字体大小
#define UITableViewTimeFontSize     12.0
#define UITableViewTimeFont         [UIFont systemFontOfSize:UITableViewTimeFontSize]

//文本 标签 标准字体大小
#define UITextFontSize              15.0
#define UITextFont                  [UIFont systemFontOfSize:UITextFontSize]

//APP 短版本号
#define APP_Ver_SHORT [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//保存App Store 短版本号
#define AppStoreVerKey @"AppStoreVer"

#endif /* SXEasyMacro_h */
