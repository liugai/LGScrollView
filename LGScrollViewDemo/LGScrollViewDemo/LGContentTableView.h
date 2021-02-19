//
//  LGContentTableView.h
//  TestScrollView
//
//  Created by 刘盖 on 2021/2/19.
//  Copyright © 2021 刘盖. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGContentTableView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic) BOOL canScroll;
@property (nonatomic, copy) void (^superCanScrollBlock)(BOOL superCanScroll);

- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
