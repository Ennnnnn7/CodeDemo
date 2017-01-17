//
//  WKWebView+LJCapture.h
//  WKTest
//
//  Created by 刘杰 on 2017/1/16.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <WebKit/WebKit.h>


typedef void(^LJCaptureHandler)(UIImage *captureImage);

@interface WKWebView (LJCapture)

- (void)lj_contentCaptureWithHandle:(void(^)(UIImage *captureImage))completeHandler;




@end
