//
//  SMRateMoviesViewController.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMRateMoviesViewController.h"

@interface SMRateMoviesViewController ()

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
    [self addShadowForView:self.infoCardView];
    [self addShadowForView:self.userRatingView];
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
