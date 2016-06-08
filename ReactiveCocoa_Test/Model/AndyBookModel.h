//
//  AndyBook.h
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AndyBookModel : NSObject
//{
//    @public
//    NSString *_title;
//}

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) KVO NSString *title;

//@property(nonatomic, strong) RACSignal *testSignal;

+ (instancetype)bookWithDict:(NSDictionary *)dict;

@end
