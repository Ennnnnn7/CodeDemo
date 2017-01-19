//
//  ConfirmWebViewController.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/10.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "ConfirmWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebView+LJCapture.h"
#import "UIView+LJCapture.h"

@interface ConfirmWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;

@end

@implementation ConfirmWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票鉴真";
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://inv-veri.chinatax.gov.cn/"]]];
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.startry.com"]]];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"截屏" style:UIBarButtonItemStylePlain target:self action:@selector(cutScreen)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

// https 支持

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
        }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (_infoArray.count)
    {
        
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('fpdm').value = '%@'",_infoArray[2]] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
        // 失去焦点
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('fpdm').blur()"] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
        
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('fphm').value = '%@'",_infoArray[3]] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
        
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('kprq').value = '%@'",_infoArray[5]] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
        NSString *jiaoyanmaString = _infoArray[6];
        NSString *cofirmString1 = [jiaoyanmaString substringFromIndex:jiaoyanmaString.length - 6];
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementById('kjje').value = '%@'",cofirmString1] completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            
        }];
        
        
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    NSLog(@"Prompt:%@ \n defaultText:%@ \n ",prompt,defaultText);
}

- (void)cutScreen {
//    CGRect snapshotFrame = CGRectMake(0, 0, _webView.scrollView.contentSize.width, _webView.scrollView.contentSize.height);
//    UIEdgeInsets snapshotEdgeInsets = UIEdgeInsetsZero;
//    UIImage *shareImage = [self snapshotViewFromRect:snapshotFrame withCapInsets:snapshotEdgeInsets];
    [_webView lj_contentCaptureWithHandle:^(UIImage *captureImage) {
        NSString *path_document = NSHomeDirectory();
        //设置一个图片的存储路径
        
        NSString *imagePath = [path_document stringByAppendingString:@"/Documents/picc.png"];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        
        NSLog(@"%@",imagePath);
        
        [UIImagePNGRepresentation(captureImage) writeToFile:imagePath atomically:YES];
        UIImageWriteToSavedPhotosAlbum(captureImage, NULL, NULL, NULL);
    }];
    
}


- (UIImage *)snapshotViewFromRect:(CGRect)rect withCapInsets:(UIEdgeInsets)capInsets {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = self.webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    CGFloat contentWidth = contentSize.width;
    
    CGPoint offset = self.webView.scrollView.contentOffset;
    
    [self.webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, [UIScreen mainScreen].scale);
        [self.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = self.webView.scrollView.contentOffset.y;
        [self.webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    
    [self.webView.scrollView setContentOffset:offset];
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapshotView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
    
    snapshotView.image = [fullImage resizableImageWithCapInsets:capInsets];
    return snapshotView.image;
}

- (void)cutScreentest
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(currentContext, -0, -64);
    [self.view.layer renderInContext:currentContext];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIAlertController *tipAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SnapShortImageNotification" object:nil userInfo:@{@"snapImage" : snapshotImage}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [tipAlert addAction:sureAction];
    [self presentViewController:tipAlert animated:YES completion:^{
        
    }];
    
}

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
