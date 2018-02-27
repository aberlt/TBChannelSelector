//
//  TBChannelCollectionViewCell.h
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//  频道单元格

#import <UIKit/UIKit.h>
@class TBChannelCollectionViewCell;

@protocol TBChannelCollectionViewCellDelegate <NSObject>

/**  点击了删除按钮 */
- (void)clickDeleteBtnInCell:(TBChannelCollectionViewCell *)cell;

@end

@interface TBChannelCollectionViewCell : UICollectionViewCell

/**  代理 */
@property (nonatomic, weak) id<TBChannelCollectionViewCellDelegate> delegate;

#pragma mark - title
/**  标题 */
@property (nonatomic, copy) NSString *title;
/**  字体 */
@property (nonatomic, strong) UIFont *titleFont;
/**  字体颜色 */
@property (nonatomic, strong) UIColor *titleColor;

/**
 *  配置 cell 的标题、字体和颜色
 *
 *  @param title 标题
 *  @param font  字体（默认为系统字体）
 *  @param color 颜色（默认为黑色）
 */
- (void)configCellTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color;

#pragma mark - view
/**  是否显示红点 */
@property (nonatomic, assign, getter=isShowRedDot) BOOL showRedDot;
/**  是否显示删除按钮 */
@property (nonatomic, assign, getter=isShowDeleteBtn) BOOL showDeleteBtn;
/**  layer 颜色 */
@property (nonatomic, strong) UIColor *borderColor;
/**  layer 宽度 */
@property (nonatomic, assign) CGFloat borderWidth;
/**  layer 半径 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 *  配置 cell 的边框（图层）
 *
 *  @param title        标题
 *  @param borderColor  边框颜色（默认为透明）
 *  @param borderWidth  边框宽度（默认为 0 ）
 *  @param cornerRadius 边框半径（默认为 0 ）
 */
- (void)configCellBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

/**
 *  配置 cell 的标题、字体和颜色，以及是否显示红点或删除按钮
 *
 *  @param title         标题
 *  @param font          字体（默认为系统字体）
 *  @param color         颜色（默认为黑色）
 *  @param showRedDot    是否显示红点（默认为隐藏）
 *  @param showDeleteBtn 是否显示删除按钮（默认为隐藏）
 */
- (void)configCellTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color showRedDot:(BOOL)showRedDot showDeleteBtn:(BOOL)showDeleteBtn;

@end
