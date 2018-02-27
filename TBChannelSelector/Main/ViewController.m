//
//  ViewController.m
//  TBChannelSelector
//
//  Created by tb on 2017/4/7.
//  Copyright © 2017年 tb. All rights reserved.
//

#import "ViewController.h"
#import "TBManageChannelViewController.h"
#import "TBChannel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)modalChannelSelectorVC:(UIButton *)sender {
    TBManageChannelViewController *manageVC = [[TBManageChannelViewController alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Channel" ofType:@"plist"];
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in dictArray) {
        TBChannel *channel = [TBChannel channelFromDictionary:dict];
        if (channel.channelType == 0) {
            [manageVC.myChannelArrayM addObject:channel];
        } else if (channel.channelType == 1) {
            [manageVC.subscribeArrayM addObject:channel];
        } else {
            [manageVC.cityArrayM addObject:channel];
        }
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:manageVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
