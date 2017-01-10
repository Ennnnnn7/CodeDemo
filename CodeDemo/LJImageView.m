//
//  LJImageView.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/10.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "LJImageView.h"

@implementation LJImageView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _singleTap = [[UITapGestureRecognizer alloc] init];
        _singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:_singleTap];
        
        _doubleTap = [[UITapGestureRecognizer alloc] init];
        _doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:_doubleTap];
        
        [_singleTap requireGestureRecognizerToFail:_doubleTap];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
