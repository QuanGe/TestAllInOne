//
//  ViewController.m
//  TableViewTest
//
//  Created by 张如泉 on 15/11/12.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "QGOCCategory.h"
#import "ReactiveCocoa.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cornerRadiusCell"];
    
    
    for (int i = 12; i< 18; ++i) {
        UIView * btn = [cell.contentView viewWithTag:i];
        
        /*
        CAShapeLayer *layer = [CAShapeLayer layer];
        UIBezierPath *aPath = [UIBezierPath bezierPathWithOvalInRect:btn.bounds];
        layer.path = aPath.CGPath;
        btn.layer.mask = layer;*/
        
        //btn.layer.cornerRadius =20;
        //btn.layer.masksToBounds = YES;
        //btn.layer.shouldRasterize = YES;
        //btn.layer.rasterizationScale = [UIScreen mainScreen].scale;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://avatar.csdn.net/C/C/C/1_ghostbear.jpg"]];
        if(i == 12)
        {
            @weakify(btn);
            [(UIButton *)btn setImageForState:UIControlStateNormal withURLRequest:request placeholderImage:[[UIImage imageNamed:@"festival_d11_detail_tmall"] qgocc_clipImageWithCornerRadius:20] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                @strongify(btn);
                [(UIButton*)btn setImage:[image qgocc_clipImageWithCornerRadius:20] forState:UIControlStateNormal];
            } failure:^(NSError * _Nonnull error) {
                
            }];
           
        }
        else
        {
            @weakify(btn);
            [(UIImageView *)btn setImageWithURLRequest:request placeholderImage:[[UIImage imageNamed:@"festival_d11_detail_tmall"] qgocc_clipImageWithCornerRadius:20] success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                @strongify(btn);
                [(UIImageView *)btn setImage:[image qgocc_clipImageWithCornerRadius:20]];
            } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                
            } ];
          
        }
    }
   
    return cell;
    
}
@end
