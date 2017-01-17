//
//  UIView+LJCapture.m
//  WKTest
//
//  Created by 刘杰 on 2017/1/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "UIView+LJCapture.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@implementation UIView (LJCapture)
static NSString *captureKey = @"CaptureKey";

- (BOOL)isCapturing
{
    id num = objc_getAssociatedObject(self, &captureKey);
    if (!num) {
        return NO;
    }
    return YES;
}

- (void)setIsCapturing:(BOOL)isCapturing
{
    NSNumber *num = [NSNumber numberWithBool:isCapturing];
    objc_setAssociatedObject(self, &captureKey, num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lj_ContainsWKWebView
{
    if ([self isKindOfClass:[WKWebView class]]) {
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[WKWebView class]])
        {
            return YES;
        }
    }
    return NO;
}

- (void)lj_CaptureWithHandler:(void(^)(UIImage *captureImage))completeHandler
{
    self.isCapturing = YES;
    CGRect viewBounds = self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(viewBounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextTranslateCTM(currentContext, -self.frame.origin.x, -self.frame.origin.y);
    if ([self lj_ContainsWKWebView]) {
        [self drawViewHierarchyInRect:viewBounds afterScreenUpdates:YES];
    } else
    {
        [self.layer renderInContext:currentContext];
    }
    
    UIImage *captureImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(currentContext);
    UIGraphicsEndImageContext();
    
    self.isCapturing = NO;
    completeHandler(captureImage);
    
}

@end
