//
//  WKWebView+LJCapture.m
//  WKTest
//
//  Created by 刘杰 on 2017/1/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "WKWebView+LJCapture.h"
#import "UIView+LJCapture.h"
@implementation WKWebView (LJCapture)


- (void)lj_contentCaptureWithHandle:(void(^)(UIImage *captureImage))completeHandler
{
    self.isCapturing = YES;
    
    CGPoint offset = self.scrollView.contentOffset;
    
    // 添加界面截屏遮罩
    UIView *snapshotView = [self snapshotViewAfterScreenUpdates:YES];
    snapshotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapshotView.frame.size.width, snapshotView.frame.size.height);
    [self.superview addSubview:snapshotView];
    
    if (self.frame.size.height < self.scrollView.contentSize.height) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentSize.height - self.frame.size.height);
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 重置偏移量
        self.scrollView.contentOffset = CGPointZero;
        [self lj_contentCaptureWithoutOffsetWithHandle:^(UIImage *captureImage) {
            self.scrollView.contentOffset = offset;
            [snapshotView removeFromSuperview];
            self.isCapturing = NO;
            completeHandler(captureImage);
        }];
        
    });
    

}

- (void)lj_contentCaptureWithoutOffsetWithHandle:(void(^)(UIImage *captureImage))completeHandler
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
    CGRect bakFrame = self.frame;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex = [[self.superview subviews] indexOfObject:self];
    
    [self removeFromSuperview];
    [containerView addSubview:self];
    
    CGSize totalSize = self.scrollView.contentSize;
    
    CGFloat page = totalSize.height / containerView.bounds.size.height;
    
    self.frame = CGRectMake(0, 0, containerView.bounds.size.width, self.scrollView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(totalSize, NO, [UIScreen mainScreen].scale);
    
    
    
    
    [self lj_contentPageDrawWithView:containerView index:0 maxIndex:(int)page drawCallback:^{
        UIImage *captureImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self removeFromSuperview];
        [bakSuperView insertSubview:self atIndex:bakIndex];
        self.frame = bakFrame;
        [containerView removeFromSuperview];
        completeHandler(captureImage);
    }];
    
    

}


- (void)lj_contentPageDrawWithView:(UIView *)targetView index:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)())drawCallBack
{
    
    for (int tempIndex = index; tempIndex <= maxIndex; tempIndex++) {
        CGRect splitFrame = CGRectMake(0, tempIndex * targetView.frame.size.height, targetView.bounds.size.width, targetView.frame.size.height);
        CGRect myFrame = self.frame;
        myFrame.origin.y = (-tempIndex) * targetView.frame.size.height;
        self.frame = myFrame;
        [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [targetView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
//            
//            
//        });
    }
    
   
    
    drawCallBack();
    
    
    
    
}







@end
