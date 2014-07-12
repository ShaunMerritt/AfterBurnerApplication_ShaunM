//
//  SMRottenTomatoesFeed.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/11/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "JSONModel.h"
#import "SMMovieModel.h"

@interface SMRottenTomatoesFeed : JSONModel

@property (strong, nonatomic) NSArray<SMMovieModel>* Movies;

@end
