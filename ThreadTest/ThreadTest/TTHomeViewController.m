//
//  ViewController.m
//  ThreadTest
//
//  Created by 张如泉 on 15/9/27.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "TTHomeViewController.h"

@interface TTHomeViewController ()
@property (nonatomic,readonly,copy) NSDictionary * tableData;
@end

@implementation TTHomeViewController

- (NSDictionary *)tableData
{
    return @{@"NSThread":@"TTNSThreadTestViewController"};
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"多线程测试";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TTCell"];
    UILabel *titleLable = (UILabel*)[cell.contentView viewWithTag:1];
    if(titleLable)
        titleLable.text = self.tableData.allKeys[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* modal=[mainStoryboard instantiateViewControllerWithIdentifier:self.tableData.allValues[indexPath.row]];
    [self.navigationController pushViewController:modal animated:YES];
}

@end
