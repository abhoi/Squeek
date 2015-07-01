//
//  TweetsModal.m
//  TwitterReplica
//
//  Created by Vaibhav Kumar on 6/29/15.
//  Copyright (c) 2015 OpenSource. All rights reserved.
//

#import "TweetsModal.h"


@implementation TweetsModal


- (id) initWithData:(NSDictionary *)receivedDict {
    self.createdAt = [receivedDict objectForKey:@"created_at"];
    self.text = [receivedDict objectForKey:@"text"];
    self.tweetID = [receivedDict objectForKey:@"id_str"];
    self.favoriteCount = [receivedDict objectForKey:@"favorite_count"];
    self.retweetCount = [receivedDict objectForKey:@"retweet_count"];
    self.verified = [[receivedDict objectForKey:@"user"] objectForKey:@"verified"];
//    self.favorited = [receivedDict objectForKey:@"favorited"];
//    self.display_url = [receivedDict objectForKey:@"display_url"];
    if ([[receivedDict objectForKey:@"entities"] objectForKey:@"media"]) {
        self.mediaUrl = [[NSURL alloc] initWithString:[[[[receivedDict objectForKey:@"entities"] objectForKey:@"media"] objectAtIndex:0] objectForKey:@"media_url_https"]];
    }
    self.profileImg = [[NSURL alloc] initWithString:[[receivedDict objectForKey:@"user"] objectForKey:@"profile_image_url_https"]];
    self.name = [[receivedDict objectForKey:@"user"] objectForKey:@"name"];
    self.screenName = [[receivedDict objectForKey:@"user"] objectForKey:@"screen_name"];
    
    /*if ([[receivedDict objectForKey:@"entities"] objectForKey:@"urls"]) {
     self.display_url = [[[[receivedDict objectForKey:@"entities"] objectForKey:@"urls"] objectAtIndex:0] objectForKey:@"display_url"];
     }*/
    
    self.combinedName = [NSString stringWithFormat:@"%@ @%@", self.name, self.screenName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *created = [dateFormatter dateFromString:_createdAt];
    NSDate *current = [[NSDate  alloc] init];
    
    NSTimeInterval distanceBetweenDates = [current timeIntervalSinceDate:created];
    
    NSTimeInterval theTimeInterval = distanceBetweenDates;
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
    
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;
    
    NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSString *returnDate;
    if ([conversionInfo month] > 0) {
        returnDate = [NSString stringWithFormat:@"%ldmth",(long)[conversionInfo month]];
    }else if ([conversionInfo day] > 0){
        returnDate = [NSString stringWithFormat:@"%ldd",(long)[conversionInfo day]];
    }else if ([conversionInfo hour]>0){
        returnDate = [NSString stringWithFormat:@"%ldh",(long)[conversionInfo hour]];
    }else if ([conversionInfo minute]>0){
        returnDate = [NSString stringWithFormat:@"%ldm",(long)[conversionInfo minute]];
    }else{
        returnDate = [NSString stringWithFormat:@"%lds",(long)[conversionInfo second]];
    }
    self.timeElapsed = returnDate;
    return self;
}

- (void) printData {
    NSLog(@"Created At: %@", self.createdAt);
    //NSLog(@"Text: %@", self.text);
    //NSLog(@"Tweet ID: %@", self.tweetID);
    /*NSLog(@"Favorite Count: %@", self.favorite_count);
     NSLog(@"Retweet Count: %@", self.retweet_count);
     NSLog(@"Favorited?: %@", self.favorited);
     NSLog(@"Media URL: %@", self.media_url_https);
     NSLog(@"Display URL: %@\n", self.display_url);*/
}

@end
