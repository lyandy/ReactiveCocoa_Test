//
//  AndyLoginViewController.m
//  ReactiveCocoa_Test
//
//  Created by 李扬 on 16/3/9.
//  Copyright © 2016年 andyli. All rights reserved.
//

#import "AndyLoginViewController.h"
#import "AndyLoginViewModel.h"
#import "AndyBookListViewController.h"

@interface AndyLoginViewController ()

@property (nonatomic, strong) UITextField *accountField;

@property (nonatomic, strong) UITextField *pwdField;

@property (nonatomic, strong) UIButton *loginBtn;

/**
 *  更多情况下是使用单例来使用ViewModel
 */
@property(nonatomic, strong) AndyLoginViewModel *loginVM;

@end

@implementation AndyLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    
    [self setupAutoLayout];
    
    [self bindViewModel];
    
    [self loginEvent];
}

#pragma mark - Property

- (UITextField *)accountField
{
    if (_accountField == nil)
    {
        _accountField = [[UITextField alloc] init];
        _accountField.borderStyle = UITextBorderStyleRoundedRect;
        _accountField.placeholder = @"帐号";
    }
    return _accountField;
}

- (UITextField *)pwdField
{
    if (_pwdField == nil)
    {
        _pwdField = [[UITextField alloc] init];
        _pwdField.borderStyle = UITextBorderStyleRoundedRect;
        _pwdField.secureTextEntry = YES;
        _pwdField.placeholder = @"密码";
        
    }
    return _pwdField;
}

- (UIButton *)loginBtn
{
    if (_loginBtn == nil)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
    return  _loginBtn;
}

- (AndyLoginViewModel *)loginVM
{
    if (_loginVM == nil)
    {
        _loginVM = [[AndyLoginViewModel alloc] init];
    }
    return _loginVM;
}

#pragma mark - Method
- (void)setupSubviews
{
    self.title = @"用户登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.accountField];
    [self.view addSubview:self.pwdField];
    [self.view addSubview:self.loginBtn];
}

- (void)setupAutoLayout
{
    CGFloat margin = 100;
    CGFloat width = 200;
    CGFloat height = 30;
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(width);
        make.height.equalTo(height);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.view).offset(margin + 64);
    }];
    
    [self.pwdField makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.accountField.mas_width);
        make.height.equalTo(self.accountField.height);
        make.centerX.equalTo(self.view.centerX);
        make.top.equalTo(self.accountField).offset(margin);
    }];
    
    [self.loginBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.pwdField).offset(margin);
    }];
}

- (void)bindViewModel
{
    //RAC宏：用来给某个对象的某个属性绑定信号，只要产生信号，就会把内容给属性赋值。
    RAC(self.loginVM, account) = self.accountField.rac_textSignal;
    RAC(self.loginVM, pwd) = self.pwdField.rac_textSignal;
    //RAC(self.loginBtn, enabled) = self.loginVM.loginEnableSignal;
    
    //RACObserve: 监听某个对象的某个属性，返回信号。
    RAC(self.loginBtn, enabled) = RACObserve(self.loginVM, testEnabled);
}

- (void)loginEvent
{
    //@weakify和@strongify成对出现防止出现block出现循环强引用
    @weakify(self);
    
    //rac_signalForControlEvents: 产生某个事件的时候转换成信号，然后订阅此信号就可以响应
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        
        [self.view endEditing:YES];

        //RACCommand：RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，它可以很方便的监控事件的执行过程。
        //使用场景:监听按钮点击，，网络请求
        //execute:执行RACCommand
        [[self.loginVM.loginCommand execute:@"开始登录"] subscribeNext:^(id x) {
            //接收登录结果
            if([x containsString:@"success"])
            {
                [MBProgressHUD hideHUDForView:[AndyCommonTool getCurrentPerformanceUIViewContorller].view];
                
                AndyBookListViewController *bookListVc = [[AndyBookListViewController alloc] init];
                bookListVc.title = @"图书列表";
                [self.navigationController pushViewController:bookListVc animated:YES];
                
                AndyLog(@"接收到登录数据，页面跳转");
            }
            else
            {
                AndyLog(@"登录失败");
            }
        }];
    }];
}







@end
