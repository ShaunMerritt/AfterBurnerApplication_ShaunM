//
//  SMOverlayView.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/12/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMOverlayView.h"

@interface SMOverlayView ()

@property (nonatomic, strong) UIImageView *infoCardOverlayImageView;

@end


@implementation SMOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.infoCardOverlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trollface_300x200"]];
        [self addSubview:self.infoCardOverlayImageView];
        
    }
    return self;
}

- (void)setMode:(GGOverlayViewMode)mode
{
    if (_mode == mode) return;
    
    _mode = mode;
    if (mode == GGOverlayViewModeLeft) {
        self.infoCardOverlayImageView.image = [UIImage imageNamed:@"trollface_300x200"];
    } else {
        self.infoCardOverlayImageView.image = [UIImage imageNamed:@"thumbs_up_300x300"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.infoCardOverlayImageView.frame = CGRectMake(50, 50, 100, 100);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
