//
//  DTInputView.h
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTTextView;

#define DT_INPUTVIEW_HEIGHT 50.f

typedef NS_ENUM(NSUInteger,DTInputType){
    DTInputTypeNone,
    DTInputTypeText,
    DTInputTypeVoice,
    DTInputTypeFace,
    DTInputTypePlugin
};

@protocol DTInputViewDelegate <NSObject>

/**
 *  输入状态切换
 */
- (void)didSwitchInputType:(DTInputType)type;

- (void)didSendWithMessage:(NSString *)text;

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction;

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction;

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction;

- (void)didDragOutVoiceAction;

- (void)didDragInsideVoiceAction;

- (void)inputTextViewDidBeginEditing:(DTTextView *)textView;

- (void)inputTextViewDidEndEditing:(DTTextView *)textView;

@end

@interface DTInputView : UIView

@property (nonatomic,weak)   id<DTInputViewDelegate> delegate;

@property (nonatomic,strong) UIButton      *voiceSwitchButton;

@property (nonatomic,strong) DTTextView    *textView;

@property (nonatomic,strong) UIButton      *recordVoiceButton;

@property (nonatomic,strong) UIButton      *faceButton;

@property (nonatomic,strong) UIButton      *pluginButton;

@end
