//
//  LJImageView.h
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/10.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJImageView : UIImageView
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@end
