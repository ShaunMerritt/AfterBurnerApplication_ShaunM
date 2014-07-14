//
//  SMPhotoModel.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/13/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "JSONModel.h"

@protocol SMPhotoModel @end

@interface SMPhotoModel : JSONModel

@property (strong, nonatomic) NSURL* profile;
@end
