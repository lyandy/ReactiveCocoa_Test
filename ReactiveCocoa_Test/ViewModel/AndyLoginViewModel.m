//
//  AndyLoginViewModel.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyLoginViewModel.h"
//这个头文件要单独加。
#import "RACReturnSignal.h"

@implementation AndyLoginViewModel

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
//    self.loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)] reduce:^id(NSString *account, NSString *pwd){
//        return @(account.length && pwd.length);
//    }];
    
    //combineLatest:组合，将多个信号合并起来，并且拿到各个信号的最新的值
    //reduce:聚合
    //先组合再聚合
    //RACObserve: 监听某个对象的某个属性，返回信号。
    //RACSignal combineLatest:(id<NSFastEnumeration>) reduce:<#^id(void)reduceBlock#>
    //NSFastEnumeration:看到一个对象遵循了这个协议，就把它当成数组就行了。因为NSArray也遵循了这个协议
    //reduce：看起来是没有参数的，实际上是有参数的。它的参数不是由系统决定的，是由传入的数组决定的。参数的个数就是数组的元素信号个数，参数的类型就是数组元素信号内容的类型，参数的顺序和数据中元素信号位置一一对应。
    [[RACSignal combineLatest:@[RACObserve(self, account), RACObserve(self, pwd)] reduce:^id(NSString *account, NSString *pwd){
        return account.length && pwd.length ? @YES : @NO;
    }] subscribeNext:^(id x) {
        self.testEnabled = [x boolValue];
    }];

//    //用来将任意一个值包装成信号发出来。需要单独导入头文件"RACReturnSignal.h"
//    self.loginEnableSignal = [RACReturnSignal return:@(YES)];
    
    //因为loginCommand是只读的，这里要访问修改只能使用_loginCommand
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        AndyLog(@"%@", input);
        AndyLog(@"发送请求登录数据");
        
        RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //模拟登录延时
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                AndyLog(@"登录数据返回，准备转送结果");
                
                //这里的登录结果模拟为success，即表示为登录成功。这个信号发出去之后可以在ViewModel中处理，也可以发送到View层来处理控制器跳转。
                [subscriber sendNext:@"success"];
                //告诉RAC的executing信号发送完成
                [subscriber sendCompleted];
            });
            
            //在这里可以做一些vm信号资源清除的操作
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号释放");
            }];
            
            //return nil;
        }];

        //凡是返回一个信号，不允许为nil,但可以返回空信号[RACSignal empty];
        return singal;
    }];

//    //如果要在ViewModel里面处理登录完成的结果的话可以这么写。使用RAC的信号中的信号。缺点是command先执行再订阅
//    //executionSignals:信号源。信号中的信号。它发送的数据是个信号。
//    //switchToLates:获取最新发送的信号，只能用于信号中的信号
//    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        if ([x containsString:@"success"])
//        {
//            AndyLog(@"登录成功111");
//        }
//        else
//        {
//            AndyLog(@"登录失败");
//        }
//    }];
//    //信号中的信号的解释
//    [_loginCommand.executionSignals subscribeNext:^(id x) {
//        [x subscribeNext:^(id x) {
//            if ([x containsString:@"success"])
//            {
//                AndyLog(@"登录成功111");
//            }
//            else
//            {
//                AndyLog(@"登录失败");
//            }
//        }];
//    }];

    //executing：监听处理过程
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x boolValue] == YES)//YES：表示当前正在执行
        {
            AndyLog(@"正在登录中...");
            
            self.testEnabled = NO;
            
            [MBProgressHUD showMessage:@"正在登录..." toView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
        }
        else //执行完成或者没有执行
        {
            AndyLog(@"登录过程结束");
            
            self.testEnabled = YES;
        }
    }];

}

@end
