//
//  TBHeaderCollectionReusableView.h
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TBHeaderCollectionReusableView;

@protocol TBHeaderCollectionReusableViewDelegate <NSObject>

- (void)clickEditBtnInHeader:(TBHeaderCollectionReusableView *)view isEdit:(BOOL)edit;

@end

@interface TBHeaderCollectionReusableView : UICollectionReusableView

/**  代理 */
@property (nonatomic, weak) id<TBHeaderCollectionReusableViewDelegate> delegate;

/**  标题 */
@property (nonatomic, copy) NSString *title;
/**  是否添加提示和编辑按钮 */
@property (nonatomic, assign, getter=isShowTipNEditBtn) BOOL showTipNEditBtn;

/**
 *  配置头视图设置
 *
 *  @param title      标题
 *  @param addTipNBtn 是否添加提示和编辑按钮
 */
- (void)configHeaderTitle:(NSString *)title isShowTipNEditBtn:(BOOL)showTipNEditBtn;

@end
