//
//  SMInfoViewController.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMInfoViewController.h"
#import "SMAppDelegate.h"

@interface SMInfoViewController ()

@end

@implementation SMInfoViewController
@synthesize timeLabel;
@synthesize timeSlider;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) sliderValueChanged:(UISlider *)sender {
    timeLabel.text = [NSString stringWithFormat:@"%.1f", [sender value]];
    ApplicationDelegate.minutesToBeWithin = [sender value];
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

@end
