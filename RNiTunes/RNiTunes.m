//
//  RNiTunes.m
//  RNiTunes
//
//  Created by Jénaïc Cambré on 13/01/16.
//  Copyright © 2016 Jénaïc Cambré. All rights reserved.
//

#import "RNiTunes.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RCTConvert.h"

@interface RNiTunes()

@end

@implementation RNiTunes
{
    
}

RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(getTracks:(NSDictionary *)params successCallback:(RCTResponseSenderBlock)successCallback) {
    
    NSLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    NSArray *fields = [RCTConvert NSArray:params[@"fields"]];
    NSDictionary *query = [RCTConvert NSDictionary:params[@"query"]];
    
    //NSLog(@"query %@", query);
    
    
    MPMediaQuery *songsQuery = [MPMediaQuery songsQuery];
    //[songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[NSNumber numberWithBool:NO] forProperty:MPMediaItemPropertyIsCloudItem]];
    if ([query objectForKey:@"title"] != nil) {
        NSString *searchTitle = [query objectForKey:@"title"];
        [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:searchTitle forProperty:MPMediaItemPropertyTitle comparisonType:MPMediaPredicateComparisonContains]];
    }
    if ([query objectForKey:@"albumTitle"] != nil) {
        NSString *searchAlbumTitle = [query objectForKey:@"albumTitle"];
        [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:searchAlbumTitle forProperty:MPMediaItemPropertyAlbumTitle comparisonType:MPMediaPredicateComparisonContains]];
    }
    if ([query objectForKey:@"albumArtist"] != nil) {
        NSString *searchalbumArtist = [query objectForKey:@"albumArtist"];
        [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:searchalbumArtist forProperty:MPMediaItemPropertyAlbumArtist comparisonType:MPMediaPredicateComparisonContains]];
    }
    if ([query objectForKey:@"artist"] != nil) {
        NSString *searchArtist = [query objectForKey:@"artist"];
        [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:searchArtist forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonContains]];
    }
    if ([query objectForKey:@"genre"] != nil) {
        NSString *searchGenre = [query objectForKey:@"genre"];
        [songsQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:searchGenre forProperty:MPMediaItemPropertyGenre comparisonType:MPMediaPredicateComparisonContains]];
    }
    
    NSMutableArray *mutableSongsToSerialize = [NSMutableArray array];
    
    for (MPMediaItem *song in songsQuery.items) {
        
         // filterable
        NSString *title = [song valueForProperty: MPMediaItemPropertyTitle]; // filterable
        NSString *albumTitle = [song valueForProperty: MPMediaItemPropertyAlbumTitle]; // filterable
        NSString *albumArtist = [song valueForProperty: MPMediaItemPropertyAlbumArtist]; // filterable
        NSString *genre = [song valueForProperty: MPMediaItemPropertyGenre]; // filterable
        NSString *duration = [song valueForProperty: MPMediaItemPropertyPlaybackDuration];
        
        NSString *playCount = [song valueForProperty: MPMediaItemPropertyPlayCount];
        
        NSDictionary *songDictionary = [NSMutableDictionary dictionary];
        
        if (fields == nil) {
            songDictionary = @{@"albumTitle":albumTitle, @"albumArtist": albumArtist, @"duration":duration, @"genre":genre, @"playCount": playCount, @"title": title};
        } else {
            if ([fields containsObject: @"persistentId"]) {
                NSString *persistentId = [song valueForProperty: MPMediaItemPropertyPersistentID];
                [songDictionary setValue:[NSNumber numberWithInt:persistentId] forKey:@"persistentId"];
            }
            if ([fields containsObject: @"albumPersistentId"]) {
                NSString *albumPersistentId = [song valueForProperty: MPMediaItemPropertyAlbumPersistentID];
                [songDictionary setValue:[NSNumber numberWithInt:albumPersistentId] forKey:@"albumPersistentId"];
            }
            if ([fields containsObject: @"artistPersistentId"]) {
                NSString *artistPersistentId = [song valueForProperty: MPMediaItemPropertyArtistPersistentID];
                [songDictionary setValue:[NSNumber numberWithInt:artistPersistentId] forKey:@"artistPersistentId"];
            }
            if ([fields containsObject: @"albumArtistPersistentId"]) {
                NSString *albumArtistPersistentId = [song valueForProperty: MPMediaItemPropertyAlbumArtistPersistentID];
                [songDictionary setValue:[NSNumber numberWithInt:albumArtistPersistentId] forKey:@"albumArtistPersistentId"];
            }
            if ([fields containsObject: @"genrePersistentId"]) {
                NSString *genrePersistentId = [song valueForProperty: MPMediaItemPropertyGenrePersistentID]; // filterable
                [songDictionary setValue:[NSNumber numberWithInt:genrePersistentId] forKey:@"genrePersistentId"];
            }
            if ([fields containsObject: @"composerPersistentId"]) {
                NSString *composerPersistentId = [song valueForProperty: MPMediaItemPropertyComposerPersistentID]; // filterable
                
                [songDictionary setValue:[NSNumber numberWithInt:composerPersistentId] forKey:@"composerPersistentId"];
            }
            if ([fields containsObject: @"podcastPersistentId"]) {
                NSString *podcastPersistentId = [song valueForProperty: MPMediaItemPropertyPodcastPersistentID];
                [songDictionary setValue:[NSNumber numberWithInt:podcastPersistentId] forKey:@"podcastPersistentId"];
            }
            if ([fields containsObject: @"mediaType"]) {
                NSString *mediaType = [song valueForProperty: MPMediaItemPropertyMediaType]; // filterable
                
                [songDictionary setValue:[NSNumber numberWithInt:mediaType] forKey:@"mediaType"];
            }
            if ([fields containsObject: @"title"]) {
                [songDictionary setValue:[NSString stringWithString:title] forKey:@"title"];
            }
            if ([fields containsObject: @"albumTitle"]) {
                [songDictionary setValue:[NSString stringWithString:albumTitle] forKey:@"albumTitle"];
            }
            if ([fields containsObject: @"artist"]) {
                NSString *artist = [song valueForProperty: MPMediaItemPropertyArtist]; // filterable
                [songDictionary setValue:[NSString stringWithString:artist] forKey:@"artist"];
            }
            if ([fields containsObject: @"albumArtist"]) {
                [songDictionary setValue:[NSString stringWithString:albumArtist] forKey:@"albumArtist"];
            }
            if ([fields containsObject: @"genre"]) {
                [songDictionary setValue:[NSString stringWithString:genre] forKey:@"genre"];
            }
            if ([fields containsObject: @"composer"]) {
                NSString *composer = [song valueForProperty: MPMediaItemPropertyComposer]; // filterable
                if (composer == nil) {
                    composer = @"";
                }
                [songDictionary setValue:[NSString stringWithString:composer] forKey:@"composer"];
            }
            if ([fields containsObject: @"duration"]) {
                [songDictionary setValue:[NSNumber numberWithInt:duration] forKey:@"duration"];
            }
            if ([fields containsObject: @"albumTrackNumber"]) {
                NSString *albumTrackNumber = [song valueForProperty: MPMediaItemPropertyAlbumTrackNumber];
                
                [songDictionary setValue:[NSNumber numberWithInt:albumTrackNumber] forKey:@"albumTrackNumber"];
            }
            if ([fields containsObject: @"albumTrackCount"]) {
                NSString *albumTrackCount = [song valueForProperty: MPMediaItemPropertyAlbumTrackCount];
                
                [songDictionary setValue:[NSNumber numberWithInt:albumTrackCount] forKey:@"albumTrackCount"];
            }
            if ([fields containsObject: @"discNumber"]) {
                NSString *discNumber = [song valueForProperty: MPMediaItemPropertyDiscNumber];
                
                [songDictionary setValue:[NSNumber numberWithInt:discNumber] forKey:@"discNumber"];
            }
            if ([fields containsObject: @"discCount"]) {
                NSString *discCount = [song valueForProperty: MPMediaItemPropertyDiscCount];
                
                [songDictionary setValue:[NSNumber numberWithInt:discCount] forKey:@"discCount"];
            }
            /*if ([fields containsObject: @"artwork"]) {
                NSString *artwork = [song valueForProperty: MPMediaItemPropertyArtwork];
             
                [songDictionary setValue:[NSString stringWithString:artwork] forKey:@"artwork"];
            }*/
            if ([fields containsObject: @"lyrics"]) {
                NSString *lyrics = [song valueForProperty: MPMediaItemPropertyLyrics];
                
                [songDictionary setValue:[NSString stringWithString:lyrics] forKey:@"lyrics"];
            }
            if ([fields containsObject: @"isCompilation"]) {
                NSString *isCompilation = [song valueForProperty: MPMediaItemPropertyIsCompilation]; // filterable
                
                [songDictionary setValue:[NSNumber numberWithBool:isCompilation] forKey:@"isCompilation"];
            }
            /*if ([fields containsObject: @"releaseDate"]) {
                NSString *releaseDate = [song valueForProperty: MPMediaItemPropertyReleaseDate];
             
                [songDictionary setValue:[NSString stringWithString:releaseDate] forKey:@"releaseDate"];
            }*/
            if ([fields containsObject: @"beatsPerMinute"]) {
                NSString *beatsPerMinute = [song valueForProperty: MPMediaItemPropertyBeatsPerMinute];
                
                [songDictionary setValue:[NSNumber numberWithInt:beatsPerMinute] forKey:@"beatsPerMinute"];
            }
            if ([fields containsObject: @"comments"]) {
                NSString *comments = [song valueForProperty: MPMediaItemPropertyComments];
                if (comments == nil) {
                    comments = @"";
                }
                [songDictionary setValue:[NSString stringWithString:comments] forKey:@"comments"];
            }
            /*if ([fields containsObject: @"assetUrl"]) {
                NSString *assetUrl = [song valueForProperty: MPMediaItemPropertyAssetURL];
                if (assetUrl == nil) {
                    assetUrl = @"";
                }
                [songDictionary setValue:[NSString stringWithString:assetUrl] forKey:@"assetUrl"];
            }*/
            if ([fields containsObject: @"isCloudItem"]) {
                NSString *isCloudItem = [song valueForProperty: MPMediaItemPropertyIsCloudItem];
                
                [songDictionary setValue:[NSNumber numberWithBool:isCloudItem] forKey:@"isCloudItem"];
            }
            if ([fields containsObject: @"playCount"]) {
                [songDictionary setValue:[NSNumber numberWithInt:playCount] forKey:@"playCount"];
            }
            if ([fields containsObject: @"skipCount"]) {
                NSString *skipCount = [song valueForProperty: MPMediaItemPropertySkipCount];
                
                [songDictionary setValue:[NSNumber numberWithInt:skipCount] forKey:@"skipCount"];
            }
            if ([fields containsObject: @"rating"]) {
                NSString *rating = [song valueForProperty: MPMediaItemPropertyRating];
                
                [songDictionary setValue:[NSNumber numberWithInt:rating] forKey:@"rating"];
            }
            /*if ([fields containsObject: @"playedDate"]) {
                NSString *playedDate = [song valueForProperty: MPMediaItemPropertyLastPlayedDate];
             
                [songDictionary setValue:[NSString stringWithString:playedDate] forKey:@"playedDate"];
            }*/
            if ([fields containsObject: @"userGrouping"]) {
                NSString *userGrouping = [song valueForProperty: MPMediaItemPropertyUserGrouping];
                if (userGrouping == nil) {
                    userGrouping = @"";
                }
                [songDictionary setValue:[NSString stringWithString:userGrouping] forKey:@"userGrouping"];
            }
            if ([fields containsObject: @"bookmarkTime"]) {
                NSString *bookmarkTime = [song valueForProperty: MPMediaItemPropertyBookmarkTime];
                
                [songDictionary setValue:[NSNumber numberWithInt:bookmarkTime] forKey:@"bookmarkTime"];
            }
            
            // Aliases
            if ([fields containsObject: @"playbackDuration"]) {
                [songDictionary setValue:[NSNumber numberWithInt:duration] forKey:@"playbackDuration"];
            }
        }
        [mutableSongsToSerialize addObject:songDictionary];
    }
    
    successCallback(@[mutableSongsToSerialize]);
}

@end