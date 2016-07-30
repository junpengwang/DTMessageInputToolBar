//
//  DTUtility.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/8.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DT_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define DT_BOARD_HEITH 216

@interface DTUtility : NSObject

+ (UIColor *)colorWithHex:(NSString *)hex;

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
