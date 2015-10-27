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
    __block int aNumber = 0;
    
    //植物大战僵尸 中的豌豆射手
    RACSignal *peaKiller = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
        aNumber++;
        
        if(aNumber >2)
            [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"不好意思，正在冷却"}]];
        else
        {
            //发射豌豆子弹
            [subscriber sendNext:@(aNumber)];
            [subscriber sendCompleted];
        }
            
        return [RACDisposable disposableWithBlock:^{
            aNumber = 0;
            NSLog(@"进行清理工作");
        }];;
    }];
    
    //对豌豆射手 添加一个靶子 比如僵尸 （这里用block 生成一个RACSubscriber对象，block内的代码 就是接受到子弹后处理）
    [peaKiller subscribeNext:^(id x) {
        NSLog(@"来了一只小僵尸，对僵尸1减去生命值 %@，直接干死", x);
    }];
    
    //map 相当于对子弹进行加工 比如加上寒冰属性 使伤害值加100
    RACDisposable * dispose = [[peaKiller map:^id(id value) {
        return @([value integerValue] +100);
    }] subscribeNext:^(id x) {
        NSLog(@"又来一只boss，对僵尸2减去生命值 %@，直接干死", x);
    }];
    
    [peaKiller subscribeNext:^(id x) {
        NSLog(@"玩了又来了一只，这次还有子弹么 %@", x);
    } error:^(NSError *error) {
        NSLog(@"%@",NSLocalizedString([error userInfo][NSLocalizedDescriptionKey], nil));
    }];
    
    //游戏结束 进行清理工作
    [dispose dispose];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
