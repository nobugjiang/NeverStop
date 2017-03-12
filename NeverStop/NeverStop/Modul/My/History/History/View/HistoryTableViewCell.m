//
//  HistoryTableViewCell.m
//  NeverStop
//
//  Created by DYQ on 16/11/1.
//  Copyright © 2016年 JDT. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UILabel *speedSettingLabel;
@property (nonatomic, strong) UIImageView *durationImageView;
@property (nonatomic, strong) UIImageView *speedSettingImageView;

@end

@implementation HistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 50, 50)];
        _typeImageView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
        _typeImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _typeImageView.layer.shadowOffset = CGSizeMake(2, 2);
        _typeImageView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        _typeImageView.layer.shadowRadius = 4;//阴影半径
        _typeImageView.layer.cornerRadius = _typeImageView.width / 2;
        [self.contentView addSubview:_typeImageView];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _typeImageView.y + _typeImageView.height, 90, 30)];
        _dateLabel.text = @"30日晚上";
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = kFONT_SIZE_15;
        _dateLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_dateLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_typeImageView.x + _typeImageView.width + 15, 25, 100, 50)];
        _distanceLabel.text = @"29.25";
        _distanceLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:40];
        [_distanceLabel sizeToFit];
        [self.contentView addSubview:_distanceLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_distanceLabel.x + _distanceLabel.width + 10, _distanceLabel.y + _distanceLabel.height - 30, 50, 30)];
        textLabel.text = @"公里";
        textLabel.font = kFONT_SIZE_18_BOLD;
        [self.contentView addSubview:textLabel];
        
        self.durationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2 + 30, 25, 20, 20)];
        _durationImageView.image = [UIImage imageNamed:@"time"];
        [self.contentView addSubview:_durationImageView];
        
        
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_durationImageView.x + _durationImageView.width + 5, _durationImageView.y, 120, _durationImageView.height)];
        _durationLabel.text = @"25:35:59";
        _durationLabel.textColor = [UIColor grayColor];
        _durationLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_durationLabel];
        
        self.speedSettingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * 2 + 30, _durationImageView.y + _durationImageView.height + 15, 20, 20)];
        _speedSettingImageView.image = [UIImage imageNamed:@"speed"];
        [self.contentView addSubview:_speedSettingImageView];
        
        
        self.speedSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_speedSettingImageView.x + _speedSettingImageView.width + 5, _speedSettingImageView.y, 120, _speedSettingImageView.height)];
        _speedSettingLabel.text = @"25:35:59";
        _speedSettingLabel.textColor = [UIColor grayColor];
        _speedSettingLabel.font = kFONT_SIZE_13;
        [self.contentView addSubview:_speedSettingLabel];
        
        
    }
    return self;
}
- (void)setExerciseData:(ExerciseData *)exerciseData {
    if (_exerciseData != exerciseData) {
        _exerciseData = exerciseData;
    }
    _typeImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"type_%@", _exerciseData.exerciseType]];
    _speedSettingLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.averageSpeedSetting];
    NSArray *array = [_exerciseData.startTime componentsSeparatedByString:@" "];
    NSString *datedayStr = [array.firstObject substringFromIndex:8];
    NSInteger dateHour = [[array.lastObject substringToIndex:2] intValue];
    if ( dateHour >= 6 && dateHour < 12) {
        _dateLabel.text = [NSString stringWithFormat:@"%@上午", datedayStr];
    } else if (dateHour >= 12 && dateHour < 18) {
        _dateLabel.text = [NSString stringWithFormat:@"%@下午", datedayStr];

    } else if (dateHour >= 18 && dateHour <= 23) {
        _dateLabel.text = [NSString stringWithFormat:@"%@晚上", datedayStr];

    } else {
        _dateLabel.text = [NSString stringWithFormat:@"%@凌晨", datedayStr];
    }
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f", _exerciseData.distance];
    NSString *durationStr = [NSString stringWithFormat:@"%.2f", _exerciseData.duration];
    NSInteger sec;
    NSInteger minu;
    NSInteger hour;
    sec = [durationStr integerValue] % 60;
    minu = ([durationStr integerValue] / 60)% 60;
    hour = [durationStr integerValue] / 3600;
    
    _durationLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld", hour, minu, sec];
    NSInteger timeSpeedSetting = (int)_exerciseData.averageSpeedSetting;
    NSInteger secSpeedSetting;
    NSInteger minuSpeedSetting;
    secSpeedSetting = timeSpeedSetting % 60;
    minuSpeedSetting = timeSpeedSetting / 60;
    _speedSettingLabel.text = [NSString stringWithFormat:@"%ld'%ld\"", minuSpeedSetting, secSpeedSetting];
   
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
