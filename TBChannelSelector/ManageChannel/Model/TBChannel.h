//
//  TBChannel.h
//  TBChannelSelector
//
//  Created by chenfei on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBChannel : NSObject

@property(nonatomic, assign) int channelId;
@property(nonatomic, assign) int channelType;
@property(nonatomic, copy) NSString *channelName;
@property (nonatomic, assign) BOOL isNew;

+ (instancetype)channelFromDictionary:(NSDictionary *)dict;

@end
