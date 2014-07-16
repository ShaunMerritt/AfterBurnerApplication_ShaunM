//
//  NetworkEngine.m
//  
//
//  Created by Shaun Merritt on 7/13/14.
//
//

#import "NetworkEngine.h"
#import "SMAppDelegate.h"
#import "SMMovie.h"
#import "SMRateMoviesViewController.h"
#import "SMMovieSimilar.h"

@implementation NetworkEngine
@synthesize count;

//translate string to JSON with ios4 support
-(NSDictionary *) getResponseDictionary:(NSData *)response{
    //Check for ios5 or later...
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        
        NSError *error;
        return [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    }
    else{
        NSLog(@"iOS < 5.0 not supported");
        return nil;
    }
}

-(MKNetworkOperation*) getBoxOfficeMovieList:(BoxOfficeMoivesResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kListMoviesBoxOffice,kAPIKey];
    
    
    
    MKNetworkOperation *op = [[ApplicationDelegate networkEngine] operationWithPath:path
                                              params:nil
                                          httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([completedOperation isCachedResponse]) {
             //DLog(@"Data from cache %@", [completedOperation responseString]);
         }
         else {
             //DLog(@"Data from server %@", [completedOperation responseString]);
         }
         /* process reponse here */
         
         NSString *rRated = [[NSString alloc] init];
         NSString *pG13 = [[NSString alloc] init];
         NSString *pg = [[NSString alloc] init];
         NSString *g = [[NSString alloc] init];
        
         for (NSString *rating in ApplicationDelegate.favoriteMpaa_rating) {
             
             if ([rating isEqualToString:@"R"]) {
                 
                 rRated = @"R";
             } else if ([rating isEqualToString:@"PG-13"]) {
                 
                 pG13 = @"PG-13";
             } else if ([rating isEqualToString:@"PG"]) {
                 
                 pg = @"PG";
             } else {
                 
                 g = @"G";
             }
         }
         
         
         NSDictionary *responseDict = [self getResponseDictionary:[completedOperation responseData]];
         
         NSArray *movies = responseDict[@"movies"];
         NSMutableArray *movieModelObjects = [[NSMutableArray alloc] init ];
         for (id movie in movies) {
             SMMovie *thisMovie = [[SMMovie alloc] initWithDictionary:movie];
             
             NSNumber *averageTime = [ApplicationDelegate.favoriteRunTimes valueForKeyPath:@"@avg.self"];
             int avgTimeInt = [averageTime intValue];
             
             int test = [thisMovie.runtime intValue] - avgTimeInt;
             
             int testABS = abs(test);
             
             

             
             
             if ([thisMovie.mpaa_rating isEqualToString:rRated] && testABS < ApplicationDelegate.minutesToBeWithin) {
                 [movieModelObjects addObject:thisMovie];
             }
             if ([thisMovie.mpaa_rating isEqualToString:pG13] && testABS < ApplicationDelegate.minutesToBeWithin) {
                 [movieModelObjects addObject:thisMovie];
             }
             if ([thisMovie.mpaa_rating isEqualToString: pg] && testABS < ApplicationDelegate.minutesToBeWithin) {
                 [movieModelObjects addObject:thisMovie];
             }
             if ([thisMovie.mpaa_rating isEqualToString:g] && testABS < ApplicationDelegate.minutesToBeWithin) {
                 [movieModelObjects addObject:thisMovie];
             }
             
             

             
             
         }
         NSArray *array = [NSArray arrayWithArray:movieModelObjects];
         
         completionBlock(array);
     }onError:^(NSError* error) {
         errorBlock(error);
         NSLog(@"error");
     }];
    [self enqueueOperation:op];
    return op;
}


-(MKNetworkOperation*) getSimilarMoviesList:(SimilarMoviesResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock {
    
    
    
    NSString *idForMovie = ApplicationDelegate.linkToCurrentMovie;//ApplicationDelegate.similarMovieId;
    NSString *path = [NSString stringWithFormat:@"%@%@",kListSimilarMoviesEnding, kAPIKey];

                              
    MKNetworkOperation *op = [[ApplicationDelegate networkEngine] operationWithPath:path
                                              params:nil
                                          httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         
         if([completedOperation isCachedResponse]) {
         }
         else {
         }
         /* process reponse here */
         NSDictionary *responseDict = [self getResponseDictionary:[completedOperation responseData]];
         
         //DLog(@"responseDict: %@", responseDict);
         NSArray *movies = responseDict[@"movies"];
         NSMutableArray *movieModelObjects = [[NSMutableArray alloc] init ];
         //DLog(@"movies: %@", movies);
         for (id movie in movies) {
             //DLog(@"movie: %@", movie);
             SMMovieSimilar *thisMovie = [[SMMovieSimilar alloc] initWithDictionary:movie];
            [movieModelObjects addObject:thisMovie];
             
         }
         
         NSArray *array = [NSArray arrayWithArray:movieModelObjects];
         completionBlock(array);
     }onError:^(NSError* error) {
         errorBlock(error);
         NSLog(@"Related Movies Error");
     }];
    [self enqueueOperation:op];
    return op;

}



-(MKNetworkOperation*) getMovieByCurrentDVDS:(TopRentalsResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@", kListMoviesTopRentals, kAPIKey];
    
    
    
    MKNetworkOperation *op = [[ApplicationDelegate networkEngine] operationWithPath:path
                                                                             params:nil
                                                                         httpMethod:@"GET"];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         if([completedOperation isCachedResponse]) {
         }
         else {
         }
         /* process reponse here */
         NSDictionary *responseDict = [self getResponseDictionary:[completedOperation responseData]];
         
         NSArray *movies = responseDict[@"movies"];
         NSMutableArray *movieModelObjects = [[NSMutableArray alloc] init ];
         for (id movie in movies) {
             SMMovie *thisMovie = [[SMMovie alloc] initWithDictionary:movie];
                          [movieModelObjects addObject:thisMovie];
             
         }
         NSArray *array = [NSArray arrayWithArray:movieModelObjects];
         completionBlock(array);
     }onError:^(NSError* error) {
         errorBlock(error);
         NSLog(@"error");
     }];
    [self enqueueOperation:op];
    return op;
}


-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"BoxOfficeMoviePosters"];
    return cacheDirectoryName;
}

@end
