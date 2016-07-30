//
//  DTMessageInputToolBar.m
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import "DTMessageInputToolBar.h"


#define DT_TOOLBAR_HEIGHT 532/2.f
static void * kJSQMessagesKeyValueObservingContext = &kJSQMessagesKeyValueObservingContext;

@interface DTMessageInputToolBar ()<DTInputViewDelegate,DTEmojiViewDelegate,DTPluginBoardViewDelegate>
{
    double animationDuration;
    CGRect keyboardRect;
    BOOL isObserving;
    float currentHeight;
}

@end

@implementation DTMessageInputToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, DT_TOOLBAR_HEIGHT);
        
        self.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
    
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        self.clipsToBounds = YES;
        
        currentHeight = DT_TOOLBAR_HEIGHT;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.inputView = [[DTInputView alloc] init];
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.inputView.delegate = self;
    [self addSubview:_inputView];
    
    self.pluginBoardView = [[DTPluginBoardView alloc] init];
    self.pluginBoardView.delegate = self;
    [self addSubview:_pluginBoardView];
    
    self.emojiView = [[DTEmojiView alloc] init];
    self.emojiView.delegate = self;
    [self addSubview:_emojiView];
    

    
    [self addKeyboardListener];
    
    [self addObserver];

}

- (void)dealloc
{
    [self removeKeyboardListener];
    [self removeObserver];
}

- (void)resignFirstResponder
{
    [self.inputView.textView resignFirstResponder];
}

- (void)addKeyboardListener
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillShow:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
}

- (void)removeKeyboardListener
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)addObserver
{
    if (isObserving) {
        return;
    }
    [self.inputView.textView addObserver:self
                                             forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                context:&kJSQMessagesKeyValueObservingContext];
    isObserving = YES;

}

- (void)removeObserver
{
    if (!isObserving) {
        return;
    }
    @try {
        [self.inputView.textView removeObserver:self
                                                forKeyPath:NSStringFromSelector(@selector(contentSize))
                                                   context:kJSQMessagesKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) { }
    
    isObserving = NO;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesKeyValueObservingContext) {
        
        if (object == self.inputView.textView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            
        
            CGFloat dy = newContentSize.height - oldContentSize.height;
            if (dy == 6) {
                return; //TODO: bug
            }
            if (dy < 0) {
                
            }
            [self adjustInputToolbarForTextViewContentSizeChange:dy];
            
        }
    }
}

- (void)adjustInputToolbarForTextViewContentSizeChange:(float)dy
{
    NSLog(@"%f",dy);
    self.frame = CGRectMake(0, self.frame.origin.y - dy, self.frame.size.width, self.frame.size.height + dy);
//    self.inputView.frame =  CGRectMake(0, self.inputView.frame.origin.y , self.inputView.frame.size.width, self.inputView.frame.size.height + dy);
    
}


#pragma mark -keyboard
- (void)keyboardWillHide:(NSNotification *)notification{
    
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
}

- (void)keyboardWillShow:(NSNotification *)notification{
    keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    animationDuration= [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if ([[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y<CGRectGetHeight(self.superview.frame)) {
        [self inputBarAnimationWithRect:[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                               duration:[[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                                  curve:[[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]
                              InputType:DTInputTypeNone];
    }

}


#pragma mark - messageView animation

- (void)inputBarAnimationWithRect:(CGRect)rect
                                InputType:(DTInputType)type{
    [self inputBarAnimationWithRect:rect duration:0.25 curve:UIViewAnimationCurveEaseInOut InputType:type];
    
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}


- (void)inputBarAnimationWithRect:(CGRect)rect
                         duration:(float)duration
                            curve:(UIViewAnimationCurve)curve
                                  InputType:(DTInputType)type{
    
    CGRect inputViewRect = self.inputView.frame;
    __block float dy = currentHeight - DT_TOOLBAR_HEIGHT;
    [UIView animateWithDuration:duration
                          delay:0.f
                        options:[self animationOptionsForCurve:curve]
                     animations:^{
                         
                         switch (type) {
                             case DTInputTypeFace:
                             {
                                 self.emojiView.frame = CGRectMake(0.0f,CGRectGetMaxY(inputViewRect),CGRectGetWidth(self.superview.frame),CGRectGetHeight(rect));
                                 self.pluginBoardView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.pluginBoardView.frame));
                                
                             }
                                 break;
                             case DTInputTypeNone:
                             {
                                 self.emojiView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.emojiView.frame));
                                 
                                 self.pluginBoardView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.pluginBoardView.frame));
                                 
                             }
                                 break;
                             case DTInputTypeVoice:
                             {
                                 self.emojiView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.emojiView.frame));
                                 
                                 self.pluginBoardView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.pluginBoardView.frame));
                                 dy = 0;
                             }
                                 break;

                                 
                             case DTInputTypePlugin:
                             {
                                 self.pluginBoardView.frame = CGRectMake(0.0f,CGRectGetMaxY(inputViewRect),CGRectGetWidth(self.superview.frame),CGRectGetHeight(rect));
                                 
                                 self.emojiView.frame = CGRectMake(0.0f,CGRectGetHeight(self.superview.frame),CGRectGetWidth(self.superview.frame),CGRectGetHeight(self.emojiView.frame));
                             }
                                 break;
                                 
                             default:
                                 break;
                         }
                         
                        
                         self.frame = CGRectMake(0.0f,
                                                 CGRectGetHeight(self.superview.frame)-CGRectGetHeight(rect)- (dy + DT_INPUTVIEW_HEIGHT),
                                                 CGRectGetWidth(self.superview.frame),
                                                 CGRectGetHeight(self.frame));
                         
                         if ([self.delegate respondsToSelector:@selector(inputToolBar:didChangeY:)]) {
                             [self.delegate inputToolBar:self didChangeY:self.frame.origin.y];
                         }

                     } completion:^(BOOL finished) {
                         
                     }];
}



