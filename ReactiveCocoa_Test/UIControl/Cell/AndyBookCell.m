//
//  AndyBookCell.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyBookCell.h"

@implementation AndyBookCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *Id = @"bookCell";
    AndyBookCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (cell == nil)
    {
        cell = [[AndyBookCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupSubviews];
        
        //[self setupAutoLayout];
    }
    return self;
}

- (void)setBookModel:(AndyBookModel *)bookModel
{
    _bookModel = bookModel;
    
//    self.textLabel.text = bookModel.title;
//    self.detailTextLabel.text = bookModel.subtitle;
    
    [self bindModel];
    
    [self setupAutoLayout];
}

- (void)bindModel
{
//    RAC(self.textLabel, text) = nil;
//    RAC(self.detailTextLabel, text) = nil;
    
//    [[self.bookModel rac_valuesAndChangesForKeyPath:@"title" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
//        
//        self.textLabel.text = x;
//        
//    }];

    //take:取前面几个值
    //takeLast:取后面几个值
    //takeUntil:只要传入的信号发送完成，就不会再接收源信号内容
    RAC(self.textLabel, text) = [RACObserve(self.bookModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.detailTextLabel, text) = [RACObserve(self.bookModel, subtitle) takeUntil:self.rac_prepareForReuseSignal];
    
    //RAC(self.textLabel, text) = [self.bookModel.testSignal takeUntil:self.rac_prepareForReuseSignal];
    
//    [RACObserve(self.bookModel, title) map:^id(id value) {
//        self.textLabel.text = value;
//        return value;
//    }];
    
//    [RACObserve(self.bookModel, title) subscribeNext:^(id x) {
//        self.textLabel.text = x;
//    }];
//    
//    [RACObserve(self.bookModel, subtitle) subscribeNext:^(id x) {
//        self.detailTextLabel.text = x;
//    }];

}

- (void)setupSubviews
{
    //这里就是自己去添加控件，为了方便效果直接使用了cell自身的控件来展示数据
}

- (void)setupAutoLayout
{
    self.bookModel.cellHeight = (arc4random() % 60) + 40;
    
    AndyLog(@"Cell高度: %f", self.bookModel.cellHeight);
}
















@end
