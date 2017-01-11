//
//  InvoiceDetailViewController.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/10.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "InvoiceDetailViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import "LJImageView.h"
#import "ScanCodeViewController.h"
#import "ConfirmWebViewController.h"


@interface InvoiceDetailViewController ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) LJImageView *invoiceImageView;
@property (nonatomic, strong) LJImageView *invoiceConfirmImagView;

@property (nonatomic, getter=isHaveQRCode) BOOL haveQRCode;
@property (nonatomic, strong) NSString *QRCodeString;
@property (nonatomic) BOOL invoiceIsBig;
@property (nonatomic) BOOL invoiceConfirmIsBig;
@property (nonatomic, strong) UIImage *invoiceImage;



@end

@implementation InvoiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加控件
    [self createSubViews];
    // 添加手势
    [self addTapFesture];
    
    if (_invoiceModel)
    {
        [_addButton setHidden:YES];
        _invoiceImageView.image = _invoiceModel.imageArray[0];
        _invoiceConfirmImagView.image = _invoiceModel.imageArray[1];
    } else
    {
        [_addButton setHidden:NO];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(updateInfo)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeImage:) name:@"SnapShortImageNotification" object:nil];
    
    

}
- (void)writeImage:(NSNotification *)notification
{
    UIImage *snapImage = notification.userInfo[@"snapImage"];
    _invoiceConfirmImagView.image = snapImage;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createSubViews
{
    // 添加获取图片Button
    [self.view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(74);
        make.width.height.mas_equalTo(80);
    }];
    
    [_addButton addTarget:self action:@selector(chooseGetInfoType) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.invoiceConfirmImagView];
    [self.view addSubview:self.invoiceImageView];
    
    [self.invoiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(174);
        make.width.height.mas_equalTo((kScreenWidth - 3 * 10) / 2.0);
        
    }];
    
    [self.invoiceConfirmImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(174);
        
        make.width.height.mas_equalTo((kScreenWidth - 3 * 10) / 2.0);
    }];
    
    
    
}

- (void)addTapFesture
{
    if (!_invoiceModel)
    {
        [_invoiceImageView.singleTap addTarget:self action:@selector(imageTapAction:)];
    }
    [_invoiceImageView.doubleTap addTarget:self action:@selector(imageTapAction:)];
    
    [_invoiceConfirmImagView.singleTap addTarget:self action:@selector(confirmImageTapAction:)];
    [_invoiceConfirmImagView.doubleTap addTarget:self action:@selector(confirmImageTapAction:)];
}

// 发票图片点击手势
- (void)imageTapAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view bringSubviewToFront:_invoiceImageView];
    if (tapGesture.numberOfTapsRequired == 1)
    {
        
        if (_haveQRCode)
        {
            NSArray<NSString *> *qrCodeArray = [_QRCodeString componentsSeparatedByString:@","];
            
            if (qrCodeArray.count >= 9)
            {
                
                NSString *alertTitle = [NSString stringWithFormat:@"发票号码是:%@\n发票代码是:%@",qrCodeArray[2],qrCodeArray[3]];
                
                //输出扫描字符串
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"前往鉴真" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    ConfirmWebViewController *confirmWebVC = [[ConfirmWebViewController alloc] init];
                    confirmWebVC.infoArray = qrCodeArray;
                    [self.navigationController pushViewController:confirmWebVC animated:YES];
                    
                    
                }];
                [alertVC addAction:cancelAction];
                [alertVC addAction:confirmAction];
                [self presentViewController:alertVC animated:YES completion:^{
                }];
            }
        } else
        {
            UIAlertController *firstAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择获取发票信息方式" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *handAction = [UIAlertAction actionWithTitle:@"手动输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ConfirmWebViewController *confirmWebVC = [[ConfirmWebViewController alloc] init];
                [self.navigationController pushViewController:confirmWebVC animated:YES];
            }];
            UIAlertAction *scanCodeAction = [UIAlertAction actionWithTitle:@"前往扫描二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
                [self.navigationController pushViewController:scanCodeVC animated:YES];
            }];
            
            [firstAlert addAction:handAction];
            [firstAlert addAction:scanCodeAction];
            [firstAlert addAction:cancelAction];
            [self presentViewController:firstAlert animated:YES completion:nil];
        }

    } else
    {
        NSLog(@"这是双击");
        if (_invoiceIsBig)
        {
            _invoiceIsBig = NO;
            [self.invoiceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.top.mas_equalTo(174);
                make.width.height.mas_equalTo((kScreenWidth - 3 * 10) / 2.0);

                
            }];
        } else
        {
            _invoiceIsBig = YES;
            [self.invoiceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(64);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(kScreenHeight - 64);
                
            }];
        }
    }
}

