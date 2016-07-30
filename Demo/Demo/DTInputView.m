//
//  DTInputView.m
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import "DTInputView.h"
#import "DTTextView.h"
#import "DTUtility.h"

@interface DTInputView ()<UITextViewDelegate>

@end

@implementation DTInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, DT_SCREEN_WIDTH, DT_INPUTVIEW_HEIGHT);
        self.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
        [self setupInputView];
    }
    return self;
}

- (void)setupInputView
{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DT_SCREEN_WIDTH, .5f)];
    topLine.backgroundColor = [DTUtility colorWithHex:@"#c4c4c5"];
    [self addSubview:topLine];
    
    [self addSubview:self.recordVoiceButton];

    [self addSubview:self.voiceSwitchButton];
    
    [self addSubview:self.faceButton];
    
    [self addSubview:self.pluginButton];
    
    [self addSubview:self.textView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, DT_INPUTVIEW_HEIGHT - 1, DT_SCREEN_WIDTH, .5f)];
    bottomLine.backgroundColor = [DTUtility colorWithHex:@"#ddddde"];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomLine];
    
}

#pragma mark create UI

- (UIButton *)voiceSwitchButton
{
    if (_voiceSwitchButton == nil) {
        _voiceSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"ToolViewInputVoice"];
        UIImage *imageHL = [UIImage imageNamed:@"ToolViewInputVoiceHL"];
        
        _voiceSwitchButton.frame = CGRectMake(0, 0, imageNomorl.size.width, imageNomorl.size.height);
        _voiceSwitchButton.center = CGPointMake(_voiceSwitchButton.center.x, DT_INPUTVIEW_HEIGHT / 2);
        [_voiceSwitchButton setBackgroundImage:imageNomorl forState:UIControlStateNormal];
        [_voiceSwitchButton setBackgroundImage:imageHL forState:UIControlStateHighlighted];
        [_voiceSwitchButton addTarget:self action:@selector(voiceSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _voiceSwitchButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _voiceSwitchButton;
}

- (DTTextView *)textView
{
    if (_textView == nil) {
        float hGAP = 5.f;
        float DT_TEXTVIEW_HEIGHT = 36.f;
        float DT_TEXTVIEW_TO_TOP = 7.f;
        
        CGRect rect = self.voiceSwitchButton.frame;
        float textViewX = rect.origin.x + rect.size.width + hGAP;
        self.textView = [[DTTextView alloc] initWithFrame:CGRectMake(textViewX, DT_TEXTVIEW_TO_TOP, self.faceButton.frame.origin.x - textViewX - hGAP, DT_TEXTVIEW_HEIGHT)];
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

- (UIButton *)recordVoiceButton
{
    if(_recordVoiceButton == nil){
        _recordVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordVoiceButton.frame = self.textView.frame;
        _recordVoiceButton.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
        [_recordVoiceButton setTitleColor:[DTUtility colorWithHex:@"565657"] forState:UIControlStateNormal];
        _recordVoiceButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        [_recordVoiceButton addTarget:self action:@selector(recordVoiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [_recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragExit];
        
        [_recordVoiceButton addTarget:self action:@selector(recordVoiceButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragEnter];
        
        [_recordVoiceButton addTarget:self action:@selector(recordVoiceButtonDragExit:) forControlEvents:UIControlEventTouchUpOutside];
        

        [_recordVoiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordVoiceButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        
        _recordVoiceButton.layer.cornerRadius = 6.f;
        _recordVoiceButton.layer.borderWidth = .5f;
        _recordVoiceButton.layer.borderColor = [DTUtility colorWithHex:@"c4c4c5"].CGColor;
        _recordVoiceButton.layer.masksToBounds = YES;
        
    }
    return _recordVoiceButton;
}

- (UIButton *)faceButton
{
    if (_faceButton == nil) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"ToolViewEmotion"];
        UIImage *imageHL = [UIImage imageNamed:@"ToolViewEmotionHL"];
        _faceButton.frame = CGRectMake(DT_SCREEN_WIDTH - imageNomorl.size.width * 2, 0, imageNomorl.size.width, imageNomorl.size.height);
        _faceButton.center = CGPointMake(_faceButton.center.x, DT_INPUTVIEW_HEIGHT / 2);
        [_faceButton setBackgroundImage:imageNomorl forState:UIControlStateNormal];
        [_faceButton setBackgroundImage:imageHL forState:UIControlStateHighlighted];
        [_faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;

    }
    return _faceButton;
}

- (UIButton *)pluginButton
{
    if (_pluginButton == nil) {
        _pluginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imageNomorl = [UIImage imageNamed:@"TypeSelectorBtn_Black"];
        UIImage *imageHL = [UIImage imageNamed:@"TypeSelectorBtn_BlackHL"];
        _pluginButton.frame = CGRectMake(DT_SCREEN_WIDTH - imageNomorl.size.width, 0, imageNomorl.size.width, imageNomorl.size.height);
        _pluginButton.center = CGPointMake(_pluginButton.center.x, DT_INPUTVIEW_HEIGHT / 2);
        [_pluginButton setBackgroundImage:imageNomorl forState:UIControlStateNormal];
        [_pluginButton setBackgroundImage:imageHL forState:UIControlStateHighlighted];
        [_pluginButton addTarget:self action:@selector(pluginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _pluginButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _pluginButton;
}

#pragma mark actions

- (void)voiceSwitchButtonClick:(UIButton *)sender
{
    self.pluginButton.selected = NO;
    self.faceButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        if (sender.selected == YES) {
            [self.delegate didSwitchInputType:DTInputTypeText];
            sender.selected = NO;
            
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
            
            [self bringSubviewToFront:self.textView];
        }
        else{
            [self.delegate didSwitchInputType:DTInputTypeVoice];
            sender.selected = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
            [self bringSubviewToFront:self.recordVoiceButton];
        }
    }
}

- (void)recordVoiceButtonClick:(UIButton *)sender
{
    NSLog(@"click");
    if ([self.delegate respondsToSelector:@selector(didFinishRecoingVoiceAction)]) {
        [self.delegate didFinishRecoingVoiceAction];
    }
}

- (void)recordVoiceButtonTouchDown:(UIButton *)sender
{
    NSLog(@" down");
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
        [self.delegate didStartRecordingVoiceAction];
    }
}

- (void)recordVoiceButtonTouchDragInside:(UIButton *)sender
{
    NSLog(@"drag in");
    if ([self.delegate respondsToSelector:@selector(didDragInsideVoiceAction)]) {
        [self.delegate didDragInsideVoiceAction];
    }
}

- (void)recordVoiceButtonTouchDragOutside:(UIButton *)sender
{
    NSLog(@"drag out");
    if ([self.delegate respondsToSelector:@selector(didDragOutVoiceAction)]) {
        [self.delegate didDragOutVoiceAction];
    }
}

- (void)recordVoiceButtonDragExit:(UIButton *)sender
{
    NSLog(@"drag exit %lu",(unsigned long)sender.allControlEvents);
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
        [self.delegate didCancelRecordingVoiceAction];
    }
}

- (void)faceButtonClick:(UIButton *)sender
{
    [self bringSubviewToFront:self.textView];
    self.pluginButton.selected = NO;
    self.voiceSwitchButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        if (sender.selected == YES) {
            [self.delegate didSwitchInputType:DTInputTypeText];
            sender.selected = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
        }
        else{
            [self.delegate didSwitchInputType:DTInputTypeFace];
            sender.selected = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateSelected];
            [sender setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
            
        }
    }
}

- (void)pluginButtonClick:(UIButton *)sender
{
    [self bringSubviewToFront:self.textView];
    self.faceButton.selected = NO;
    self.voiceSwitchButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        if (sender.selected == YES) {
            [self.delegate didSwitchInputType:DTInputTypeText];
            sender.selected = NO;
            
        }
        else{
            sender.selected = YES;
            [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [_faceButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
            
            [self.delegate didSwitchInputType:DTInputTypePlugin];
        }
    }
}
#pragma mark -

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.faceButton.selected = NO;
    self.voiceSwitchButton.selected = NO;
    self.pluginButton.selected = NO;
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self.delegate didSwitchInputType:DTInputTypeText];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.textView];
    }
   
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(didSwitchInputType:)]) {
        [self.delegate didSwitchInputType:DTInputTypeNone];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(didSendWithMessage:)]) {
            [self.delegate didSendWithMessage:[textView.text copy]];
        }
        textView.text = @"";
        return NO;
        
    }
    return YES;
}
@end
