//
//  TBManageChannelViewController.m
//  TBChannelSelector
//
//  Created by tb on 2017/4/6.
//  Copyright © 2017年 tb. All rights reserved.
//

#import "TBManageChannelViewController.h"
#import "TBHeaderCollectionReusableView.h"
#import "TBChannelCollectionViewCell.h"
#import "TBChannel.h"

/**
 *  RGB颜色
 */
#define TBCOLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define TBCOLOR_ONE(rgb) [UIColor colorWithRed:(rgb)/255.0 green:(rgb)/255.0 blue:(rgb)/255.0 alpha:1.0]
#define TBCOLOR_RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a/1.0]
#define Angle2Rad(angle) ((angle) / 180.0 * M_PI)

/**  间距 */
#define KMARGIN_10 10
#define KMARGIN_15 15
#define KMARGIN_25 25

/**  标签尺寸 */
#define ViewWidth ((CGRectGetWidth(self.view.bounds) - 60) * 0.25)
#define ViewHeight ViewWidth * 35 / 78

const static NSInteger kSectionCount = 3;
const static CGFloat kFirstHeaderHeight = 40.f;
const static CGFloat kOtherHeaderHeight = 15.f;

@interface TBManageChannelViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, TBChannelCollectionViewCellDelegate, TBHeaderCollectionReusableViewDelegate, UIGestureRecognizerDelegate>

/**  导航栏 */
@property (nonatomic, weak) UIView *navgationV;
/**  频道展示视图 */
@property (nonatomic, weak) UICollectionView *channelCollectionV;
/**  拖动排序提示 */
@property (nonatomic, weak) UILabel *operationTipsLbl;
/**  由选中的 item 生成的视图 */
@property (nonatomic, weak) UIImageView *screenhotImgV;
/**  选中的 cell */
@property (nonatomic, weak) TBChannelCollectionViewCell *selectedCell;

@end

@implementation TBManageChannelViewController {
    NSMutableArray<NSMutableArray *> *_sectionArrayM;
    // 是否编辑模式
    BOOL _isEdit;
    // 被选中的频道索引
    NSIndexPath *_selectedIndexPath;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.myChannelArrayM = [NSMutableArray array];
        self.subscribeArrayM = [NSMutableArray array];
        self.cityArrayM = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavgationV];
    [self configChannelModel];
    [self configChannelCollectionV];
}

- (void)configNavgationV {
    self.title = @"频道管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"close_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnDidClick:)];
}

- (void)closeBtnDidClick:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**  创建频道模型数组 */
- (void)configChannelModel {
    _sectionArrayM = [NSMutableArray array];
    [_sectionArrayM addObjectsFromArray:@[_myChannelArrayM, _subscribeArrayM, _cityArrayM]];
}

/**  配置频道显示视图 */
static NSString *channelID = @"channel";
static NSString *headerID = @"header";
- (void)configChannelCollectionV {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ViewWidth, ViewHeight);
    layout.sectionInset = UIEdgeInsetsMake(KMARGIN_15, KMARGIN_15, KMARGIN_25, KMARGIN_15);
    
    CGFloat y = CGRectGetMaxY(_navgationV.frame);
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds) - y;
    
    UICollectionView *channelCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, width, height) collectionViewLayout:layout];
    channelCollectionV.backgroundColor = TBCOLOR(244.f, 245.f, 246.f);
    channelCollectionV.dataSource = self;
    channelCollectionV.delegate = self;
    
    [channelCollectionV registerClass:[TBHeaderCollectionReusableView class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:headerID];
    [channelCollectionV registerClass:[TBChannelCollectionViewCell class]
           forCellWithReuseIdentifier:channelID];
    
    [self.view addSubview:channelCollectionV];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    panGes.delegate = self;
    [channelCollectionV addGestureRecognizer:panGes];

    self.channelCollectionV = channelCollectionV;
}

/**  长按手势监听方法 */
- (void)panGestureHandler:(UIPanGestureRecognizer *)panGes {
    if (!_isEdit) return;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        TBChannelCollectionViewCell *originCell = (TBChannelCollectionViewCell *)[_channelCollectionV cellForItemAtIndexPath:_selectedIndexPath];
        
        TBChannelCollectionViewCell *cell = [[TBChannelCollectionViewCell alloc] initWithFrame:originCell.frame];
        cell.backgroundColor = originCell.backgroundColor;
        [cell configCellBorderColor:originCell.borderColor
                        borderWidth:originCell.borderWidth
                       cornerRadius:originCell.cornerRadius];
        [cell configCellTitle:originCell.title
                    titleFont:originCell.titleFont
                   titleColor:originCell.titleColor
                   showRedDot:originCell.showRedDot
                showDeleteBtn:originCell.showDeleteBtn];
        [_channelCollectionV addSubview:cell];
        
        self.selectedCell = cell;
        [self startShake:_selectedCell];
        
        originCell.hidden = YES;
    } else if (panGes.state == UIGestureRecognizerStateChanged) {
        [self moveChannel:panGes];
    } else if (panGes.state == UIGestureRecognizerStateEnded) {
        UICollectionViewCell *cell = [_channelCollectionV cellForItemAtIndexPath:_selectedIndexPath];
        cell.hidden = NO;
        
        [self stopShake:_selectedCell];
        [_selectedCell removeFromSuperview];
        _selectedIndexPath = nil;
    }
}

/**
 *  处理移动频道的相关操作
 *
 *  @param panGes 长按手势
 */
