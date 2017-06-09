//
//  ViewController.m
//  TestArray
//
//  Created by git on 2017/4/7.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import "ViewController.h"
#import <objc/Object.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *someArray = @[@(1),@(21)];
    NSRange copyRange = NSMakeRange(0, [someArray count]);
    id *cArray = malloc(sizeof(id *) * copyRange.length);
    
    [someArray getObjects:cArray range:copyRange];
    
    /* use cArray somewhere */
    
    free(cArray);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
