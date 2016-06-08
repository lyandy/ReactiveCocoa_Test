//
//  AndyLoginViewModel.h
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyLoginViewModel : NSObject

@property(nonatomic, strong) NSString *account;

@property(nonatomic, strong) NSString *pwd;

//@property(nonatomic, strong) RACSignal *loginEnabledSignal;

@property(nonatomic, strong, readonly) RACCommand *loginCommand;

/** testEnabled */
@property (nonatomic, assign) BOOL testEnabled;

@end
