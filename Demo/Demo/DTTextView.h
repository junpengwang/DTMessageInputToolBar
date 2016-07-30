//
//  DTTextView.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTTextView : UITextView

/**
 *  默认文字，当输入框没有文字时
 */
@property (copy, nonatomic) NSString *placeHolder;

/**
 *  默认文字的颜色
 */
@property (strong, nonatomic) UIColor *placeHolderTextColor;

/**
 *  是否有内容，空格不算
 */
- (BOOL)hasText;

@end
