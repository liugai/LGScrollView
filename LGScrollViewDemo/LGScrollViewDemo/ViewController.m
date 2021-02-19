//
//  ViewController.m
//  TestScrollView
//
//  Created by 刘盖 on 2020/9/1.
//  Copyright © 2020 刘盖. All rights reserved.
//

#import "ViewController.h"
#import "LGMainScrollView.h"
#import "LGContentTableView.h"
#import <Masonry.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kHeaderHeight 200
#define kSegmentHeight 50

#define kMainMaxOffsetY kHeaderHeight-kStatusBarHeight

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) LGMainScrollView *mainScrollView;
@property (nonatomic,strong) UIScrollView *containerScrollView;

@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *segmentView;
@property (nonatomic,strong) UISegmentedControl *segmentControl;

@property (nonatomic,strong) NSArray *segmentTitles;
@property (nonatomic,strong) NSArray *tableViews;

@property (nonatomic) BOOL mainCanScroll;

@property (nonatomic,strong) LGContentTableView *currentTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainCanScroll = YES;
    [self initUI];
    // Do any additional setup after loading the view.
}



- (void)initUI{
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.mainScrollView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.width.offset(kScreenWidth);
        make.height.offset(kHeaderHeight);
    }];
    
    [self.mainScrollView addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kScreenWidth);
        make.top.equalTo(self.headerView.mas_bottom);
        make.height.offset(kSegmentHeight);
    }];
    
    CGFloat contentHeight = kScreenHeight-kSegmentHeight-kStatusBarHeight;
    [self.mainScrollView addSubview:self.containerScrollView];
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(kScreenWidth);
        make.top.equalTo(self.segmentView.mas_bottom);
        make.height.offset(contentHeight);
    }];
    
    UIView *lastView = nil;
    for (UIView *subView in self.tableViews) {
        [self.containerScrollView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.width.offset(kScreenWidth);
            make.height.offset(contentHeight);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }
            else{
                make.left.offset(0);
            }
        }];
        lastView = subView;
    }
    self.containerScrollView.contentSize = CGSizeMake(kScreenWidth*self.tableViews.count, contentHeight);
    self.mainScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight+kHeaderHeight-kStatusBarHeight);
}

#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        self.headerView.hidden = (scrollView.contentOffset.y>=kMainMaxOffsetY);
        if (!_mainCanScroll) {
            scrollView.contentOffset = CGPointMake(0, kMainMaxOffsetY);
            self.currentTableView.canScroll = YES;
        } else {
            if (scrollView.contentOffset.y >= kMainMaxOffsetY) {
                scrollView.contentOffset = CGPointMake(0, kMainMaxOffsetY);
                self.mainCanScroll = NO;
                self.currentTableView.canScroll = YES;
            }
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self handleContentHorScroll:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self handleContentHorScroll:scrollView];
}

- (void)handleContentHorScroll:(UIScrollView *)scrollView{
    if (scrollView == self.containerScrollView) {
        NSInteger page = self.containerScrollView.contentOffset.x/kScreenWidth;
        self.segmentControl.selectedSegmentIndex = page;
    }
}

- (void)segmentValueChanged:(UISegmentedControl *)segment{
    self.currentTableView = self.tableViews[segment.selectedSegmentIndex];
    [self.containerScrollView setContentOffset:CGPointMake(kScreenWidth*segment.selectedSegmentIndex, 0) animated:YES];
}


#pragma mark -
- (LGMainScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [LGMainScrollView new];
        _mainScrollView.delegate = self;
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _mainScrollView;
}

- (UIScrollView *)containerScrollView{
    if (!_containerScrollView) {
        _containerScrollView = [[UIScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.pagingEnabled = YES;
    }
    return _containerScrollView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor cyanColor];
    }
    return _headerView;
}

- (NSArray *)segmentTitles{
    if (!_segmentTitles) {
        _segmentTitles = @[@"推荐",@"兴趣",@"爱好"];
    }
    return _segmentTitles;
}

- (UIView *)segmentView{
    if (!_segmentView) {
        _segmentView = [[UIView alloc] init];
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:self.segmentTitles];
        [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
        _segmentControl = segment;
        segment.selectedSegmentIndex = 0;
        [_segmentView addSubview:segment];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_segmentView);
            make.centerY.equalTo(_segmentView);
        }];
    }
    return _segmentView;
}

- (NSArray *)tableViews{
    if (!_tableViews) {
        __weak typeof(self) weakSelf = self;
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *title in self.segmentTitles) {
            LGContentTableView *tableView = [[LGContentTableView alloc] initWithTitle:title];
            tableView.superCanScrollBlock = ^(BOOL superCanScroll) {
                weakSelf.mainCanScroll = superCanScroll;
            };
            [array addObject:tableView];
        }
        _tableViews = array;
        _currentTableView = array.firstObject;
    }
    return _tableViews;
}

@end
