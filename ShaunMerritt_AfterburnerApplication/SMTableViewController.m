//
//  SMTableViewController.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMTableViewController.h"
#import "SMRateMoviesViewController.h"
#import "SMAppDelegate.h"
#import "JSONModelLib.h"
#import "SMOverlayView.h"
#import "UIImageView+AFNetworking.h"
#import <Foundation/Foundation.h>
#import "SMMovie.h"
#import "SMMovieSimilar.h"
#import "SMConstants.h"

@interface SMTableViewController ()

@end

@implementation SMTableViewController

@synthesize movieObjectsArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ApplicationDelegate.networkEngine getBoxOfficeMovieList:^(NSArray *responseArray) {
        NSLog(@"response: %@", responseArray);
        movieObjectsArray = responseArray;
        NSLog(@"%@", responseArray);
        [self.tableView reloadData];

        
        
    }
                                                     onError:^(NSError* error) {
                                                         NSLog(@"%@\t%@\t%@\t%@", [error localizedDescription], [error localizedFailureReason],
                                                               [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                                                     }];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [movieObjectsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    
    // Configure the cell...
    SMMovie *thisMovie;
    thisMovie = (SMMovie*)movieObjectsArray[indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
    UILabel *labelView = (UILabel *)[cell viewWithTag:1002];
    UILabel *ratingLabel = (UILabel *)[cell viewWithTag:1003];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:1004];

    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    labelView.text = thisMovie.title;
    
    NSURL *thisMoviePosterURL = thisMovie.moviePosterURL;
        [ApplicationDelegate.networkEngine imageAtURL:thisMoviePosterURL onCompletion:^(UIImage *fetchedImage, NSURL *fetchedURL, BOOL isInCache) {
        DLog(@"fetchedURL: %@", [fetchedURL absoluteString]);
        DLog(@"thisMoviePosterURL: %@", [thisMoviePosterURL absoluteString]);
        if(thisMoviePosterURL == fetchedURL)
        {
            DLog(@"set imageView poster: %@", [thisMoviePosterURL absoluteString]);
            imageView.image = fetchedImage;
        }
        
    }];
    ratingLabel.text = thisMovie.mpaa_rating;
    timeLabel.text = [NSString stringWithFormat:@"%@ Minutes", thisMovie.runtime];
    
    
    NSNumber *averageTime = [ApplicationDelegate.favoriteRunTimes valueForKeyPath:@"@avg.self"];
    NSLog(@"Average time is : %@", averageTime);
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
