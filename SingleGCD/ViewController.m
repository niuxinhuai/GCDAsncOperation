//
//  ViewController.m
//  SingleGCD
//
//  Created by 牛新怀 on 2017/8/15.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self dispatchAllRequest];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dispatchAllRequest{
    // 利用线程依赖关系测试
    __weak typeof (self)weakSelf =self;
    
    NSBlockOperation * operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestA];
        
    }];
    NSBlockOperation * operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestB];
        
    }];
    NSBlockOperation * operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf requestC];
        
    }];
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:NO];
}
-(void)requestA{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行A");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误A");
        
    }];
    
    NSLog(@"正在刷新A");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新A");
}
-(void)requestB{
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行B");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误B");
        
    }];
    
    NSLog(@"正在刷新B");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新B");
    
}
-(void)requestC{
    
    //创建信号量并设置计数默认为0
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    [manager GET:@"http://qr.bookln.cn/qr.html?crcode=110000000F00000000000000B3ZX1CEC" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_semaphore_signal(sema);
        NSLog(@"正在执行C");
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ////计数+1操作
        
        dispatch_semaphore_signal(sema);
        NSLog(@"执行错误C");
        
    }];
    
    NSLog(@"正在刷新C");
    //若计数为0则一直等待
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"已经刷新C");
}


@end
