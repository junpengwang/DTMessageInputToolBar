//
//  DTPluginItem.m
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import "DTPluginItem.h"
#import "DTUtility.h"


#define DT_PLUGIN_HEIGHT 80

@interface DTPluginItem ()

@property (nonatomic,strong) UIButton *targetButton;
@property (nonatomic,weak) id target;
@end

@implementation DTPluginItem

- (instancetype)initWithImage:(UIImage *)image
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)selector
{
    if (self = [super init]) {
        self.image = image;
        self.title = title;
        self.frame = CGRectMake(0, 0, self.image.size.width, DT_PLUGIN_HEIGHT);
        [self setupWithTarget:target action:selector];
    }
    return self;
}

- (void)setItemTag:(NSInteger)itemTag
{
    _itemTag = itemTag;
    self.targetButton.tag = itemTag;
}

- (void)setupWithTarget:(id)tartger action:(SEL)selector
{
    self.targetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.targetButton setBackgroundImage:self.image forState:UIControlStateNormal];
    self.targetButton.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    _targetButton.layer.cornerRadius = 6.f;
    _targetButton.layer.borderWidth = .5f;
    _targetButton.layer.borderColor = [DTUtility colorWithHex:@"b0b0b1"].CGColor;
    _targetButton.layer.masksToBounds = YES;
    [_targetButton addTarget:tartger action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_targetButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_targetButton.bounds) + 5, CGRectGetWidth(_targetButton.bounds), 20)];
    titleLabel.textColor = [DTUtility colorWithHex:@"868686"];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
}
@end
