#iOS充电教程所有测试的例子
##RunLoooopTest

例子中模拟了scrollView滑动会影响scheduledTimerWithTimeInterval创建的NSTimer及initWithRequest创建的NSURLConnection，并在例子中给出了解决方案

```objective-c
//这种方法的timer不会被scrollview的滑动暂停
NSTimer * timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(testURLConnection:) userInfo:nil repeats:NO];
[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
```



```objective-c
//这种方式的的NSURLConnection会被scrollview暂停 但是可以进行取消操作
NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://code.csdn.net"] ]delegate:self startImmediately:NO];
//加上这句话就不会被scrollView暂停
//[connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
[connection start];
```

##ThreadTest

例子中 介绍了
1、NSThread 线程同步如何操作 及 三种加锁的方法`NSLock`、`NSCondition`和`@synchronized(self)`,如果不加锁数据会有异常
这就暴露了NSThread的一个缺点：必须手动处理线程同步，如果有一个子线程处理效率很慢的话，还有可能会造成死锁的现象

2、NSOperation 三种使用的方法（NSBlockOperation、NSInvocationOperation、NSOperation子类继承，重载main函数）、依赖关系添加：可以用来控制线程顺序、1000个线程并发测试：线程并发数量受设备性能影响较大，模拟器只能同步并发65左右


```objective-c
//如果调用start 就相当于同步，会线程阻塞
//[operation start];

//设置的数量并不是可以无限大，如果超出iphone设备的性能，则基本等于没有设置，或相当于设置了NSOperationQueueDefaultMaxConcurrentOperationCount，代码中设为3有效，但是如果设为kThreadMaxNum则无效 模拟器最大并发数约为64左右
operationQueue.maxConcurrentOperationCount = kThreadMaxNum;
```



3、NSThread 1000个线程并发测试

4、GCD并行队列 和 串行队列 、group 和 dispatch_barrier_async的使用


```objective-c
//---------------------------GCD之dispatch_queue_create并行队列测试---------------------------------
//并行队列 线程数量受设备影响 模拟器最多开启63左右
dispatch_queue_t concurrentQueue = dispatch_queue_create("并行队列", DISPATCH_QUEUE_CONCURRENT);
for (int i =0; i<kThreadMaxNum; i++) {
    if(i == 0)
        //dispatch_barrier_async函数只有在dispatch_queue_create创建的子线程中有效 在dispatch_get_global_queue创建的子线程中无效，可以用来控制线程顺序，此函数之前的线程在其之前执行，此函数之后的在其后执行
        dispatch_barrier_async(concurrentQueue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
    else
        dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });

}

//---------------------------GCD之dispatch_queue_create串行队列测试---------------------------------
//串行队列 线程数量受设备影响 模拟器最多开启63左右
dispatch_queue_t queue = dispatch_queue_create("串行队列", DISPATCH_QUEUE_SERIAL);
for (int i =0; i<kThreadMaxNum; i++) {
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:10];
        NSLog(@"GCD产生子线程%@",@(i).stringValue);
    });

}


//---------------------------GCD之dispatch_get_global_queue并行队列测试---------------------------------
//并行队列 线程数量受设备影响 模拟器最多开启63左右
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
for (int i =0; i<kThreadMaxNum; i++) {
    if(i == 0)
        //dispatch_barrier_async函数只有在dispatch_queue_create创建的子线程中有效 在dispatch_get_global_queue创建的子线程中无效，可以用来控制线程顺序，此函数之前的线程在其之前执行，此函数之后的在其后执行
        dispatch_barrier_async(queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });
    else
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:10];
            NSLog(@"GCD产生子线程%@",@(i).stringValue);
        });

}

//---------------------------GCD之dispatch_apply测试---------------------------------
//dispatch_apply 是在主线程中操作 会阻塞主线程
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_apply(kThreadMaxNum, queue, ^(size_t i) {
//[NSThread sleepForTimeInterval:10];
NSLog(@"GCD产生子线程%@",@(i).stringValue);
});

//---------------------------GCD之dispatch_group_create测试---------------------------------
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
for (int i =0; i<kThreadMaxNum; i++) {

dispatch_group_async(group,queue, ^{
[NSThread sleepForTimeInterval:10];
NSLog(@"GCD产生子线程%@",@(i).stringValue);
});

}
dispatch_group_notify(group, dispatch_get_main_queue(), ^{

});
```

