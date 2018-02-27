//
//  TBChannelCollectionViewCell.m
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//

#import "TBChannelCollectionViewCell.h"
#import "Masonry.h"

@interface TBChannelCollectionViewCell ()

/**  标题 */
@property (nonatomic, weak) UILabel *titleLbl;
/**  红点 */
@property (nonatomic, weak) UIView *redDot;
/**  删除按钮 */
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation TBChannelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubviews];
    }
    return self;
}

/**  配置子视图 */
- (void)configSubviews {
    UILabel *titleLbl = [[UILabel alloc] init];
    [self.contentView addSubview:titleLbl];
    self.titleLbl = titleLbl;
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

/**  懒加载 */
- (UIView *)redDot {
    if (!_redDot) {
        CGFloat redDotWidth = 5.f;
        UIView *redDot = [[UIView alloc] init];
        redDot.backgroundColor = [UIColor redColor];
        redDot.layer.cornerRadius = redDotWidth * 0.5;
        [self.contentView addSubview:redDot];
        _redDot = redDot;
        [_redDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(redDotWidth);
            make.centerX.equalTo(_titleLbl.mas_right);
            make.centerY.equalTo(_titleLbl.mas_top);
        }];
    }
    return _redDot;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"live_adClose"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_left);
            make.centerY.equalTo(self.mas_top);
        }];
    }
    return _deleteBtn;
}

#pragma mark - button event
- (void)deleteBtnDidClick:(UIButton *)btn {
    _deleteBtn.hidden = YES;
    if ([_delegate respondsToSelector:@selector(clickDeleteBtnInCell:)]) {
        [_delegate clickDeleteBtnInCell:self];
    }
}

#pragma mark - object method
- (void)configCellTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color {
    self.title = title;
    self.titleFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.titleColor = color ? color : [UIColor blackColor];
}

- (void)configCellTitle:(NSString *)title titleFont:(UIFont *)font titleColor:(UIColor *)color showRedDot:(BOOL)showRedDot showDeleteBtn:(BOOL)showDeleteBtn {
    self.title = title;
    self.titleFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    self.titleColor = color ? color : [UIColor blackColor];
    self.showRedDot = showRedDot ? YES : NO;
    self.showDeleteBtn = showDeleteBtn ? YES : NO;
}

- (void)configCellBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius {
    self.borderColor = borderColor ? borderColor : [UIColor clearColor];
    self.borderWidth = borderWidth;
    self.cornerRadius = cornerRadius;
}

#pragma mark - setter
/**  设置标题 */
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLbl.text = title;
    [_titleLbl sizeToFit];
}

/**  设置标题字体 */
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleLbl.font = titleFont;
    [_titleLbl sizeToFit];
}

/**  设置标题颜色 */
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    _titleLbl.textColor = titleColor;
}

/**  设置是否显示红点 */
- (void)setShowRedDot:(BOOL)showRedDot {
    _showRedDot = showRedDot;
    self.redDot.hidden = !showRedDot;
}

/**  设置是否显示删除按钮 */
- (void)setShowDeleteBtn:(BOOL)showDeleteBtn {
    _showDeleteBtn = showDeleteBtn;
    _deleteBtn.hidden = !showDeleteBtn;
}

/**  设置边框颜色 */
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.contentView.layer.borderColor = borderColor.CGColor;
}

/**  设置边框宽度 */
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.contentView.layer.borderWidth = borderWidth;
}

/**  设置边框半径 */
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
    CGFloat offsetXY = cornerRadius - cosl(M_PI_4) * cornerRadius;
    [self.deleteBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_equalTo(offsetXY);
        make.centerY.equalTo(self.mas_top).mas_equalTo(offsetXY);
    }];
}

@end
