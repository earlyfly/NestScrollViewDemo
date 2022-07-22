//
//  UIListVC.m
//  NestScrollViewDemo
//
//  Created by trs on 2022/7/21.
//

#import "UIListVC.h"
#import "MJRefresh.h"

@interface UIListVC () {
    NSInteger _rows;
}

@end

@implementation UIListVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %ld", self.title, indexPath.row];
    return cell;
}


@end
