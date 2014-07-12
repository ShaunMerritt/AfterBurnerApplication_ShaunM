//
//  SMMovieModel.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "JSONModel.h"

@protocol SMMovieModel @end

@interface SMMovieModel : JSONModel

// These properties are the names of the keys in the response json (Handled by JSONModel)
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* year;
@property (strong, nonatomic) NSString* mpaa_rating;

@end
