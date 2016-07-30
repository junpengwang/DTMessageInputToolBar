//
//  DTPluginItem.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTPluginItem : UIView

@property (nonatomic,strong) UIImage  *image;
@property (nonatomic,copy)   NSString *title;

@property (nonatomic,assign) NSInteger itemTag;

- (instancetype)initWithImage:(UIImage *)image
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)selector;

@end
