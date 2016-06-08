//
//  AndyBook.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyBookModel.h"

@implementation AndyBookModel

+ (instancetype)bookWithDict:(NSDictionary *)dict
{
    AndyBookModel *book = [[AndyBookModel alloc] init];
    
    book.title = dict[@"title"];
    book.subtitle = dict[@"subtitle"];
    return book;
}

@end
