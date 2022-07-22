//
//  FlyContainerVC.h
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyContainerVC : UICollectionViewController

@property (nonatomic, copy) NSArray *channels;
@property (nonatomic, copy, readonly) NSArray *tableviews;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void (^ _Nullable changeEvent)(NSInteger index);

- (UITableView *)currentTableView;

@end

NS_ASSUME_NONNULL_END
