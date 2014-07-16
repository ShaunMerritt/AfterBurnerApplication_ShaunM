//
//  SMRateMoviesViewController.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMRateMoviesViewController : UIViewController {
    NSArray *movieObjectsArray;
    NSArray *similarMovieImdbArray;


}


// Declare the info card view's properties
@property (weak, nonatomic) IBOutlet UIView *infoCardView;
//@property (nonatomic, strong) SMInfoMovieCardView *backCardView;
@property (weak, nonatomic) IBOutlet UIImageView *infoCardImage;
@property (weak, nonatomic) IBOutlet UILabel *infoCardMovieName;
@property (weak, nonatomic) IBOutlet UILabel *infoCardMovieRating;
@property (nonatomic, retain) NSArray *movieObjectsArray;
@property (nonatomic, retain) NSArray *similarMovieObjectsArray;
@property (nonatomic, retain) NSArray *similarMovieByCastArray;
@property (nonatomic, retain) NSArray *similarMovieImdbArray;
@property (nonatomic) NSNumber *runtime;
@property (nonatomic) NSString *mpaa_rating;
@property (nonatomic) BOOL *swipedYes;







@property (nonatomic, retain) NSString *similarMovieId;

//@property (nonatomic, strong) SMInfoMovieCardView *frontCardView;

// Declare the user Rating View's properties
@property (weak, nonatomic) IBOutlet UIView *userRatingView;
- (IBAction)userRatingLikeButtonClicked:(id)sender;
- (IBAction)userRatingNotSeenButtonClicked:(id)sender;
- (IBAction)userRatingDontLikeButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *haveNotSeenButton;
@property (weak, nonatomic) IBOutlet UIButton *dontLikeButton;

@property (nonatomic, strong) NSDictionary *weather;
@end
