//
//  SMInfoViewController.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/15/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMInfoViewController : UIViewController

@property (nonatomic, strong) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
