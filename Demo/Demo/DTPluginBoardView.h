//
//  DTPluginBoardView.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DTPluginItem;

@protocol DTPluginBoardViewDelegate <NSObject>

- (void)pluginDidClicked:(DTPluginItem *)item index:(NSUInteger)index;

@end

@interface DTPluginBoardView : UIView

@property (nonatomic,strong) NSMutableArray *items;

@property (nonatomic,weak) id <DTPluginBoardViewDelegate> delegate;

- (void)reloadData;


@end
