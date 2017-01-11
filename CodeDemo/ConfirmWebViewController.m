//
//  ConfirmWebViewController.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/10.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "ConfirmWebViewController.h"
#import <WebKit/WebKit.h>

@interface ConfirmWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;

@end

@implementation ConfirmWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发票鉴真";
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://inv-veri.chinatax.gov.cn/"]]];
    
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


- (void)cutScreen
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