#pragma mark DTInputViewDelegate

- (void)inputTextViewDidEndEditing:(DTTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:textView];
    }
}

- (void)inputTextViewDidBeginEditing:(DTTextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:textView];
    }
}

- (void)didSendWithMessage:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendMessage:)]) {
        [self.delegate didSendMessage:text];
    }
}

/**
 *  输入状态切换
 */
- (void)didSwitchInputType:(DTInputType)type
{
    switch (type) {
        case DTInputTypeText:{
            [self.inputView.textView becomeFirstResponder];
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, currentHeight);
            break;
        }
        case DTInputTypeVoice:{
            currentHeight = self.frame.size.height;

            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, DT_TOOLBAR_HEIGHT);

            [self inputBarAnimationWithRect:CGRectZero
                                            InputType:DTInputTypeVoice];
            
            [self.inputView.textView resignFirstResponder];
            break;
        }
        case DTInputTypeFace:{
            [self inputBarAnimationWithRect:self.emojiView.frame
                                            InputType:DTInputTypeFace];
            [self.inputView.textView resignFirstResponder];
            break;
        }
        case DTInputTypePlugin:{
            [self inputBarAnimationWithRect:self.pluginBoardView.frame
                                            InputType:DTInputTypePlugin];
            [self.inputView.textView resignFirstResponder];
            break;
        }

        default:
            break;
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction
{
    if ([self.delegate respondsToSelector:@selector(didRecordVoiceWithState:)]) {
        [self.delegate didRecordVoiceWithState:DTMessageInputToolBarRecordVoiceStart];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction
{
    if ([self.delegate respondsToSelector:@selector(didRecordVoiceWithState:)]) {
        [self.delegate didRecordVoiceWithState:DTMessageInputToolBarRecordVoiceCancel];
    }

}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction
{
    if ([self.delegate respondsToSelector:@selector(didRecordVoiceWithState:)]) {
        [self.delegate didRecordVoiceWithState:DTMessageInputToolBarRecordVoiceFinish];
    }

}

- (void)didDragInsideVoiceAction
{
    if ([self.delegate respondsToSelector:@selector(didRecordVoiceWithState:)]) {
        [self.delegate didRecordVoiceWithState:DTMessageInputToolBarRecordVoiceDragInside];
    }

}

- (void)didDragOutVoiceAction
{
    if ([self.delegate respondsToSelector:@selector(didRecordVoiceWithState:)]) {
        [self.delegate didRecordVoiceWithState:DTMessageInputToolBarRecordVoiceDragOut];
    }

}
#pragma mark -

#pragma mark DTEmojiViewDelegate

- (void)faceViewDidSelected:(NSString *)face
{
    self.inputView.textView.text = [self.inputView.textView.text stringByAppendingString:face];
}



- (void)faceViewDidDelete
{
    NSString *text = self.inputView.textView.text;
    if (text.length>0) {
        NSString *newStr = nil;
        if (text.length >3) {
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else  if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-4]]) {
                newStr=[text substringToIndex:text.length-4];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        }else if (text.length >2) {
            
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-3]]) {
                newStr=[text substringToIndex:text.length-3];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
        }else   if (text.length >1) {
            if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-1]]) {
                newStr=[text substringToIndex:text.length-1];
            }else if ([DTUtility stringContainsEmoji:[text substringFromIndex:text.length-2]]) {
                newStr=[text substringToIndex:text.length-2];
            }else{
                newStr=[text substringToIndex:text.length-1];
            }
            
        }else {
            
            
            
        }
        self.inputView.textView.text=newStr;
    }
}

#pragma mark DTPluginViewDelegate


- (void)pluginDidClicked:(DTPluginItem *)item index:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(pluginView:didSelectItemAtIndex:)]) {
        [self.delegate pluginView:item didSelectItemAtIndex:index];
    }
}

@end
