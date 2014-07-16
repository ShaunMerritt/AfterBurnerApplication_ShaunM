//
//  SMMovieSimilar.m
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/14/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#import "SMMovieSimilar.h"

@implementation SMMovieSimilar

@synthesize title, synopsis;
@synthesize moviePosterURL;
@synthesize moviePoster, moviePosterDetailedURL, moviePosterOriginalURL, fullMoviePageURL;
@synthesize cast;
@synthesize critics_rating;
@synthesize critics_score;
@synthesize runtime;
@synthesize mpaa_rating;
@synthesize id;
@synthesize abridged_castMemberName;


- (id)initWithDictionary:(NSDictionary *)aDictionary {
	if ([self init]) {
        
		self.title = [aDictionary valueForKey:@"title"];
        self.synopsis = [aDictionary valueForKey:@"synopsis"];
		self.moviePosterURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"thumbnail"]];
        self.moviePosterDetailedURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"detailed"]];
        self.moviePosterOriginalURL = [NSURL URLWithString:[[aDictionary valueForKey:@"posters"] valueForKey:@"original"]];
        self.fullMoviePageURL = [NSURL URLWithString:[[aDictionary valueForKey:@"links"] valueForKey:@"alternate"]];
		self.cast = [aDictionary valueForKey:@"abridged_cast"];
		self.critics_score = [[aDictionary valueForKey:@"ratings"] valueForKey:@"critics_score"];
		self.critics_rating = [[aDictionary valueForKey:@"ratings"] valueForKey:@"critics_rating"];
		self.runtime = [aDictionary valueForKey:@"runtime"];
        self.mpaa_rating = [aDictionary valueForKey:@"mpaa_rating"];
        self.id = [aDictionary valueForKey:@"id"];
        self.links = [[aDictionary valueForKey:@"links"] valueForKey:@"self"];
        self.abridged_castMemberName = [[aDictionary valueForKey:@"abridged_cast"] valueForKey:@"name"];


        
	}
	return self;
}



@end
