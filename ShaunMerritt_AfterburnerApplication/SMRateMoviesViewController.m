//
//  SMRateMoviesViewController.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMRateMoviesViewController.h"
#import "SMAppDelegate.h"
#import "JSONModelLib.h"
#import "SMOverlayView.h"
#import "UIImageView+AFNetworking.h"
#import <Foundation/Foundation.h>
#import "SMMovie.h"
#import "SMMovieSimilar.h"
#import "SMConstants.h"





static NSString * const BaseURLString = @"http://api.rottentomatoes.com/api/public/v1.0/";



@interface SMRateMoviesViewController () {
    //NSArray *movies;
}

@property(nonatomic) CGPoint originalPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, strong) SMOverlayView *overlayView;
@property (nonatomic, strong) NSArray *movies;

@property (nonatomic, strong) NSArray *suggestedMovies;

@property (nonatomic) int currentMovieIndex;
@property (nonatomic) int currentSuggestedMovieIndex;
//@property(nonatomic, strong) id movie;
@property (nonatomic) BOOL suggestedMovieIsLikedByUser;
@property (nonatomic) BOOL isLikedByUser;
@property (nonatomic) BOOL haventSeenButtonPressedBool;


@end

@implementation SMRateMoviesViewController

@synthesize infoCardView;
@synthesize infoCardImage;
@synthesize infoCardMovieName;
@synthesize infoCardMovieRating;
@synthesize movieObjectsArray;
@synthesize similarMovieObjectsArray;
@synthesize similarMovieId;
@synthesize similarMovieByCastArray;
@synthesize similarMovieImdbArray;
@synthesize swipedYes;


#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"This is a list of the most popular dvd rentals at the moment. Swipe right on the picture to like it, or swipe left to dislike. Similarly, you can click the 'Like' and 'Dislike' buttons at the bottom of the screen. There are 10 movies to rate." delegate:nil cancelButtonTitle:@"Got it!" otherButtonTitles: nil];
    [alert show];
    
    self.currentMovieIndex         = 0;
    self.currentSuggestedMovieIndex = 0;
    
    ApplicationDelegate.favoriteRunTimes = [[NSMutableArray alloc] init];
    ApplicationDelegate.favoriteMpaa_rating = [[NSMutableArray alloc] init];
    
    [ApplicationDelegate.networkEngine getMovieByCurrentDVDS:^(NSArray *responseArray) {
        
        movieObjectsArray = responseArray;
        //[tableView reloadData];
        
        [self queryForCurrentMovieIndex];

        
    }
                                                     onError:^(NSError* error) {
                                                         NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                              [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                     }];

    
    
    [self setUpViews];
    
    
    // Add a gesture recognizer to the infoCardView
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.infoCardView addGestureRecognizer:self.panGestureRecognizer];
    
    // Add the overlay view
    self.overlayView = [[SMOverlayView alloc] initWithFrame:self.infoCardView.bounds];
    self.overlayView.alpha = 0;
    [self.infoCardView addSubview:self.overlayView];
    
    
}

- (void) setUpViews {
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.infoCardView];
    [self addShadowForView:self.userRatingView];
    
    // Create string containign the full URL, then use that to make the NSURLRequest
    NSString *string = [NSString stringWithFormat:@"%@lists/dvds/top_rentals.json?apikey=%@", BaseURLString, kAPIKey];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an request operation, set response type to JSON
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // JSON serializer parses the received data and stores in the dictionary responseObject
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        
        self.weather = (NSDictionary *)responseObject;
        //self.title = @"JSON Retrieved";
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Show errors here
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // Tell the operation to start
    [operation start];
    
    
}


- (void) addShadowForView: (UIView *)view {
    
    if (view == self.infoCardView) {
        self.infoCardImage.image = [UIImage imageNamed:@""];
    }
    
    view.layer.masksToBounds = NO;
    view.layer.cornerRadius = 4;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 0.25;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark IBActions



- (IBAction)userRatingLikeButtonClicked:(id)sender {
    
    [self choseLiked];
    
}

- (IBAction)userRatingNotSeenButtonClicked:(id)sender {
    
    _haventSeenButtonPressedBool = YES;
    
    SMMovie *thisMovie;
    thisMovie = (SMMovie*)movieObjectsArray[self.currentMovieIndex];

    ApplicationDelegate.similarMovieId = thisMovie.id;
    
        
    [ApplicationDelegate.networkEngine getSimilarMoviesList:^(NSArray *responseArray) {
        similarMovieObjectsArray = responseArray;
        //[tableView reloadData];
        
        [self queryForCurrentMovieIndex];
        
        
    }
                                                     onError:^(NSError* error) {
                                                         NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                               [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                     }];
    
}




- (IBAction)userRatingDontLikeButtonClicked:(id)sender {
    
    [self choseDislike];
    
}




#pragma mark GestureRecognizers

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self.infoCardView].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self.infoCardView].y;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.infoCardView.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI * rotationStrength / 16);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            self.infoCardView.center = CGPointMake(self.originalPoint.x + xDistance + 20, self.originalPoint.y + yDistance);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.infoCardView.transform = scaleTransform;
            
             [self updateOverlay:xDistance];
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            
           
            
            if (xDistance > 146) {
                swipedYes = YES;
                [self choseLiked];
                
                
            }
            
            if (xDistance < -146) {
                
                swipedYes = YES;

                [self choseDislike];
            }
            
            if (xDistance >= -146 && xDistance <= 146) {
                [self resetViewPositionAndTransformations];
                
            }
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
    
}

