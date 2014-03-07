//
//  KreyosUtility.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MAKE_RGB_UI_COLOR(rr,gg,bb) [UIColor colorWithRed:rr/255.0f green:gg/255.0f blue:bb/255.0f alpha:1.0f]
//#define MAKE_RGB_UI_COLOR(rr,gg,bb) [[[UIColor alloc] initWithRed:rr/255.0f green:gg/255.0f blue:bb/255.0f alpha:1.0f] autorelease]

#define MAKE_RGB_UI_COLOR_ALLOC(rr,gg,bb) [[UIColor alloc] initWithRed:rr/255.0f green:gg/255.0f blue:bb/255.0f alpha:1.0f]


#define REGULAR_FONT_WITH_SIZE(ss)   [UIFont fontWithName:@"ProximaNova-Regular" size:ss]
#define LIGHT_FONT_WITH_SIZE(ss)     [UIFont fontWithName:@"ProximaNova-Light" size:ss]
#define BOLD_FONT_WITH_SIZE(ss)      [UIFont fontWithName:@"ProximaNova-Bold" size:ss]
#define SEMIBOLD_FONT_WITH_SIZE(ss)  [UIFont fontWithName:@"ProximaNova-Semibold" size:ss]
#define ITALIC_FONT_WITH_SIZE(ss)    [UIFont fontWithName:@"ProximaNova-RegularIt" size:ss]


// common used font
#define BOTTOM_TEXT_FONT             REGULAR_FONT_WITH_SIZE(10.15f)
#define NAVI_BAR_TITLE_FONT          SEMIBOLD_FONT_WITH_SIZE(15.69f)
#define NAVI_BAR_ITEM_FONT           LIGHT_FONT_WITH_SIZE(15.69f)
#define PRIMARY_BUTTON_FONT          REGULAR_FONT_WITH_SIZE(16.62f)
#define INNER_TAB_SEL_FONT           BOLD_FONT_WITH_SIZE(12.83f)
#define INNER_TAB_NORMAL_FONT        REGULAR_FONT_WITH_SIZE(12.83f)
#define TABLE_LIST_FONT              LIGHT_FONT_WITH_SIZE(14.77f)
#define TABLE_LIST_LEFT_FONT         SEMIBOLD_FONT_WITH_SIZE(12.0f)
#define TABLE_LIST_RIGHT_FONT        REGULAR_FONT_WITH_SIZE(10.15f)
#define SEGMENTED_NORMAL_FONT        REGULAR_FONT_WITH_SIZE(11.08f)
#define SEGMENTED_SEL_FONT           SEMIBOLD_FONT_WITH_SIZE(11.08f)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)

#define APP_DELEGATE                (KreyosAppDelegate*)[[UIApplication sharedApplication] delegate]

#define SCREEN_SIZE                 [[UIScreen mainScreen] bounds].size

#define CLEAR                       [UIColor clearColor]
#define WHITE                       [UIColor whiteColor]
#define RED                         [UIColor redColor]
#define BLUE                        [UIColor blueColor]

#define LOGIN_BLUE                  [UIColor colorWithRed:0/255.0f green:190/255.0f blue:240/255.0f alpha:1.0f]

#pragma mark TAGS
#define CATEG_DATA_TAG              4

#define WEB_URL                     @"www.google.com"

static NSString *const kAPIKey       = @"AIzaSyD-1rWesovIlhuSboTLXCyT2V3zQIGMsb0";

// used for customized navigation bar page, to support IOS7
#define ADD_TO_ROOT_VIEW(v) \
do { \
if (IS_IOS7) \
{ \
CGRect frame = v.frame; \
frame.origin.y += 20; \
v.frame = frame; \
} \
[self.view addSubview:v]; \
} while(0)

// used for standard navigation bar page, to support IOS7
#define ADD_TO_ROOT_VIEW2(v) \
do { \
if (IS_IOS7) \
{ \
CGRect frame = v.frame; \
frame.origin.y += 64; \
v.frame = frame; \
} \
[self.view addSubview:v]; \
} while(0)

#define DEFINE_AUTO_FIT_NAVI_BAR(nbar) \
CGRect navBound = CGRectMake(0, 0, self.view.bounds.size.width, 44); \
if (IS_IOS7) { \
navBound.size.height += 20; \
} \
UINavigationBar* nbar = [[UINavigationBar alloc] initWithFrame:navBound]; \
[nbar setBackgroundImage:[UIImage imageNamed:IS_IOS7?@"nav_bg_7":@"nav_bg"] forBarMetrics:UIBarMetricsDefault];

#define REGISTER_FOR_KEYBOARD_NOTIFICATIONS() \
[[NSNotificationCenter defaultCenter] addObserver:self \
selector:@selector(keyboardWasShown:) \
name:UIKeyboardDidShowNotification object:nil]; \
[[NSNotificationCenter defaultCenter] addObserver:self \
selector:@selector(keyboardWillBeHidden:) \
name:UIKeyboardWillHideNotification object:nil];


