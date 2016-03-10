//
//  DTMessageInputToolBar.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTInputView;
@class DTEmojiView;
@class DTPluginBoardView;
@class DTTextView;
@class DTPluginItem;
@class DTMessageInputToolBar;

typedef NS_ENUM(NSUInteger,DTMessageInputToolBarRecordVoiceState){
    DTMessageInputToolBarRecordVoiceStart,
    DTMessageInputToolBarRecordVoiceFinish,
    DTMessageInputToolBarRecordVoiceCancel,
    DTMessageInputToolBarRecordVoiceDragOut,
    DTMessageInputToolBarRecordVoiceDragInside
};

@protocol DTMesaageInputToolBarDelegate <NSObject>

@optional

/**
 *  点击了发送按钮
 *
 *  @param text 要发送的文字
 */
- (void)didSendMessage:(NSString *)text;

/**
 *  录音时各状态切换
 *
 *  @param state 录音状态
 */
- (void)didRecordVoiceWithState:(DTMessageInputToolBarRecordVoiceState)state;


/**
 *  开始输入
 *
 *  @param textView 输入文本框
 */
- (void)inputTextViewDidBeginEditing:(DTTextView *)textView;

/**
 *  结束输入
 *
 *  @param textView 输入文本框
 */
- (void)inputTextViewDidEndEditing:(DTTextView *)textView;

/**
 *  文本框高度变化
 *
 *  @param textView 输入文本框
 *  @param height   变化的高度
 */
- (void)inputTextView:(DTTextView *)textView didChangeHeight:(float)height;

/**
 *  插件点击事件
 *
 *  @param pluginView 点击的插件对象
 *  @param index      点击的插件位置
 */
- (void)pluginView:(DTPluginItem *)pluginItem didSelectItemAtIndex:(NSInteger)index;

/**
 *  工具条 Y 坐标变化
 *
 *  @param toolBar 工具条对象
 *  @param y       y 坐标
 */
- (void)inputToolBar:(DTMessageInputToolBar *)toolBar didChangeY:(float)y;


@end


@interface DTMessageInputToolBar : UIView

@property (nonatomic,strong) id<DTMesaageInputToolBarDelegate> delegate;

@property (nonatomic,strong) DTInputView *inputView;

@property (nonatomic,strong) DTEmojiView *emojiView;

@property (nonatomic,strong) DTPluginBoardView *pluginBoardView;

- (void)resignFirstResponder;

@end
