//
//  MainTableViewCell.h
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/9.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceModel.h"
@interface MainTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *firstImageView;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) InvoiceModel *cellModel;
@end
