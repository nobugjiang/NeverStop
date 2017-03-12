//
//  TargetViewController.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "TargetViewController.h"
//#import "TargetManager.h"
//#import "TargetModel.h"


@interface TargetViewController ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>
@property (nonatomic, strong) UIPickerView *targetPickerView;
@property (nonatomic, strong) NSMutableArray *selectArr;
@property (nonatomic, strong) UILabel *targetLabel;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) TargetManager *targetManager;
@property (nonatomic, strong) TargetModel *targetModel;
@property (nonatomic, strong) NSArray *getTargetArray;

@end

@implementation TargetViewController

- (void)viewWillAppear:(BOOL)animated {
    [_targetManager openSQLite];
    self.getTargetArray = [_targetManager selectTarget];
    if (_getTargetArray.count != 0) {
        self.targetModel = [_getTargetArray lastObject];
        self.selectedRow = _targetModel.row;
        [_targetPickerView selectRow:_selectedRow inComponent:0 animated:YES];
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    UIBarButtonItem *backItem = [UIBarButtonItem getBarButtonItemWithImageName:@"navigator_btn_back" HighLightedImageName:nil targetBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.targetManager = [TargetManager shareTargetManager];
    [_targetManager openSQLite];
    [_targetManager createTable];
    self.getTargetArray = [_targetManager selectTarget];

    if (_getTargetArray.count != 0) {
        self.targetModel = [_getTargetArray lastObject];
        self.selectedRow = _targetModel.row;
    } else {
        self.selectedRow = 9;
    }

 
    self.selectArr = [NSMutableArray array];
    for (int i = 1; i < 101; i++) {
        NSString *selectString = [NSString stringWithFormat:@"%d步", i * 1000];
        [_selectArr addObject:selectString];
    }
    
    self.targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    if (_getTargetArray.count == 0) {
        _targetLabel.text = @"10000步";
    } else {
        _targetLabel.text = _targetModel.target;
    }
    _targetLabel.font = kFONT_SIZE_24_BOLD;
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_targetLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, _targetLabel.height - 30, 100, 30)];
    textLabel.text = @"运动目标";
    textLabel.font = kFONT_SIZE_12;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor grayColor];
    [_targetLabel addSubview:textLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _targetLabel.y + _targetLabel.height, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:lineLabel];
    
    self.targetPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, _targetLabel.y + _targetLabel.height - 60, SCREEN_WIDTH, 500)];
    _targetPickerView.delegate = self;
    _targetPickerView.dataSource = self;
    _targetPickerView.showsSelectionIndicator = YES;
    if (_getTargetArray.count == 0) {
        [_targetPickerView selectRow:9 inComponent:0 animated:YES];
    } else {
        [_targetPickerView selectRow:_selectedRow inComponent:0 animated:YES];
    }
    [self.view addSubview:_targetPickerView];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, _targetPickerView.y + _targetPickerView.height - 30, 80, 40);
    confirmButton.backgroundColor = [UIColor blueColor];
    confirmButton.layer.cornerRadius = 5.f;
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];

}

- (void)confirmButtonAction{
    [_targetManager insertIntoTarget:_targetLabel.text row:_selectedRow];
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 140;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _selectArr.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return _selectArr[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _targetLabel.text = _selectArr[row];
    self.selectedRow = row;
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