- (void)confirmImageTapAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view bringSubviewToFront:_invoiceConfirmImagView];
    if (tapGesture.numberOfTapsRequired == 1)
    {
        NSLog(@"这是单击2");
    } else
    {
        NSLog(@"这是双击2");
        if (_invoiceConfirmIsBig)
        {
            _invoiceConfirmIsBig = NO;
            [self.invoiceConfirmImagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-10);
                make.top.mas_equalTo(174);
                
                make.width.height.mas_equalTo((kScreenWidth - 3 * 10) / 2.0);
                
            }];
        } else
        {
            _invoiceConfirmIsBig = YES;
            [self.invoiceConfirmImagView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(0);
                make.top.mas_equalTo(64);
                make.width.mas_equalTo(kScreenWidth);
                make.height.mas_equalTo(kScreenHeight - 64);
                
            }];
        }
    }
}
#pragma mark - 控件懒加载
- (UIButton *)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        _addButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _addButton.layer.borderWidth = 0.5f;
        [_addButton setTintColor:[UIColor darkGrayColor]];
    }
    return _addButton;
}

- (UIImageView *)invoiceImageView
{
    if (!_invoiceImageView)
    {
        _invoiceImageView = [[LJImageView alloc] init];
        
    }
    return _invoiceImageView;
}

- (UIImageView *)invoiceConfirmImagView
{
    if (!_invoiceConfirmImagView)
    {
        _invoiceConfirmImagView = [[LJImageView alloc] init];
        
    }
    return _invoiceConfirmImagView;
}

#pragma mark - 自定义方法
- (void)chooseGetInfoType
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择添加图片方式" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       

        AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraStatus == AVAuthorizationStatusRestricted || cameraStatus == AVAuthorizationStatusDenied)
        {
            NSLog(@"请在设置中打开相机权限");
        } else
        {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.delegate = self;
            [self presentViewController:imagePickerVC animated:YES completion:^{
                
            }];
        }
        
        
        
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
        {
            NSLog(@"请在设置中打开相片权限");
        } else
        {
            UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerVC.allowsEditing = YES;
            imagePickerVC.delegate = self;
            [self presentViewController:imagePickerVC animated:YES completion:^{
                
            }];
        }

        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoLibraryAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *noEditImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    _invoiceImageView.image = noEditImage;
    _invoiceImage = noEditImage;
    UIImage *srcImage = _invoiceImage;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    CIImage *tempImage = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:tempImage];
    if (features.count)
    {
        _haveQRCode = YES;
        CIQRCodeFeature *codeFeature = [features firstObject];
        _QRCodeString = codeFeature.messageString;
    } else
    {
        _haveQRCode = NO;
    }
    
    
}


- (void)updateInfo
{
    if (_invoiceImageView.image)
    {
        _invoiceModel = [[InvoiceModel alloc] init];
        [_invoiceModel.imageArray addObject:_invoiceImageView.image];
        [_invoiceModel.imageArray addObject:_invoiceConfirmImagView.image];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInvoiceInfo" object:nil userInfo:@{@"invoiceInfo":_invoiceModel}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
