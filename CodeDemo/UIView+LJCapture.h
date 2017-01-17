//
//  UIView+LJCapture.h
//  WKTest
//
//  Created by 刘杰 on 2017/1/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LJCapture)
@property (nonatomic, assign) BOOL isCapturing;
- (void)lj_CaptureWithHandler:(void(^)(UIImage *captureImage))completeHandler;
@end
