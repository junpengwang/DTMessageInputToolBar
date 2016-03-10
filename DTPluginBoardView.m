//
//  DTPluginBoardView.m
//  WildIMKitApp
//
//  Created by junpengwang on 16/3/7.
//  Copyright © 2016年 wilddog. All rights reserved.
//

#import "DTPluginBoardView.h"
#import "DTUtility.h"
#import "DTPluginItem.h"

@interface DTPluginBoardView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;

@end

@implementation DTPluginBoardView

- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 50, DT_SCREEN_WIDTH, DT_BOARD_HEITH);
        self.backgroundColor = [DTUtility colorWithHex:@"f4f4f5"];
        self.clipsToBounds = YES;
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    DTPluginItem *albumItem = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_pic"] title:@"照片" target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *photoItem = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_video"] title:@"拍摄"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *locationItem = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_location"] title:@"位置"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *cardItem = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_friendcard"] title:@"名片"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *albumItem1 = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_pic"] title:@"照片"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *photoItem1 = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_video"] title:@"拍摄"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *locationItem1 = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_location"] title:@"位置"target:self action:@selector(itemButtonClick:)];
    
    DTPluginItem *cardItem1 = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_friendcard"] title:@"名片"target:self action:@selector(itemButtonClick:)];
    DTPluginItem *cardItem2 = [[DTPluginItem alloc] initWithImage:[UIImage imageNamed:@"sharemore_friendcard"] title:@"名片"target:self action:@selector(itemButtonClick:)];
    
    self.items = [NSMutableArray arrayWithObjects:albumItem,photoItem,locationItem,cardItem,albumItem1,photoItem1,locationItem1,cardItem1,cardItem2, nil];
    
    [self reloadData];
    
}

- (void)reloadData
{
    float toTop = 15.f;
    float toLeft = 30.f * DT_SCREEN_WIDTH / 375 + 5 * ((DT_SCREEN_WIDTH - 375) > 0 ? 1 : -1);
    float vGap = 10.f;
    int numPerPage = 8;
    if (_items.count > numPerPage) {
        NSUInteger pageCount = _items.count / 4 + (_items.count % 4 == 0 ? 0 : 1);
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * pageCount, CGRectGetHeight(self.bounds));
        
        int pageControlHeight = 30.f;
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - pageControlHeight, DT_SCREEN_WIDTH, pageControlHeight)];
        pageControl.backgroundColor = self.backgroundColor;
        pageControl.hidesForSinglePage = YES;
        pageControl.defersCurrentPageDisplay = YES;
        pageControl.numberOfPages = _items.count / 8 + 1;
        pageControl.pageIndicatorTintColor = [DTUtility colorWithHex:@"bbbbbc"];
        pageControl.currentPageIndicatorTintColor = [DTUtility colorWithHex:@"8d8d8d"];
        
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
    }
    
    
    for (int i = 0 ; i < _items.count; i++){
        
        int col = i % 4;
        int row = i / 4 % 2;
        int page = i / 8;
        DTPluginItem *item = _items[i];
        item.itemTag = i;
        float hGap = (DT_SCREEN_WIDTH - toLeft * 2 - CGRectGetWidth(item.bounds) * 4) / 3.f;
        item.frame = CGRectMake(CGRectGetWidth(self.bounds) * page + toLeft + (CGRectGetWidth(item.bounds) + hGap) * col,
                                toTop + (CGRectGetHeight(item.bounds) + vGap) * row,
                                CGRectGetWidth(item.bounds),
                                CGRectGetHeight(item.bounds));
        [self.scrollView addSubview:item];
    }
}

- (void)itemButtonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(pluginDidClicked:index:)]) {
        [self.delegate pluginDidClicked:(DTPluginItem *)sender.superview index:sender.tag];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.pageControl setCurrentPage:currentPage];
}
@end
