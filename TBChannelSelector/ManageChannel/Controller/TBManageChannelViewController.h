//
//  TBManageChannelViewController.h
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBChannel;

@interface TBManageChannelViewController : UIViewController

/**  我的频道数组 */
@property (nonatomic, strong) NSMutableArray<TBChannel *> *myChannelArrayM;
/**  订阅频道数组 */
@property (nonatomic, strong) NSMutableArray<TBChannel *> *subscribeArrayM;
/**  城市频道数组 */
@property (nonatomic, strong) NSMutableArray<TBChannel *> *cityArrayM;

/**  选中的栏目 */
@property (nonatomic, strong) TBChannel *selectedChannel;

@end

