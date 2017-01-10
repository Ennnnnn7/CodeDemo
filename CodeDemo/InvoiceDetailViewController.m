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

@interface InvoiceDetailViewController ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) LJImageView *invoiceImageView;
@property (nonatomic, strong) LJImageView *invoiceConfirmImagView;
@property (nonatomic) CGRect invoiceLastRect;
@property (nonatomic) BOOL invoiceIsBig;
@property (nonatomic) CGRect invoiceConfirmLastRect;
@property (nonatomic) BOOL invoiceConfirmIsBig;



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
    }


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
    [_invoiceImageView.singleTap addTarget:self action:@selector(imageTapAction:)];
    [_invoiceImageView.doubleTap addTarget:self action:@selector(imageTapAction:)];
    
    [_invoiceConfirmImagView.singleTap addTarget:self action:@selector(confirmImageTapAction:)];
    [_invoiceConfirmImagView.doubleTap addTarget:self action:@selector(confirmImageTapAction:)];
}

- (void)imageTapAction:(UITapGestureRecognizer *)tapGesture
{
    [self.view bringSubviewToFront:_invoiceImageView];
    if (tapGesture.numberOfTapsRequired == 1)
    {
        NSLog(@"这是单击");
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
