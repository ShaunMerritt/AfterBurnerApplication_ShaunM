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

static NSString * const BaseURLString = @"http://api.rottentomatoes.com/api/public/v1.0/";

@interface SMRateMoviesViewController () {
    SMRottenTomatoesFeed* _feed;
    NSArray* movies;
}

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
    
    [self setUpViews];
    
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
        movies = [SMMovieModel arrayOfModelsFromDictionaries:results];
    }
    @catch (NSException *exception) {
        // Handle Error here
        NSLog(@"Error");
    }
    
    NSLog(@"%@", movies);
    
    // You can access the properties from the SMMovieModel class like so:
    SMMovieModel* movie = movies[0];
    NSLog([NSString stringWithFormat:@"%@", movie.title]);
    
}

- (void) addShadowForView: (UIView *)view {
    
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
}

- (IBAction)userRatingDontLikeButtonClicked:(id)sender {
}
@end
