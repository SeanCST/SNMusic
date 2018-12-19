//
//  SNLoginViewController.m
//  SNMusic
//
//  Created by 肖恩伟 on 2018/11/16.
//  Copyright © 2018 肖恩伟. All rights reserved.
//

#import "SNLoginViewController.h"
@interface SNLoginViewController ()

@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation SNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.title = @"登陆";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initViews];
}

- (void)initViews {
    // 填写手机号
    UITextField *phoneField = [[UITextField alloc] init];
    phoneField.placeholder = @"手机号";
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneField];
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
    }];
    
    UIView *phoneFieldBtmLine = [[UIView alloc] init];
    phoneFieldBtmLine.backgroundColor = SNSeperateLineColor;
    [self.view addSubview:phoneFieldBtmLine];
    [phoneFieldBtmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneField.mas_bottom);
        make.left.equalTo(phoneField);
        make.right.equalTo(phoneField);
        make.height.equalTo(@0.5);
    }];
    
    self.phoneField = phoneField;
    
    // 填写密码
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"密码";
    [self.view addSubview:passwordField];
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneField.mas_bottom).offset(10);
        make.left.equalTo(phoneField);
        make.right.equalTo(phoneField);
        make.height.equalTo(phoneField);
    }];
    
    UIView *passwordFieldBtmLine = [[UIView alloc] init];
    passwordFieldBtmLine.backgroundColor = SNSeperateLineColor;
    [self.view addSubview:passwordFieldBtmLine];
    [passwordFieldBtmLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordField.mas_bottom);
        make.left.equalTo(passwordField);
        make.right.equalTo(passwordField);
        make.height.equalTo(phoneFieldBtmLine);
    }];
    
    self.passwordField = passwordField;
    
    // 登陆按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[self imageWithColor:SNBackgroundColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[self imageWithColor:SNButtonClickedColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordField.mas_bottom).offset(30);
        make.left.equalTo(passwordField);
        make.right.equalTo(passwordField);
        make.height.equalTo(passwordField);
    }];
}


/**
 登陆 - 网络请求
 */
- (void)loginBtnClicked {
    NSString *URLString = [NSString stringWithFormat:@"%@/login/cellphone", BaseUrl];
    NSDictionary *params = @{@"phone": self.phoneField.text,
                             @"password": self.passwordField.text
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { // 登陆成功
        
        // 存储已登录的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"LoginedAccount"];

        // 发送通知跳转控制器
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginSuccessChangeVC" object:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
//    [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:parameters error:nil];
}


// 颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
