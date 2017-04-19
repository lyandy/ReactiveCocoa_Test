//
//  AndyBookListViewController.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyBookListViewController.h"
#import "AndyBookListViewModel.h"
#import "AndyBookCell.h"
#import "AndyBookModel.h"
#import <ReactiveObjC/RACReturnSignal.h>

@interface AndyBookListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *bookListArrayM;

@property (nonatomic, strong) AndyBookListViewModel *bookListVM;

@end

@implementation AndyBookListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubViews];
    
    [self setupRACCommand];
    
}

- (void)setupSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Property

- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)bookListArrayM
{
    if (_bookListArrayM == nil)
    {
        _bookListArrayM = [NSMutableArray array];
    }
    return _bookListArrayM;
}

- (AndyBookListViewModel *)bookListVM
{
    if (_bookListVM == nil)
    {
        _bookListVM = [[AndyBookListViewModel alloc] init];
    }
    return _bookListVM;
}

#pragma mark - Method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Fades out top and bottom cells in table view as they leave the screen
    NSArray *visibleCells = [self.tableView visibleCells];
    
    if (visibleCells != nil  &&  [visibleCells count] != 0) {       // Don't do anything for empty table view
        
        /* Get top and bottom cells */
        UITableViewCell *topCell = [visibleCells objectAtIndex:0];
        UITableViewCell *bottomCell = [visibleCells lastObject];
        
        /* Make sure other cells stay opaque */
        // Avoids issues with skipped method calls during rapid scrolling
        for (UITableViewCell *cell in visibleCells) {
            cell.contentView.alpha = 1.0;
        }
        
        /* Set necessary constants */
        NSInteger cellHeight = topCell.frame.size.height - 1;   // -1 To allow for typical separator line height
        NSInteger tableViewTopPosition = self.tableView.frame.origin.y;
        NSInteger tableViewBottomPosition = self.tableView.frame.origin.y + self.tableView.frame.size.height;
        
        /* Get content offset to set opacity */
        CGRect topCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:topCell]];
        CGRect bottomCellPositionInTableView = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:bottomCell]];
        CGFloat topCellPosition = [self.tableView convertRect:topCellPositionInTableView toView:[self.tableView superview]].origin.y;
        CGFloat bottomCellPosition = ([self.tableView convertRect:bottomCellPositionInTableView toView:[self.tableView superview]].origin.y + cellHeight);
        
        /* Set opacity based on amount of cell that is outside of view */
        CGFloat modifier = 2.5;     /* Increases the speed of fading (1.0 for fully transparent when the cell is entirely off the screen,
                                     2.0 for fully transparent when the cell is half off the screen, etc) */
        CGFloat topCellOpacity = (1.0f - ((tableViewTopPosition - topCellPosition) / cellHeight) * modifier);
        CGFloat bottomCellOpacity = (1.0f - ((bottomCellPosition - tableViewBottomPosition) / cellHeight) * modifier);
        
        /* Set cell opacity */
        if (topCell) {
            topCell.contentView.alpha = topCellOpacity;
        }
        if (bottomCell) {
            bottomCell.contentView.alpha = bottomCellOpacity;
        }
    }
}

- (void)setupRACCommand
{
    @weakify(self);
    
    [[self.bookListVM.getBookListCommand execute:nil] subscribeNext:^(id x) {
        
        @strongify(self);
        
        //self.view.backgroundColor = [UIColor blueColor];
        
        AndyLog(@"请求到的数据如下: %@", x);
        
        [self.bookListArrayM addObjectsFromArray:x];
        
        [self.tableView reloadData];
    }];
}

- (void)dealloc
{
    AndyLog(@"控制器被销毁");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookListArrayM.count - 18;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyBookCell *cell = [AndyBookCell cellWithTableView:tableView];
    
    AndyBookModel *bookModel = self.bookListArrayM[indexPath.row];
    
    //bookModel.testSignal = [RACReturnSignal return:bookModel.title];
    
    cell.bookModel = bookModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyBookModel *bookModel = self.bookListArrayM[indexPath.row];
    //改变指定Model的值，界面上也会相应改变。KVO通知。本质就是监听一个对象有没有调用成员变量的set方法。如果不是调用成员变量的set方法，则kvo就监听不到内容，也就无法发出信号。
    bookModel.title = @"我变了";
    //bookModel.testSignal = [RACReturnSignal return:@"我变了哈哈"];
    //bookModel->_title = @"再次改变";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AndyBookModel *bookModel = self.bookListArrayM[indexPath.row];
    return bookModel.cellHeight;
}


@end
