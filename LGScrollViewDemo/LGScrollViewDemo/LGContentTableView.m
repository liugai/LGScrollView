//
//  LGContentTableView.m
//  TestScrollView
//
//  Created by 刘盖 on 2021/2/19.
//  Copyright © 2021 刘盖. All rights reserved.
//

#import "LGContentTableView.h"
#import <Masonry.h>

@interface LGContentTableView ()

@property (nonatomic,copy) NSString *title;



@end

@implementation LGContentTableView

- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        _title = title;
        _canScroll = NO;
        [self initUI];
    }
    return self;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    [self setupCellContentWithCell:cell tableView:tableView indexPath:indexPath];
    
    return cell;
}

- (void)setupCellContentWithCell:(UITableViewCell *)cell tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = [NSString stringWithFormat:@"标题：%@,row=%ld",self.title,indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_canScroll) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    else{
        if (scrollView.contentOffset.y<=0) {
            scrollView.contentOffset = CGPointMake(0, 0);
            _canScroll = NO;
            if (self.superCanScrollBlock) {
                self.superCanScrollBlock(YES);
            }
        }
        
    }
}

#pragma mark -
- (void)initUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
