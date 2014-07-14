//
//  SMRateMoviesViewController.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMRateMoviesViewController.h"
#import "JSONModelLib.h"
#import "SMRottenTomatoesFeed.h"
#import "SMMovieModel.h"
#import "SMOverlayView.h"
#import "UIImageView+AFNetworking.h"
#import "SMPhotoModel.h"
#import <Foundation/Foundation.h>





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
//@property(nonatomic, strong) id movie;
@property (nonatomic, strong) SMMovieModel *movie;
@property (nonatomic, strong) SMPhotoModel *posters;
@property (nonatomic) BOOL *isLikedByUser;

@end

@implementation SMRateMoviesViewController

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
    
    self.likeButton.enabled        = NO;
    self.dontLikeButton.enabled  = NO;
    //self.haveNotSeenButton.enabled = NO;

    self.currentMovieIndex         = 0;
    
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
    NSString *string = [NSString stringWithFormat:@"%@lists/dvds/top_rentals.json?apikey=9htuhtcb4ymusd73d4z6jxcj", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an request operation, set response type to JSON
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // JSON serializer parses the received data and stores in the dictionary responseObject
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        [self didReceiveJSON: responseObject];
        
        self.weather = (NSDictionary *)responseObject;
        self.title = @"JSON Retrieved";
        //NSLog(@"%@",self.weather);
        
        
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

- (void) didReceiveJSON: (NSDictionary *)obj {
    
    // Create an array of the results of all the data in the movies keypath
    NSArray* results = obj[@"movies"];
    
    @try {
        _movies = [SMMovieModel arrayOfModelsFromDictionaries:results];
    }
    @catch (NSException *exception) {
        // Handle Error here
        NSLog(@"Error");
    }
    
    NSLog(@"%@", _movies);
    
    [self queryForCurrentMovieIndex];
    
    // You can access the properties from the SMMovieModel class like so:
    //SMMovieModel* movie = _movies[0];
    
    //NSArray* test = results[@"photo"];
    
    NSLog(@"%@",_movie.posters.profile);
    //NSLog([NSString stringWithFormat:@"%@", movie.title]);
    
    //SMMovieModel* movie = _movies[0];
    

    
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
}

- (IBAction)userRatingNotSeenButtonClicked:(id)sender {
    
    // Create string containign the full URL, then use that to make the NSURLRequest
    NSString *string = [NSString stringWithFormat:@"%@movies/%@/similar.json?limit=1&apikey=9htuhtcb4ymusd73d4z6jxcj", BaseURLString, _movie.id];
    NSLog(@"%@", string);
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create an request operation, set response type to JSON
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // JSON serializer parses the received data and stores in the dictionary responseObject
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        [self didReceiveJSONForSimilarMovie: responseObject];
        
        self.weather = (NSDictionary *)responseObject;
        self.title = @"JSON Retrieved";
        NSLog(@"%@",self.weather);
        
        
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

- (void) didReceiveJSONForSimilarMovie: (NSDictionary *)obj {
    
    // Create an array of the results of all the data in the movies keypath
    NSArray* results = obj[@"movies"];
    
    @try {
        _suggestedMovies = [SMMovieModel arrayOfModelsFromDictionaries:results];
    }
    @catch (NSException *exception) {
        // Handle Error here
        NSLog(@"Error");
    }
    
    NSLog(@"%@", _suggestedMovies);
    
    [self queryForCurrentMovieIndex];
    
    // You can access the properties from the SMMovieModel class like so:
    //SMMovieModel* movie = _movies[0];
    
    //NSArray* test = results[@"photo"];
    
    NSLog(@"%@",_movie.posters.profile);
    //NSLog([NSString stringWithFormat:@"%@", movie.title]);
    
    //SMMovieModel* movie = _movies[0];
    
    
    
    
    NSURL *url = _movie.posters.profile;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    
    
    
    [self.infoCardImage setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           self.infoCardImage.image = image;
                                           [self.infoCardImage setNeedsLayout];
                                           
                                       } failure:nil];

    
    
    
}


- (IBAction)userRatingDontLikeButtonClicked:(id)sender {
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
            
            NSLog(@"%f", xDistance);
            
            if (xDistance > 146) {
                NSLog(@"Liked");
                /*
                [UIView beginAnimations:@"animateView" context:nil];
                [UIView setAnimationDuration:0.5];
                
                
                CGRect viewFrame = [self.infoCardView frame];
                viewFrame.origin.x = 480;
                self.infoCardView.frame = viewFrame;
                
                self.infoCardView.alpha = 0.5;
                [self.view addSubview:self.infoCardView];
                [UIView commitAnimations];
                
                */
                [UIView animateWithDuration:0.5 animations:^{
                    self.infoCardView.center = CGPointMake(self.originalPoint.x + xDistance + 300, self.originalPoint.y + yDistance);
                    self.overlayView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    self.infoCardView.alpha = 0;
                    [self resetViewPositionAndTransformations];
                    [self setUpNextMovie];
                }];
                
                [self choseOne];
            }
            
            if (xDistance < -146) {
                NSLog(@"Disliked");
                [UIView beginAnimations:@"animateView" context:nil];
                [UIView setAnimationDuration:0.5];
                
                
                CGRect viewFrame = [self.infoCardView frame];
                viewFrame.origin.x = -480;
                self.infoCardView.frame = viewFrame;
                
                self.infoCardView.alpha = 0.5;
                [self.view addSubview:self.infoCardView];
                [UIView commitAnimations];

                [self choseOne];
            }
            
            if (xDistance >= -146 && xDistance <= 146) {
                NSLog(@"Cant decide");
                [self resetViewPositionAndTransformations];
                
            }
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
    
}

- (void) choseOne {
    
    // Add code here for what to do after the decision was made
    
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
    if ([self.movies count] > 0) {
        self.movie = self.movies[_currentMovieIndex];
        _movie = _movies[_currentMovieIndex];
        self.infoCardMovieName.text = [NSString stringWithFormat:@"%@", _movie.title];
        self.infoCardMovieRating.text = [NSString stringWithFormat:@"%@", _movie.mpaa_rating];
        //_movie.moviePoster.profile
        NSLog(@"%@", _movie.title);
        
        
        NSLog(@"%@", _movie.posters.profile);
        
        NSURL *url = _movie.posters.profile;
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
        
        
        
        [self.infoCardImage setImageWithURLRequest:request
                              placeholderImage:placeholderImage
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           self.infoCardImage.image = image;
                                           [self.infoCardImage setNeedsLayout];
                                           
                                       } failure:nil];
        
    }
}

- (void) setUpNextMovie {
    if (self.currentMovieIndex + 1 < self.movies.count) {
        self.currentMovieIndex++;
        [self queryForCurrentMovieIndex];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more movies" message:@"You're done!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}


@end











