//
//  TBHeaderCollectionReusableView.m
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//

#import "TBHeaderCollectionReusableView.h"
#import "Masonry.h"

#define TBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TBCOLOR_ONE(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define TBCOLOR_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]

const static CGFloat kRedLineWidth = 3;
const static CGFloat kSubViewHeight = 15;
const static CGFloat kLeftRightMargin = 15;

@interface TBHeaderCollectionReusableView ()

/**  标题 */
@property (nonatomic, weak) UILabel *titleLbl;
/**  工具视图 */
@property (nonatomic, weak) UIView *toolView;
/**  拖动排序提示 */
@property (nonatomic, weak) UILabel *operationTipsLbl;

@end

@implementation TBHeaderCollectionReusableView {
    // 是否编辑
    BOOL _isEdit;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

/**  配置子视图 */
- (void)setupSubviews {
    UIView *redLine = [[UIView alloc] init];
    redLine.backgroundColor = [UIColor redColor];
    CGSize redLineSize = CGSizeMake(kRedLineWidth, kSubViewHeight);
    redLine.layer.cornerRadius = kRedLineWidth * 0.5f;
    [self addSubview:redLine];
    [redLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(redLineSize);
        make.left.mas_offset(kLeftRightMargin);
        make.bottom.equalTo(self);
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:16];
    titleLbl.textColor = TBCOLOR(51.f, 51.f, 51.f);
    [self addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(redLine.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(redLine.mas_centerY);
    }];
    self.titleLbl = titleLbl;

    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = [UIColor clearColor];
    [self addSubview:toolView];
    self.toolView = toolView;
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(redLine.mas_height);
        make.centerY.mas_equalTo(redLine.mas_centerY);
        make.left.equalTo(titleLbl.mas_right);
        make.right.equalTo(self);
    }];
    
    UILabel *operationTipsLbl = [[UILabel alloc] init];
    operationTipsLbl.text = @"长按拖动排序";
    operationTipsLbl.font = [UIFont systemFontOfSize:13];
    [operationTipsLbl sizeToFit];
    operationTipsLbl.textColor = TBCOLOR(153.f, 153.f, 153.f);
    operationTipsLbl.hidden = !_isEdit;
    [_toolView addSubview:operationTipsLbl];
    [operationTipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.centerY.mas_equalTo(_toolView.mas_centerY);
    }];
    self.operationTipsLbl = operationTipsLbl;
    
    // 编辑按钮
    CGFloat editBtnW = 50.f;
    CGFloat editBtnH = 23.f;
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    UIColor *fontColor = TBCOLOR(245.f, 77.f, 69.f);
    [editBtn setTitleColor:fontColor forState:UIControlStateNormal];
    [editBtn setTitleColor:fontColor forState:UIControlStateSelected];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    editBtn.backgroundColor = [UIColor whiteColor];
    editBtn.layer.borderColor = TBCOLOR(246.f, 78.f, 69.f).CGColor;
    editBtn.layer.cornerRadius = editBtnH * 0.5f;
    editBtn.layer.borderWidth = 1.f;
    
    [editBtn addTarget:self action:@selector(changeEditState:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(editBtnW, editBtnH));
        make.centerY.mas_equalTo(_toolView.mas_centerY);
        make.right.mas_offset(-kLeftRightMargin);
    }];
}

#pragma mark - setter
/**  设置标题 */
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
    [_titleLbl sizeToFit];
}

/**  设置是否显示提示和编辑按钮 */
- (void)setShowTipNEditBtn:(BOOL)showTipNEditBtn {
    _showTipNEditBtn = showTipNEditBtn;
    _toolView.hidden = !showTipNEditBtn;
}

#pragma mark - object method
- (void)configHeaderTitle:(NSString *)title isShowTipNEditBtn:(BOOL)showTipNEditBtn {
    self.title = title;
    self.showTipNEditBtn = showTipNEditBtn;
}

/**  切换状态（编辑／完成） */
- (void)changeEditState:(UIButton *)btn {
    _isEdit = !_isEdit;
    btn.selected = _isEdit;
    _operationTipsLbl.hidden = !_isEdit;
    if ([_delegate respondsToSelector:@selector(clickEditBtnInHeader:isEdit:)]) {
        [_delegate clickEditBtnInHeader:self isEdit:_isEdit];
    }
}

@end
