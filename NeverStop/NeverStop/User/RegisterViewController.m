//
//  RegisterViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/7.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserManager.h"
#import "UserModel.h"
#import "ViewController.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface RegisterViewController ()

<
UITextFieldDelegate
>

@property (nonatomic, strong) UserManager *userManager;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *secretTextField;
@property (nonatomic, strong) UITextField *ageTextField;
@property (nonatomic, strong) UITextField *tallTextField;
@property (nonatomic, strong) UITextField *weightTextField;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *enterButton;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"guide"];
    [self.view addSubview:background];
    
    UIView *blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [background addSubview:blackView];
    
    self.userManager = [UserManager shareUserManager];
    [_userManager openSQLite];
    [_userManager createTable];

    
    
    [self createInfoView];
    
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT / 2 + 50, 200, 45)];
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
    
    UIView *nameBackView = [[UIView alloc] initWithFrame:CGRectMake(60, 100, SCREEN_WIDTH - 120, 50)];
    nameBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    nameBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:nameBackView];
    
    UIImageView *nameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 35, 35)];
    nameImageView.image = [UIImage imageNamed:@"guide_name"];
    [nameBackView addSubview:nameImageView];
    
    self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameImageView.x + nameImageView.width + 5, nameImageView.y, 190, 40)];
    NSString *nameHolderText = @"请输入昵称(仅限字母和数字)";
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
    NSString *secretHolderText = @"请输入密码(仅限字母和数字)";
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
    
    
    
    
    UIView *birthBackView = [[UIView alloc] initWithFrame:CGRectMake(secretBackView.x, secretBackView.y + secretBackView.height + 5, secretBackView.width, secretBackView.height)];
    birthBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    birthBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:birthBackView];
    
    
    UIImageView *birthImageView = [[UIImageView alloc] initWithFrame:CGRectMake(secrectImageView.x, secrectImageView.y, secrectImageView.width, secrectImageView.height)];
    birthImageView.image = [UIImage imageNamed:@"guide_age"];
    [birthBackView addSubview:birthImageView];
    
    self.ageTextField = [[UITextField alloc] initWithFrame:CGRectMake(birthImageView.x + birthImageView.width + 5, birthImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *ageHolderText = @"请输入年龄";
    NSMutableAttributedString *agePlaceholder = [[NSMutableAttributedString alloc] initWithString:ageHolderText];
    [agePlaceholder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithWhite:1 alpha:0.5]
                           range:NSMakeRange(0, ageHolderText.length)];
    [agePlaceholder addAttribute:NSFontAttributeName
                           value:[UIFont boldSystemFontOfSize:14]
                           range:NSMakeRange(0, ageHolderText.length)];
    _ageTextField.attributedPlaceholder = agePlaceholder;
    _ageTextField.textColor = [UIColor whiteColor];
    _ageTextField.delegate = self;
    _ageTextField.tag = 1500;
    [birthBackView addSubview:_ageTextField];
    
    UIView *tallBackView = [[UIView alloc] initWithFrame:CGRectMake(birthBackView.x, birthBackView.y + birthBackView.height + 5, birthBackView.width, birthBackView.height)];
    tallBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    tallBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:tallBackView];
    
    UIImageView *tallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nameImageView.x, nameImageView.y, nameImageView.width, nameImageView.height)];
    tallImageView.image = [UIImage imageNamed:@"guide_tall"];
    [tallBackView addSubview:tallImageView];
    
    self.tallTextField = [[UITextField alloc] initWithFrame:CGRectMake(tallImageView.x + tallImageView.width + 5, tallImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *tallHolderText = @"请输入身高(cm)";
    NSMutableAttributedString *tallPlaceholder = [[NSMutableAttributedString alloc] initWithString:tallHolderText];
    [tallPlaceholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithWhite:1 alpha:0.5]
                            range:NSMakeRange(0, tallHolderText.length)];
    [tallPlaceholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:14]
                            range:NSMakeRange(0, tallHolderText.length)];
    _tallTextField.attributedPlaceholder = tallPlaceholder;
    _tallTextField.textColor = [UIColor whiteColor];
    _tallTextField.delegate = self;
    _tallTextField.tag = 1501;
    [tallBackView addSubview:_tallTextField];
    
    
    UIView *weightBackView = [[UIView alloc] initWithFrame:CGRectMake(tallBackView.x, tallBackView.y + tallBackView.height + 5, tallBackView.width, tallBackView.height)];
    weightBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    weightBackView.layer.cornerRadius = 5.f;
    [self.view addSubview:weightBackView];
    
    UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tallImageView.x, tallImageView.y, tallImageView.width, tallImageView.height)];
    weightImageView.image = [UIImage imageNamed:@"guide_weigh"];
    [weightBackView addSubview:weightImageView];
    
    self.weightTextField = [[UITextField alloc] initWithFrame:CGRectMake(weightImageView.x + weightImageView.width + 5, weightImageView.y, _nameTextField.width, _nameTextField.height)];
    NSString *weightHolderText = @"请输入体重(kg)";
    NSMutableAttributedString *weightPlaceholder = [[NSMutableAttributedString alloc] initWithString:weightHolderText];
    [weightPlaceholder addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithWhite:1 alpha:0.5]
                              range:NSMakeRange(0, weightHolderText.length)];
    [weightPlaceholder addAttribute:NSFontAttributeName
                              value:[UIFont boldSystemFontOfSize:14]
                              range:NSMakeRange(0, weightHolderText.length)];
    _weightTextField.attributedPlaceholder = weightPlaceholder;
    _weightTextField.textColor = [UIColor whiteColor];
    _weightTextField.delegate = self;
    _weightTextField.tag = 1502;
    [weightBackView addSubview:_weightTextField];
    
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake((SCREEN_WIDTH - 180) / 2, SCREEN_HEIGHT - 150, 180, 40);
    registerButton.backgroundColor = [UIColor colorWithRed:0.0783 green:0.2043 blue:0.0647 alpha:1.0];
    registerButton.layer.cornerRadius = 5.f;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registerButton];
    [registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark - 注册按钮点击事件
- (void)registerButtonAction {
    
    if ([_nameTextField.text isEqualToString:@""]) {
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"昵称不能为空";
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _tipLabel.hidden = YES;
        }];
    } else if ([_secretTextField.text isEqualToString:@""]) {
        
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"密码不能为空";
        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _tipLabel.hidden = YES;
        }];

        
    } else if ([_tallTextField.text isEqualToString:@""]) {
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"身高不能为空";
        [self.view addSubview:_tipLabel];
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _tipLabel.hidden = YES;
        }];
        
    } else if ([_weightTextField.text isEqualToString:@""]) {
        
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"体重不能为空";
        
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _tipLabel.hidden = YES;
        }];
        
    } else {
     
        
        [_userManager insertIntoWithUserName:_nameTextField.text secret: _secretTextField.text age:_ageTextField.text tall:_tallTextField.text weight:_weightTextField.text];
            [self.delegate getName:_nameTextField.text password:_secretTextField.text];
            [self dismissViewControllerAnimated:YES completion:nil];
           

    }

}
// 限制textField只能输入字母和数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}

