//
//  LGMainScrollView.m
//  TestScrollView
//
//  Created by 刘盖 on 2021/2/19.
//  Copyright © 2021 刘盖. All rights reserved.
//

#import "LGMainScrollView.h"

@implementation LGMainScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
