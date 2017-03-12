//
//  ViewController.m
//  NeverStop
//
//  Created by Jiang on 16/10/20.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "RegisterViewController.h"
#import "MyViewController.h"

@interface ViewController ()
<
UITextFieldDelegate,
RegisterVCDelegate
>
{
    BOOL flag;
}
@property (nonatomic, strong) UserManager *userManager;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *secretTextField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"loginBackgroundImage"];
    [self.view addSubview:background];
    
    UIView *blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [background addSubview:blackView];
    
    
    
    
    self.userManager = [UserManager shareUserManager];
    [_userManager openSQLite];
    
    
    [self createInfoView];

    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2, 200, 45)];
    _tipLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _tipLabel.font = kFONT_SIZE_15;
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.layer.cornerRadius = 5.f;
    _tipLabel.clipsToBounds = YES;
    _tipLabel.hidden = YES;
    [self.view addSubview:_tipLabel];
    
}

- (void)createInfoView {
    
    UIView *nameBackView = [[UIView alloc] initWithFrame:CGRectMake(60, SCREEN_HEIGHT / 3 - 50, SCREEN_WIDTH - 120, 50)];
    nameBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    nameBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:nameBackView];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    nameImageView.image = [UIImage imageNamed:@"guide_name"];
    [nameBackView addSubview:nameImageView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameImageView.x + nameImageView.width + 5, nameImageView.y, 190, 40)];
    NSString *nameHolderText = @"请输入昵称";
    NSMutableAttributedString *namePlaceholder = [[NSMutableAttributedString alloc] initWithString:nameHolderText];
    [namePlaceholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor colorWithWhite:1 alpha:0.5]
                        range:NSMakeRange(0, nameHolderText.length)];
    [namePlaceholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:14]
                        range:NSMakeRange(0, nameHolderText.length)];
    _nameTextField.attributedPlaceholder = namePlaceholder;
    _nameTextField.textColor = [UIColor whiteColor];
    _nameTextField.delegate = self;
    _nameTextField.tag = 1499;
    [nameBackView addSubview:_nameTextField];
    
    
    UIView *secretBackView = [[UIView alloc] initWithFrame:CGRectMake(nameBackView.x, nameBackView.y + nameBackView.height + 5, SCREEN_WIDTH - 120, 50)];
    secretBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    secretBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:secretBackView];
    
    UIImageView *secrectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    secrectImageView.image = [UIImage imageNamed:@"guide_secret"];
    [secretBackView addSubview:secrectImageView];
    
    self.secretTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameImageView.x + nameImageView.width + 5, nameImageView.y, 190, 40)];
    [_secretTextField setSecureTextEntry:YES];
    NSString *secretHolderText = @"请输入密码";
    NSMutableAttributedString *secretPlaceholder = [[NSMutableAttributedString alloc] initWithString:secretHolderText];
    [secretPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithWhite:1 alpha:0.5]
                            range:NSMakeRange(0, secretHolderText.length)];
    [secretPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:14]
                            range:NSMakeRange(0, secretHolderText.length)];
    _secretTextField.attributedPlaceholder = secretPlaceholder;
    _secretTextField.textColor = [UIColor whiteColor];
    _secretTextField.delegate = self;
    _secretTextField.tag = 1498;
    [secretBackView addSubview:_secretTextField];
    

    self.enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enterButton.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, SCREEN_HEIGHT - 150, 180, 40);
    _enterButton.backgroundColor = [UIColor colorWithRed:0.297 green:0.5 blue:0.193 alpha:1.0];
    _enterButton.layer.cornerRadius = 5.f;
    [_enterButton setTitle:@"登录" forState:UIControlStateNormal];
    [_enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_enterButton];
    [_enterButton addTarget:self action:@selector(enterButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake(_enterButton.x, _enterButton.y + _enterButton.height + 15, _enterButton.width, _enterButton.height);
    registerButton.backgroundColor = [UIColor colorWithRed:0.297 green:0.5 blue:0.193 alpha:1.0];
    registerButton.layer.cornerRadius = 5.f;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)getName:(NSString *)name password:(NSString *)password {
    _nameTextField.text = name;
    _secretTextField.text = password;
}

- (void)registerButtonAction {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.delegate = self;
    [self presentViewController:registerVC animated:YES completion:nil];

}
#pragma mark - 登录按钮点击事件
- (void)enterButtonAction {
    
    
      self.view.window.rootViewController = _rootTabBarController;
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (1499 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    if (textField.tag == 1500) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nameTextField resignFirstResponder];
    [_secretTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
