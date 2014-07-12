//
//  SMRateMoviesViewController.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRateMoviesViewController : UIViewController

// Declare the info card view's properties
@property (weak, nonatomic) IBOutlet UIView *infoCardView;
@property (weak, nonatomic) IBOutlet UIImageView *infoCardImage;
@property (weak, nonatomic) IBOutlet UILabel *infoCardMovieName;
@property (weak, nonatomic) IBOutlet UILabel *infoCardMovieRating;

// Declare the user Rating View's properties
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
- (IBAction)userRatingLikeButtonClicked:(id)sender;
- (IBAction)userRatingNotSeenButtonClicked:(id)sender;
- (IBAction)userRatingDontLikeButtonClicked:(id)sender;


@end
