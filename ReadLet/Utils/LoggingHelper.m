//
//  LoggingHelper.m
//  ReadLet
//
//  Created by Nagendra on 5/28/19.
//  Copyright © 2019 Rely Labs. All rights reserved.
//

#import "LoggingHelper.h"
#import "Amplitude.h"
#import "Constants.h"

@implementation LoggingHelper

+ (void) initLogsAnalyticsProvider {
    [[Amplitude instance] initializeApiKey:@"72ad420e99756fa9c301bd7c558531ae"];
}

+ (void) reportLogsDataToAnalytics:(NSString *)event_name {
    [[Amplitude instance] logEvent:event_name];
    return;
}

@end
