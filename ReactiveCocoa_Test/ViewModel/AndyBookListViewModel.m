//
//  AndyBookListViewModel.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyBookListViewModel.h"
#import "AndyBookModel.h"

@implementation AndyBookListViewModel

- (instancetype)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _getBookListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        AndyLog(@"请求数据");
        
        [MBProgressHUD showMessage:@"数据请求中..." toView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            
            [mgr GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"美女"}  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 请求成功的时候调用
                AndyLog(@"数据请求成功");
                
                NSArray *dictArr = responseObject[@"books"];
                
                //rac_sequence:RAC的集合。还有RACTuple元组
                //map:RAC的映射，map会把所有要遍历的元素映射成一个新对象，然后取得返回值就是所要的值。map实际上是调用了flattenMap，而fattenMap调用了bind。ReactiveCocoa的核心思想就是bind绑定，底层几乎都是用bind实现。
                NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                    
                    return [AndyBookModel bookWithDict:value];
                    
                }] array];
                
//                [dictArr.rac_sequence.signal subscribeNext:^(RACTuple *x) {
//                    RACTupleUnpack(NSString *key, NSString *value) = x;
//    
//                }];
                
                [MBProgressHUD hideHUDForView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
                [MBProgressHUD showSuccess:@"数据已获取" toView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
                
                [subscriber sendNext:modelArr];
                //最好每一个信号发送完成都写上发送完成。因为不写的话，可能会出问题，特别是在RAC组合的时候，concat顺序执行
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
                [MBProgressHUD showError:@"数据请求错误" toView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
                
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
                
            }];
            
            //在这里可以做一些vm信号资源清除的操作
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号释放");
            }];
            
            //return nil;
        }];
        
        return signal;
        
    }];
}

@end
