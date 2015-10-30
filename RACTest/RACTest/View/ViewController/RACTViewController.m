//
//  RACTViewController.m
//  RACTest
//
//  Created by 张如泉 on 15/10/26.
//  Copyright © 2015年 quange. All rights reserved.
//

#import "RACTViewController.h"
#import "UIView+WillChange.h"
#import "ReactiveCocoa.h"
@interface RACTViewController ()

@end

@implementation RACTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"category返回的view的宽度到底是多少%@",@([self.view width]));
    //伤害值
    const NSInteger hurtNumer = 5;
    //伤害次数
    __block NSInteger usedNumber = 0;
    
    //植物大战僵尸 中的豌豆射手（这个射手一次 可以连发三发子弹）
    RACSignal *peaKiller = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        usedNumber++;
        if(usedNumber >2)
            [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"不好意思，正在冷却"}]];
        else
        {
            //发射第一发豌豆子弹
            [subscriber sendNext:@(hurtNumer)];
            //发射第二发豌豆子弹
            [subscriber sendNext:@(hurtNumer+1)];
            //结束发射
            [subscriber sendCompleted];
            //发射第三发豌豆子弹
            [subscriber sendNext:@(hurtNumer+2)];
        }
            
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"进行清理工作");
        }];;
    }];
    
    //第一次使用豌豆射手 ，并且设置接受子弹后处理 （这里用block 生成一个RACSubscriber对象，block内的代码 就是接受到子弹后处理）
    [peaKiller subscribeNext:^(id x) {
        NSLog(@"接收到一个豌豆子弹，对僵尸1减去生命值 %@", x);
    }];
    
    //第二次使用豌豆射手  map 相当于对子弹进行加工 比如加上寒冰属性 使伤害值加100
    RACDisposable * dispose = [[peaKiller map:^id(id value) {
        return @([value integerValue] +100);
    }] subscribeNext:^(id x) {
        NSLog(@"接收到一个豌豆子弹，，对僵尸2减去生命值 %@", x);
    }];
    
    //第三次使用豌豆射手
    [peaKiller subscribeNext:^(id x) {
        NSLog(@"第三次使用，这次还有子弹么 %@", x);
    } error:^(NSError *error) {
        NSLog(@"第三次使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
    }];
    
    //游戏结束 进行清理工作
    [dispose dispose];
    
    RACDisposable * connectdispose = [[NSURLConnection rac_sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]] subscribeNext:^(id x) {
        NSLog(@"结果为%@",x);
    }];
    [connectdispose dispose];
    
    /*
    RACSignal *helloSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"hello"];
        [subscriber sendNext:@"hello1"];
        return nil;
        
    }];
    
    RACSignal *wordSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        sleep(2);
        [subscriber sendNext:@"world"];
        [subscriber sendNext:@"world1"];
        return nil;
        
    }];
    
    
    {
        [[peaKiller combineLatestWith:helloSignal] subscribeNext:^(id x) {
            NSLog(@"combineLatestWith绑定信号使用: %@", x);
        } error:^(NSError *error) {
            NSLog(@"combineLatestWith绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
        [[helloSignal combineLatestWith:wordSignal] subscribeNext:^(id x) {
            RACTuple * result = x;
            
            NSLog(@"combineLatestWith绑定信号使用 %@", [result allObjects]);
        } error:^(NSError *error) {
            NSLog(@"combineLatestWith绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
        
        
        [[RACSignal combineLatest:@[peaKiller,wordSignal] reduce:^(NSString *hellow, NSString *word){
            NSLog(@"combineLatestWith绑定信号使用 %@ %@",hellow,word);
            return ([hellow isEqualToString:@"你好"] || [word isEqualToString:@"世界"]) ?@(YES):@(NO);
            
        }] subscribeNext:^(id x) {
            
        }];
    }
    
    
    
    {
        [[peaKiller merge:helloSignal] subscribeNext:^(id x) {
            NSLog(@"merge绑定信号使用 %@", x);
        } error:^(NSError *error) {
            NSLog(@"merge绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
        [[helloSignal merge:wordSignal] subscribeNext:^(id x) {
            NSLog(@"merge绑定信号使用 %@",x);
        } error:^(NSError *error) {
            NSLog(@"merge绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
    }
    
    
    {
        [[peaKiller zipWith:helloSignal] subscribeNext:^(id x) {
            NSLog(@"zipWith绑定信号使用 %@", x);
        } error:^(NSError *error) {
            NSLog(@"zipWith绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
        [[helloSignal zipWith:wordSignal] subscribeNext:^(id x) {
            NSLog(@"zipWith绑定信号使用 %@",x);
        } error:^(NSError *error) {
            NSLog(@"zipWith绑定信号使用，报错：%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
        } completed:^{
            NSLog(@"都完成了");
        }];
        
    }
    */
    
   
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
