//
//  FlyChannelView.m
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import "FlyChannelView.h"
#import "Masonry.h"

@interface FlyChannelCellItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)configCell:(NSString *)title isSelected:(BOOL)isSelected;

@end

@implementation FlyChannelCellItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)configCell:(NSString *)title isSelected:(BOOL)isSelected {
    self.titleLabel.text = title;
    self.titleLabel.textColor = isSelected ? [UIColor redColor] : [UIColor darkGrayColor];
}

- (void)setupView {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

@end

@interface FlyChannelView ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation FlyChannelView

- (instancetype) initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        [self setupBaseView];
    }
    return self;
}

- (void)setChannels:(NSArray *)channels {
    _channels = channels;
    [self.collectionView reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if(index < 0 || selectedIndex >= self.channels.count || selectedIndex == _selectedIndex) return;
    
    _selectedIndex = selectedIndex;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
}

- (void)setupBaseView {
    
    [self addSubview:self.collectionView];
    
    CGFloat margin = 8;
    CGFloat padding = 15;
    CGFloat count = 4.5;
    CGFloat itemWidth = floor((CGRectGetWidth([UIScreen mainScreen].bounds) - (margin*2 + padding*(ceil(count) - 1)))/count);
    CGFloat itemHeight = itemWidth*36/31;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    self.flowLayout.minimumInteritemSpacing = padding;
    self.flowLayout.minimumLineSpacing = padding;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlyChannelCellItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FlyChannelCellItem class]) forIndexPath:indexPath];
    [cell configCell:self.channels[indexPath.row] isSelected:indexPath.row == _selectedIndex];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.row;
    _selectedIndex = index;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self.collectionView reloadData];
    if (self.changeEvent) {
        self.changeEvent(index);
    }
}

#pragma mark - Getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.decelerationRate = 0.4;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[FlyChannelCellItem class] forCellWithReuseIdentifier:NSStringFromClass([FlyChannelCellItem class])];
    }
    
    return _collectionView;
}

@end
