//
//  SMOverlayView.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/12/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , GGOverlayViewMode) {
    GGOverlayViewModeLeft,
    GGOverlayViewModeRight
};

@interface SMOverlayView : UIView

@property (nonatomic) GGOverlayViewMode mode;

@end
