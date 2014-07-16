//
//  SMConstants.h
//  ShaunMerritt_AfterburnerApplication
//
//  Created by Shaun Merritt on 7/13/14.
//  Copyright (c) 2014 True Merit Development. All rights reserved.
//

#ifndef ShaunMerritt_AfterburnerApplication_SMConstants_h
#define ShaunMerritt_AfterburnerApplication_SMConstants_h



#warning Place your api key here!!!
#define kAPIKey @"API-KEY-HERE" //API KEY HERE!!!!!!!!!!





#define kBaseURL @"api.rottentomatoes.com/api/public/v1.0"
#define kListMoviesTopRentals @"/lists/dvds/top_rentals.json?apikey="
#define kListSimilarMoviesEnding @"/similar.json?limit=5&apikey="
#define kBaseMovieURL @"/movies/"
#define kMovieCast @"/cast.json?&apikey="
#define kEnding @"?apikey="
#define kCurrentReleases @"lists/dvds/current_releases.json?apikey="
#define kFindMoviesWithRelatedActorUsingIMDB @"www.imdb.com/xml/find?json=1&nr=1&nm=on&q="
#define kListMoviesBoxOffice @"lists/movies/box_office.json?apikey="

#endif