- (void)moveChannel:(UIPanGestureRecognizer *)panGes {
    CGPoint location = [panGes translationInView:panGes.view];
    
    _selectedCell.transform = CGAffineTransformTranslate(_selectedCell.transform, location.x, location.y);
    [panGes setTranslation:CGPointZero inView:panGes.view];
    
    NSIndexPath *indexPath = [_channelCollectionV indexPathForItemAtPoint:[panGes locationInView:panGes.view]];
    if (indexPath && indexPath.section == _selectedIndexPath.section && indexPath.row != 0 && indexPath.row != 1) {
        NSMutableArray *tmpChannelArrayM = [_myChannelArrayM mutableCopy];
        
        if (indexPath.row > _selectedIndexPath.row) {
            for (NSUInteger i = _selectedIndexPath.row; i < indexPath.row; i++) {
                [tmpChannelArrayM exchangeObjectAtIndex:i withObjectAtIndex:(i + 1)];
            }
        }
        if (indexPath.row < _selectedIndexPath.row) {
            for (NSUInteger i = _selectedIndexPath.row; i > indexPath.row; i--) {
                [tmpChannelArrayM exchangeObjectAtIndex:i withObjectAtIndex:(i - 1)];
            }
        }
        
        self.myChannelArrayM = tmpChannelArrayM;
        [_sectionArrayM replaceObjectAtIndex:0 withObject:_myChannelArrayM];
        
        [_channelCollectionV moveItemAtIndexPath:_selectedIndexPath toIndexPath:indexPath];
        
        TBChannelCollectionViewCell *cell = (TBChannelCollectionViewCell *)[_channelCollectionV cellForItemAtIndexPath:indexPath];
        cell.hidden = YES;
        
        _selectedIndexPath = indexPath;
    }
}

#pragma mark - gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) return YES;
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    NSIndexPath *indexPath = [_channelCollectionV indexPathForItemAtPoint:location];
    if (!(_isEdit && indexPath)) return NO;
    if (indexPath.section == 0 && indexPath.row != 0 && indexPath.row != 1) {
        _selectedIndexPath = indexPath;
        return YES;
    }
    return NO;
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _myChannelArrayM.count;
    } else if (section == 1) {
        return _subscribeArrayM.count;
    } else {
        return _cityArrayM.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TBChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:channelID forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.backgroundColor = [UIColor whiteColor];
    [cell configCellBorderColor:TBCOLOR(238.f, 238.f, 238.f)
                    borderWidth:1.f
                   cornerRadius:ViewHeight * 0.5f];

    NSArray<TBChannel *> *channelArray = _sectionArrayM[indexPath.section];
    TBChannel *column = channelArray[indexPath.row];
    if (column.channelType == 0) {
        [cell configCellTitle:column.channelName
                    titleFont:nil
                   titleColor:TBCOLOR(187.f, 187.f, 187.f)
                   showRedDot:column.isNew
                showDeleteBtn:NO];
    } else {
        [cell configCellTitle:column.channelName
                    titleFont:nil
                   titleColor:TBCOLOR(102.f, 102.f, 102.f)
                   showRedDot:column.isNew
                showDeleteBtn:(indexPath.section ? NO : _isEdit)];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TBHeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                              withReuseIdentifier:headerID
                                                                                     forIndexPath:indexPath];
    view.backgroundColor = [UIColor clearColor];
    view.delegate = self;
    
    if (indexPath.section == 0) {
        [view configHeaderTitle:@"我的频道"
              isShowTipNEditBtn:YES];
    } else if (indexPath.section == 1) {
        [view configHeaderTitle:@"精选频道"
              isShowTipNEditBtn:NO];
    } else {
        [view configHeaderTitle:@"地方频道"
              isShowTipNEditBtn:NO];
    }
    
    return view;
}

#pragma mark - collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!(indexPath.section && !_isEdit)) return;
    [_myChannelArrayM addObject:_sectionArrayM[indexPath.section][indexPath.row]];
    [_sectionArrayM[indexPath.section] removeObjectAtIndex:indexPath.row];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:(_myChannelArrayM.count - 1)
                                                   inSection:0];
    [collectionView moveItemAtIndexPath:indexPath
                            toIndexPath:toIndexPath];
}

#pragma mark - collection view delegate flow layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGFloat height = section ? kOtherHeaderHeight : kFirstHeaderHeight;
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), height);
}

#pragma mark - channel cell delegate
- (void)clickDeleteBtnInCell:(TBChannelCollectionViewCell *)cell {
    NSIndexPath *indexPath = [_channelCollectionV indexPathForCell:cell];
    TBChannel *channel = _myChannelArrayM[indexPath.row];
    [_sectionArrayM[channel.channelType] addObject:channel];
    [_myChannelArrayM removeObject:channel];
    NSIndexPath *toIndexPath = [NSIndexPath indexPathForItem:(_sectionArrayM[channel.channelType].count - 1)
                                                   inSection:channel.channelType];
    [_channelCollectionV moveItemAtIndexPath:indexPath
                                 toIndexPath:toIndexPath];
}

#pragma mark - header collection reusable view delegate
- (void)clickEditBtnInHeader:(TBHeaderCollectionReusableView *)view isEdit:(BOOL)edit {
    _isEdit = edit;
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 0; i < _myChannelArrayM.count; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:i
                                                  inSection:0]];
    }
    [_channelCollectionV reloadItemsAtIndexPaths:indexPaths];
}

#pragma mark - animation
- (void)startShake:(UIView *)view {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    
    // 动画属性
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(Angle2Rad(-5)), @(Angle2Rad(5)), @(Angle2Rad(-5))];
    
    // 动画重复次数
    animation.repeatCount = MAXFLOAT;
    
    [view.layer addAnimation:animation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView *)view {
    [view.layer removeAnimationForKey:@"shakeAnimation"];
}
@end
