//
//  SMAppDelegate.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMConstants.h"
#import "NetworkEngine.h"

#define ApplicationDelegate ((SMAppDelegate *)[UIApplication sharedApplication].delegate)

@class SMRateMoviesViewController;

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SMRateMoviesViewController *viewController;

@property (strong, nonatomic) NetworkEngine *networkEngine;
@property (strong, nonatomic) NetworkEngine *imdbNetworkEngine;


@property (strong, nonatomic) NSString *similarMovieId;

@property (strong, nonatomic) NSString *linkToCurrentMovie;

@property (nonatomic) BOOL needTo;

@property (nonatomic) NSString *thisMovieCastMemeberName;
@property (nonatomic) NSString *convertThisAlias;

@property (nonatomic, retain) NSMutableArray *favoriteRunTimes;
@property (nonatomic, retain) NSMutableArray *favoriteMpaa_rating;
@property (nonatomic) int minutesToBeWithin;




@end
