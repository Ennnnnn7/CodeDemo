//
//  MainViewController.m
//  CodeDemo
//
//  Created by 刘杰 on 2017/1/9.
//  Copyright © 2017年 LJ. All rights reserved.
//

#import "MainViewController.h"
#import "InvoiceDetailViewController.h"
#import "HeadView.h"
#import "MainTableViewCell.h"
#import "InvoiceModel.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation MainViewController
static  NSString * const cellIdentifier = @"cellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 赋值Model数组
    _modelArray = [NSMutableArray array];
    [self addModelArray];
    
    // 添加表视图
    _mainTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 100;
    _mainTableView.tableHeaderView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 250)];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mainTableView];
    
    // 添加导航栏右侧按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"添加团组记录" style:UIBarButtonItemStylePlain target:self action:@selector(addInvoice)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewInvoice:) name:@"updateInvoiceInfo" object:nil];
}


- (void)addModelArray
{
    InvoiceModel *firstModel = [[InvoiceModel alloc] init];
    [firstModel.imageArray addObject:[UIImage imageNamed:@"FirstInvoice"]];
    [firstModel.imageArray addObject:[UIImage imageNamed:@"FirstInvoiceConfirm"]];
    [_modelArray addObject:firstModel];
}





#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InvoiceDetailViewController *invoiceDetailVC = [[InvoiceDetailViewController alloc] init];
    invoiceDetailVC.invoiceModel = _modelArray[indexPath.row];
    [self.navigationController pushViewController:invoiceDetailVC animated:YES];
    
    
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"团组%ld.",(long)indexPath.row + 1];
    cell.cellModel = _modelArray[indexPath.row];
    return cell;
}


- (void)addInvoice
{
    InvoiceDetailViewController *invoiceDetailVC = [[InvoiceDetailViewController alloc] init];
    [self.navigationController pushViewController:invoiceDetailVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)addNewInvoice:(NSNotification *)notification
{
    InvoiceModel *tempModel = notification.userInfo[@"invoiceInfo"];
    [_modelArray addObject:tempModel];
    [_mainTableView reloadData];
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
