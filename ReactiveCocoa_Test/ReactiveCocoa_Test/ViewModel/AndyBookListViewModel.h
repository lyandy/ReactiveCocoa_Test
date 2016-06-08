//
//  AndyBookListViewModel.h
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyBookListViewModel : NSObject

@property(nonatomic, strong, readonly) RACCommand *getBookListCommand;

@end
