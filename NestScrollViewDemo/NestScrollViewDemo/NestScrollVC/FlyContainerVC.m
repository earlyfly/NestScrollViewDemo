//
//  FlyContainerVC.m
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import "FlyContainerVC.h"
#import "Masonry.h"
#import "UIListVC.h"

@interface FlyContainerVC ()

@end

@implementation FlyContainerVC

static NSString * const reuseIdentifier = @"Cell";

- (instancetype) init {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

- (UITableView *)currentTableView {
    return self.tableviews[self.selectedIndex];
}

- (void)setChannels:(NSArray *)channels {
    _channels = channels;
    /*移除先前添加的视图和控制器*/
    for(UIViewController *vc in self.childViewControllers) {
        if(vc.viewIfLoaded) {
            [vc.viewIfLoaded performSelector:@selector(removeFromSuperview)];
        }
        [vc removeFromParentViewController];
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    /*添加新的视图和控制器*/
    for(NSString *title in channels) {
        UIListVC *vc = [[UIListVC alloc] init];
        vc.tableView.scrollEnabled = NO;
        vc.title = title;
        [temp addObject:vc.tableView];
        [self addChildViewController:vc];
    }
    _tableviews = temp.copy;
    
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if(index < 0 || selectedIndex >= self.childViewControllers.count || selectedIndex == _selectedIndex) return;
    
    _selectedIndex = selectedIndex;
    [self.collectionView setContentOffset:CGPointMake(selectedIndex * CGRectGetWidth(self.collectionView.frame), 0) animated:NO];
}

- (void)setNotScrollEnable {
    for(UIListVC *vc in self.childViewControllers) {
        vc.tableView.scrollEnabled = NO;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    UIViewController *vc = self.childViewControllers[indexPath.item];
    vc.view.hidden = NO;
    vc.view.frame = cell.bounds;
    [cell.contentView addSubview:vc.view];
    [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(cell.contentView);
    }];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return collectionView.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.childViewControllers.count) {
        UIViewController *vc = self.childViewControllers[indexPath.item];
        [vc viewWillAppear:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.childViewControllers.count) {
        UIViewController *vc = self.childViewControllers[indexPath.item];
        [vc viewWillDisappear:YES];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x + self.view.bounds.size.width/2) / self.view.bounds.size.width;
    
    if (index != _selectedIndex && _selectedIndex < self.channels.count) {
        
        //NSDictionary *channelInfo = self.channels[self.selectedIndex];
        //[TRSAnalytics pageEndWithDict:channelInfo pageName:@"二级栏目页"];
        
        _selectedIndex = index;
        //[TRSAnalytics pageBegin:@"二级栏目页"];
        
        if(_changeEvent) {
            _changeEvent(_selectedIndex);
        }
    }
}

@end
