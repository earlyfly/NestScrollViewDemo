//
//  NestScrollVC.m
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import "NestScrollVC.h"
#import "FlyContainerVC.h"
#import "FlyChannelView.h"
#import "Masonry.h"

@interface NestScrollVC ()

@property (nonatomic, strong) FlyContainerVC *containerVC;
@property (nonatomic, strong) FlyChannelView *channelView;

@end

@implementation NestScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

- (UITableView *)currentTableView {
    return [self.containerVC currentTableView];
}

- (NSArray *)allTbaleViews {
    return self.containerVC.tableviews;
}

- (void)setupView {
    NSArray *channels = @[@"推荐", @"热搜", @"话题", @"专题", @"榜单", @"视频"];
    
    self.channelView.backgroundColor = [UIColor cyanColor];
    self.channelView.channels = channels;
    [self.view addSubview:self.channelView];
    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(ChannelHeight);
    }];
    
    self.containerVC.channels = channels;
    [self.view addSubview:self.containerVC.view];
    [self.containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setter & Getter
- (FlyContainerVC *)containerVC {
    if (!_containerVC) {
        _containerVC = [[FlyContainerVC alloc] init];
        __weak typeof(self) weakSelf = self;
        _containerVC.changeEvent = ^(NSInteger index) {
            weakSelf.channelView.selectedIndex = index;
        };
    }
    return _containerVC;
}

- (FlyChannelView *)channelView {
    if (!_channelView) {
        _channelView = [[FlyChannelView alloc] init];
        __weak typeof(self) weakSelf = self;
        _channelView.changeEvent = ^(NSInteger index) {
            weakSelf.containerVC.selectedIndex = index;
        };
    }
    return _channelView;
}

@end
