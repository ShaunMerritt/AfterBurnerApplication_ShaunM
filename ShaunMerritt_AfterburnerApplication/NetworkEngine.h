//
//  NetworkEngine.h
//  
//
//  Created by Shaun Merritt on 7/13/14.
//
//

#import "MKNetworkEngine.h"

@interface NetworkEngine : MKNetworkEngine

typedef void (^CurrencyResponseBlock)(double rate);
typedef void (^RegisterResponseBlock)(NSDictionary *responseDict);
typedef void (^BoxOfficeMoivesResponseBlock)(NSArray *movieModelsArray);
typedef void (^TopRentalsResponseBlock)(NSArray *movieModelsArray);
typedef void (^SimilarMoviesResponseBlock)(NSArray *similarMoviesArray);
typedef void (^SimilarMoviesBasedOnActorsBlock)(NSArray *similarMoviesBasedOnActorsArray);
typedef void (^FindRottenTomatoesMovieId)(NSArray *rottenTomatoesAliasMovieId);


@property (nonatomic) int count;

-(MKNetworkOperation*) getBoxOfficeMovieList:(BoxOfficeMoivesResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getSimilarMoviesList:(SimilarMoviesResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getMovieInfoWithCastIncluded:(SimilarMoviesResponseBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getMovieByCurrentDVDS:(BoxOfficeMoivesResponseBlock)completionBlock onError:(MKNKErrorBlock)errorBlock;

-(MKNetworkOperation*) getMoviesWithSameCastMember:(SimilarMoviesBasedOnActorsBlock) completionBlock onError:(MKNKErrorBlock) errorBlock;

-(MKNetworkOperation*) getMovieAliasOnRottenTomatoes:(FindRottenTomatoesMovieId) completionBlock onError:(MKNKErrorBlock) errorBlock;



@end
