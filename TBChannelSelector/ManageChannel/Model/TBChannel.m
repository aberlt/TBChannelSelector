//
//  TBChannel.m
//  TBChannelSelector
//
//  Created by chenfei on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TBChannel.h"

@implementation TBChannel

+ (instancetype)channelFromDictionary:(NSDictionary *)dict {
    TBChannel *channel = [[TBChannel alloc]init];
    channel.channelId = [[dict objectForKey:@"channelId"] intValue];
    channel.channelName = [[dict objectForKey:@"channelName"] copy];
    channel.channelType = [[dict objectForKey:@"channelType"] intValue];
    channel.isNew = [[dict objectForKey:@"isNew"] boolValue];
    return channel;
}

@end