- (void) choseLiked {
    
    if (swipedYes == NO) {
        self.originalPoint = self.infoCardView.center;
    }

    
    [UIView animateWithDuration:0.5 animations:^{
        self.infoCardView.center = CGPointMake(self.originalPoint.x + 160 + 300, self.originalPoint.y + 20);
        self.overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.infoCardView.alpha = 0;
        [self resetViewPositionAndTransformations];
        [self setUpNextMovie];
    }];
    
   
    [ApplicationDelegate.favoriteMpaa_rating addObject:[NSString stringWithFormat:@"%@", self.mpaa_rating]];
    [ApplicationDelegate.favoriteRunTimes addObject:self.runtime];
    
    
    
    
    [self choseOne];
}

- (void) choseDislike {
    
    if (swipedYes == NO) {
        self.originalPoint = self.infoCardView.center;
    }

    if ([ApplicationDelegate.favoriteRunTimes count] == 0 && [self.infoCardMovieName.text isEqualToString:@"Jack Ryan: Shadow Recruit"]) {
        [self choseLiked];
        
        
    } else {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.infoCardView.center = CGPointMake(self.originalPoint.x - 160 - 300, self.originalPoint.y - 20);
        self.overlayView.alpha = 0;
    } completion:^(BOOL finished) {
        
        self.infoCardView.alpha = 0;
        [self resetViewPositionAndTransformations];
        [self setUpNextMovie];
    }];
    
    
    }
    [self choseOne];
}

- (void) choseOne {
    
    // Add code here for what to do after the decision was made
    if (_haventSeenButtonPressedBool == YES) {
        _haventSeenButtonPressedBool = NO;
    }
    
    
    
    // Add a gesture recognizer to the infoCardView
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.infoCardView addGestureRecognizer:self.panGestureRecognizer];
    
    self.overlayView = [[SMOverlayView alloc] initWithFrame:self.infoCardView.bounds];
    self.overlayView.alpha = 0;
    [self.infoCardView addSubview:self.overlayView];
    
}

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = GGOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = GGOverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / 100, 0.4);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                     }];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.infoCardView.center = self.originalPoint;
                         self.infoCardView.transform = CGAffineTransformMakeRotation(0);
                         self.overlayView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         self.infoCardView.alpha = 1;
                         self.overlayView.alpha = 0;
                     }];
}

#pragma mark - Helper Methods



- (void) queryForCurrentMovieIndex {
    
    if (_haventSeenButtonPressedBool == NO) {
        
        // Configure the cell...
        SMMovie *thisMovie;
        
        thisMovie = (SMMovie*)movieObjectsArray[self.currentMovieIndex];
        
        self.mpaa_rating = thisMovie.mpaa_rating;
        self.runtime = thisMovie.runtime;
        
        infoCardMovieRating.text = thisMovie.mpaa_rating;
        infoCardMovieName.text = thisMovie.title;
        
        
        NSURL *thisMoviePosterURL = thisMovie.moviePosterURL;
        
        
        ApplicationDelegate.linkToCurrentMovie = [NSString stringWithFormat:@"%@%@", thisMovie.links,kEnding];

        [ApplicationDelegate.networkEngine imageAtURL:thisMoviePosterURL completionHandler:^(UIImage *fetchedImage, NSURL *fetchedURL, BOOL isInCache) {
            NSLog(@"fetchedURL: %@", [fetchedURL absoluteString]);
            NSLog(@"thisMoviePosterURL: %@", [thisMoviePosterURL absoluteString]);
            if(thisMoviePosterURL == fetchedURL)
            {
                
                infoCardImage.image = fetchedImage;
            }
            
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            //code
        }];
    } else {
        
        // Configure the cell...
        SMMovieSimilar *thisMovie;
        
        
        

        
        
        if (thisMovie.title == NULL) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Suggestions :(" message:@"Calling similar movies from the Rotten Tomatoes API returned no results... Continue on! Like some movies!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            
            [alert show];
            
            [self choseDislike];

            
        } else {
            
        
        thisMovie = (SMMovieSimilar*)similarMovieObjectsArray[self.currentSuggestedMovieIndex];

        infoCardMovieRating.text = thisMovie.mpaa_rating;
        infoCardMovieName.text = thisMovie.title;
        
        NSURL *thisMoviePosterURL = thisMovie.moviePosterURL;
        
            
        [ApplicationDelegate.networkEngine imageAtURL:thisMoviePosterURL completionHandler:^(UIImage *fetchedImage, NSURL *fetchedURL, BOOL isInCache) {
            
            NSLog(@"thisMoviePosterURL: %@", [thisMoviePosterURL absoluteString]);
            if(thisMoviePosterURL == fetchedURL)
            {
                NSLog(@"set imageView poster: %@", [thisMoviePosterURL absoluteString]);
                infoCardImage.image = fetchedImage;
            }
            
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            //code
        }];
        
        }

    }
    
}

- (void) setUpNextMovie {
    if (self.currentMovieIndex + 1 < movieObjectsArray.count) {
        self.currentMovieIndex++;
        if (_haventSeenButtonPressedBool == YES) {
            _haventSeenButtonPressedBool = NO;
        }
        [self queryForCurrentMovieIndex];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Movie Recommendations!" message:@"Great job! We collected information on what mpaa rating you are inclined to as well as what time length of movies is best for you. This is a list of Box Office Movies that fit your viewing habits. To change the time interval, and get more reults, click the info button." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"tableViewController"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:vc animated:YES completion:NULL];
    }
}


@end











