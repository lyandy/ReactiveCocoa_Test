//
//  AndyBookCell.h
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AndyBookModel.h"

@interface AndyBookCell : UITableViewCell

@property (nonatomic, assign) CGFloat cellHeight;

@property(nonatomic, strong) AndyBookModel *bookModel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
