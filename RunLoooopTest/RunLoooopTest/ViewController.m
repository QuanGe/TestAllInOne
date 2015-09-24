//
//  ViewController.m
//  RunLoooopTest
//
//  Created by 张如泉 on 15/9/24.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *dataTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //**********************测试效果的方法：当控制台输出4时不停拖动tableview************************
    
    //这种方法的timer会被scrollview的滑动暂停
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(printLog:) userInfo:nil repeats:YES];
    
    //这种方法的timer不会被scrollview的滑动暂停
    NSTimer * timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(testURLConnection:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    [self.dataTable addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)printLog:(id)sender
{
    NSLog(@"%@",@(++self.view.tag));
    if(self.view.tag == 5)
        NSLog(@"开始访问网络");
}

- (void)testURLConnection:(id)sender
{
    //这种方式的的NSURLConnection不会被scrollview暂停 但是同样无法进行取消操作
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com"] ] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"返回github结果");
    }];
    
    //这种方式的的NSURLConnection会被scrollview暂停 但是可以进行取消操作
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://code.csdn.net"] ]delegate:self startImmediately:NO];
    //加上这句话就不会被scrollView暂停
    //[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [connection start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RLTCell"];
    
    
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offest = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        if(offest.y != 0)
            NSLog(@"滑动中。。。。");
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"返回百度结果");
    
}
@end
