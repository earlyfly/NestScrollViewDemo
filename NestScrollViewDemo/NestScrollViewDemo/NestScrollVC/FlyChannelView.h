//
//  FlyChannelView.h
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlyChannelView : UIView

@property (nonatomic, copy) NSArray *channels;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (copy, nonatomic) void (^ _Nullable changeEvent)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
