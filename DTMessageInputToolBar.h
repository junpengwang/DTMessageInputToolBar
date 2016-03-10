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

typedef NS_ENUM(NSUInteger,DTMessageInputToolBarRecordVoiceState){
    DTMessageInputToolBarRecordVoiceStart,
    DTMessageInputToolBarRecordVoiceFinish,
    DTMessageInputToolBarRecordVoiceCancel,
    DTMessageInputToolBarRecordVoiceDragOut,
    DTMessageInputToolBarRecordVoiceDragInside
};

@protocol DTMesaageInputToolBarDelegate <NSObject>

@optional

- (void)didSendMessage:(NSString *)text;

- (void)didRecordVoiceWithState:(DTMessageInputToolBarRecordVoiceState)state;

- (void)inputTextViewDidBeginEditing:(DTTextView *)textView;

- (void)inputTextViewDidEndEditing:(DTTextView *)textView;

- (void)inputTextView:(DTTextView *)textView didChangeHeight:(float)height;

- (void)pluginView:(DTPluginItem *)pluginView didSelectItemAtIndex:(NSInteger)index;

@end


@interface DTMessageInputToolBar : UIView

@property (nonatomic,strong) id<DTMesaageInputToolBarDelegate> delegate;

@property (nonatomic,strong) DTInputView *inputView;

@property (nonatomic,strong) DTEmojiView *emojiView;

@property (nonatomic,strong) DTPluginBoardView *pluginBoardView;

- (void)resignFirstResponder;

@end
