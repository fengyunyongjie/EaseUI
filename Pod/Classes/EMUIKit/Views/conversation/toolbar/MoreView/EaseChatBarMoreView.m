/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "EaseChatBarMoreView.h"

#define CHAT_BUTTON_SIZE_WIDTH 62
#define CHAT_BUTTON_SIZE_HEIGHT 90
#define INSETS 10
#define MOREVIEW_COL 3
#define MOREVIEW_ROW 2
#define MOREVIEW_BUTTON_TAG 1000

@implementation UIView (MoreView)

- (void)removeAllSubview
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end

@interface EaseChatBarMoreView ()<UIScrollViewDelegate>
{
    EMChatToolbarType _type;
    NSInteger _maxIndex;
}

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

@end

@implementation EaseChatBarMoreView

+ (void)initialize
{
    // UIAppearance Proxy Defaults
    EaseChatBarMoreView *moreView = [self appearance];
    moreView.moreViewBackgroundColor = [UIColor whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame type:(EMChatToolbarType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _type = type;
        [self setupSubviewsForType:_type];
    }
    return self;
}

- (void)setupSubviewsForType:(EMChatToolbarType)type
{
    //self.backgroundColor = [UIColor clearColor];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.pagingEnabled = YES;
    _scrollview.showsHorizontalScrollIndicator = NO;
    _scrollview.showsVerticalScrollIndicator = NO;
    _scrollview.delegate = self;
    [self addSubview:_scrollview];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 1;
    [self addSubview:_pageControl];
    
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE_WIDTH) / (MOREVIEW_COL+1);
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, INSETS, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
    [_photoButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
    [_photoButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
    [_photoButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_photoButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
    [_photoButton setTitle:@"照片" forState:UIControlStateNormal];
    [_photoButton.imageView setContentMode:UIViewContentModeCenter];
    [_photoButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = MOREVIEW_BUTTON_TAG;
    [_scrollview addSubview:_photoButton];
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE_WIDTH, INSETS, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
    [_locationButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
    [_locationButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
    [_locationButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_locationButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
    [_locationButton setTitle:@"位置" forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = MOREVIEW_BUTTON_TAG + 1;
    [_scrollview addSubview:_locationButton];
    
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE_WIDTH * 2, INSETS, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
    [_takePicButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
    [_takePicButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
    [_takePicButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_takePicButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
    [_takePicButton setTitle:@"拍照" forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = MOREVIEW_BUTTON_TAG + 2;
    _maxIndex = 2;
    [_scrollview addSubview:_takePicButton];

    CGRect frame = self.frame;
    if (type == EMChatToolbarTypeChat) {
        frame.size.height = CHAT_BUTTON_SIZE_HEIGHT * MOREVIEW_ROW + INSETS * (MOREVIEW_ROW+1);
        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets, INSETS * 2 + CHAT_BUTTON_SIZE_HEIGHT, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
        [_audioCallButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
        [_audioCallButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
        [_audioCallButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_audioCallButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
        [_audioCallButton setTitle:@"语音" forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
        _audioCallButton.tag = MOREVIEW_BUTTON_TAG + 3;
        [_scrollview addSubview:_audioCallButton];
        
        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets*2+CHAT_BUTTON_SIZE_WIDTH, INSETS * 2 + CHAT_BUTTON_SIZE_HEIGHT, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
        [_videoCallButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
        [_videoCallButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
        [_videoCallButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_videoCallButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
        [_videoCallButton setTitle:@"视频" forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"EaseUIResource.bundle/chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
        _videoCallButton.tag =MOREVIEW_BUTTON_TAG + 4;
        _maxIndex = 4;
        [_scrollview addSubview:_videoCallButton];
    }
    else if (type == EMChatToolbarTypeGroup)
    {
        frame.size.height = CHAT_BUTTON_SIZE_HEIGHT * 1 + INSETS * (1+1);
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)insertItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE_WIDTH) / (MOREVIEW_COL+1);
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
    NSInteger page = _maxIndex/pageSize;
    NSInteger row = (_maxIndex%pageSize)/MOREVIEW_COL;
    NSInteger col = _maxIndex%MOREVIEW_COL;
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE_WIDTH * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE_WIDTH * row, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_HEIGHT)];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(-(CHAT_BUTTON_SIZE_HEIGHT-CHAT_BUTTON_SIZE_WIDTH), 0.0, 0.0, 0.0)];
    [moreButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CHAT_BUTTON_SIZE_WIDTH, - CHAT_BUTTON_SIZE_WIDTH,0.0)];
    [moreButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [moreButton setTitleColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
    [moreButton setTitle:title forState:UIControlStateNormal];
    [moreButton setImage:image forState:UIControlStateNormal];
    [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = MOREVIEW_BUTTON_TAG+_maxIndex;
    [_scrollview addSubview:moreButton];
    [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    if (_maxIndex >=MOREVIEW_COL+1) {
        frame.size.height = CHAT_BUTTON_SIZE_HEIGHT * MOREVIEW_ROW + INSETS * (MOREVIEW_ROW+1);
        _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    }
    self.frame = frame;
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

- (void)updateItemWithImage:(UIImage *)image highlightedImage:(UIImage *)highLightedImage title:(NSString *)title atIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
}

- (void)removeItematIndex:(NSInteger)index
{
    UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self _resetItemFromIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - private

- (void)_resetItemFromIndex:(NSInteger)index
{
    CGFloat insets = (self.frame.size.width - MOREVIEW_COL * CHAT_BUTTON_SIZE_WIDTH) / 5;
    CGRect frame = self.frame;
    for (NSInteger i = index + 1; i<_maxIndex + 1; i++) {
        UIView *moreButton = [_scrollview viewWithTag:MOREVIEW_BUTTON_TAG+i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL*MOREVIEW_ROW;
            NSInteger page = moveToIndex/pageSize;
            NSInteger row = (moveToIndex%pageSize)/MOREVIEW_COL;
            NSInteger col = moveToIndex%MOREVIEW_COL;
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + insets * (col + 1) + CHAT_BUTTON_SIZE_WIDTH * col, INSETS + INSETS * 2 * row + CHAT_BUTTON_SIZE_WIDTH * row, CHAT_BUTTON_SIZE_WIDTH , CHAT_BUTTON_SIZE_WIDTH)];
            moreButton.tag = MOREVIEW_BUTTON_TAG+moveToIndex;
            [_scrollview setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    _maxIndex--;
    if (_maxIndex >=MOREVIEW_ROW+1) {
        frame.size.height = CHAT_BUTTON_SIZE_HEIGHT * MOREVIEW_ROW + INSETS * (MOREVIEW_ROW+1);    } else {
        frame.size.height = CHAT_BUTTON_SIZE_HEIGHT * 1 + INSETS * (1+1);
    }
    self.frame = frame;
    _scrollview.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20, CGRectGetWidth(frame), 20);
    _pageControl.hidden = _pageControl.numberOfPages<=1;
}

#pragma setter
//- (void)setMoreViewColumn:(NSInteger)moreViewColumn
//{
//    if (_moreViewColumn != moreViewColumn) {
//        _moreViewColumn = moreViewColumn;
//        [self setupSubviewsForType:_type];
//    }
//}
//
//- (void)setMoreViewNumber:(NSInteger)moreViewNumber
//{
//    if (_moreViewNumber != moreViewNumber) {
//        _moreViewNumber = moreViewNumber;
//        [self setupSubviewsForType:_type];
//    }
//}

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor
{
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

/*
- (void)setMoreViewButtonImages:(NSArray *)moreViewButtonImages
{
    _moreViewButtonImages = moreViewButtonImages;
    if ([_moreViewButtonImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonImages count]) {
                    NSString *imageName = [_moreViewButtonImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)setMoreViewButtonHignlightImages:(NSArray *)moreViewButtonHignlightImages
{
    _moreViewButtonHignlightImages = moreViewButtonHignlightImages;
    if ([_moreViewButtonHignlightImages count] > 0) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                if (button.tag < [_moreViewButtonHignlightImages count]) {
                    NSString *imageName = [_moreViewButtonHignlightImages objectAtIndex:button.tag];
                    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
                }
            }
        }
    }
}*/

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)moreAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewAtIndex:)]) {
        [_delegate moreView:self didItemInMoreViewAtIndex:button.tag-MOREVIEW_BUTTON_TAG];
    }
}

@end
