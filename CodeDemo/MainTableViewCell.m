//
//  MainTableViewCell.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/9.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initWithSubViews];
    }
    return self;
}


- (void)initWithSubViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.firstImageView];
    [self.contentView addSubview:self.secondImageView];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    
    [self.firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.equalTo(_firstImageView.mas_height);
    }];
    
    [self.secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_firstImageView.mas_right).offset(10);
        make.top.equalTo(_firstImageView.mas_top);
        make.width.height.mas_equalTo(_firstImageView.mas_width);
    }];
    
    
    
}

#pragma mark - 控件懒加载
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)firstImageView
{
    if (!_firstImageView)
    {
        _firstImageView = [[UIImageView alloc] init];
        
    }
    return _firstImageView;
}


- (UIImageView *)secondImageView
{
    if (!_secondImageView)
    {
        _secondImageView = [[UIImageView alloc] init];
        
    }
    return _secondImageView;
}

- (void)setCellModel:(InvoiceModel *)cellModel
{
    _cellModel = cellModel;
    
    
    _firstImageView.image = [UIImage imageNamed:cellModel.firstImageName];
    _secondImageView.image = [UIImage imageNamed:cellModel.secondImageName];
}








- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