#pragma mark - textField结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1499) {
        if (textField.text.length > 7) {
            _enterButton.userInteractionEnabled = NO;
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"昵称不得长于7个字符";
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _tipLabel.hidden = YES;
            }];

        } else {
            _enterButton.userInteractionEnabled = NO;
            UserModel *userModel = [_userManager selectUser];
            if (nil == userModel.secret) {
                DDLogInfo(@"用户名可用");
            } else {
                _tipLabel.hidden = NO;
                _tipLabel.alpha = 1;
                _tipLabel.text = @"昵称已被占用";
                [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _tipLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    _tipLabel.hidden = YES;
                }];
            }
        }

    } else {
        _enterButton.userInteractionEnabled = YES;
    }
    if ((textField.tag == 1498) && (textField.text.length > 13)) {
        _enterButton.userInteractionEnabled = NO;
        _tipLabel.hidden = NO;
        _tipLabel.alpha = 1;
        _tipLabel.text = @"密码不得长于12个字符";
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _tipLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _tipLabel.hidden = YES;
        }];

    } else {
        _enterButton.userInteractionEnabled = YES;
    }
    if (textField.tag == 1500) {
        if ([textField.text integerValue] > 100 | [textField.text integerValue] < 0) {
            _enterButton.userInteractionEnabled = NO;
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确年龄";
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _tipLabel.hidden = YES;
            }];
        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
    if (textField.tag == 1501) {
        if ([textField.text integerValue] > 300 | [textField.text integerValue] < 100) {
            _enterButton.userInteractionEnabled = NO;
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确身高";
            
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _tipLabel.hidden = YES;
            }];
            
        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
    if (textField.tag == 1502) {
        if ([textField.text integerValue] > 300 | [textField.text integerValue] < 10) {
            _enterButton.userInteractionEnabled = YES;
            _tipLabel.hidden = NO;
            _tipLabel.alpha = 1;
            _tipLabel.text = @"请输入正确体重";
            [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _tipLabel.alpha = 0;
            } completion:^(BOOL finished) {
                _tipLabel.hidden = YES;
            }];
            
        } else {
            _enterButton.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - 键盘类型
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (1499 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    if (1498 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeAlphabet;
    }
    if (textField.tag == 1500) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (1501 == textField.tag | 1502 == textField.tag) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_nameTextField resignFirstResponder];
    [_secretTextField resignFirstResponder];
    [_ageTextField resignFirstResponder];
    [_tallTextField resignFirstResponder];
    [_weightTextField resignFirstResponder];
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
