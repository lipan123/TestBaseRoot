//
//  DynamicCell.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/25.
//

#import "DynamicCell.h"

@interface DynamicCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation DynamicCell

- (void)setDynamicModel:(DynamicCellModel *)dynamicModel{
    self.imgView.image = [UIImage imageNamed:dynamicModel.imgName];
    self.titleLabel.text = dynamicModel.titleString;
    self.tipsLabel.text = dynamicModel.tipsString;
    
    BOOL x=YES;
    x = dynamicModel.titleString.length == 0 ? NO:YES;
    BOOL y = YES;
    y = dynamicModel.tipsString.length == 0 ? NO:YES;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(x?kFitW(8):0);
    }];
    [self.tipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(y?@(-10):@(0));
    }];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIView *backgroudView = [[UIView alloc] init];
    backgroudView.backgroundColor = [UIColor whiteColor];
    backgroudView.layer.cornerRadius = 5;
    [self.contentView addSubview:backgroudView];
    
    [backgroudView addSubview:self.imgView];
    [backgroudView addSubview:self.titleLabel];
    [backgroudView addSubview:self.lineView];
    [backgroudView addSubview:self.tipsLabel];

    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroudView);
        make.left.right.equalTo(backgroudView);
        make.height.mas_equalTo(kFitW(100));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imgView.mas_bottom).offset(kFitW(8));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(kFitW(8));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.height.equalTo(@(1));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_lineView.mas_bottom).offset(kFitW(8));
        make.left.equalTo(@(10));
        make.right.equalTo(@(-10));
        make.bottom.equalTo(@(-10));
    }];
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:kFitW(18)];
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.font = [UIFont systemFontOfSize:kFitW(15)];
    }
    return _tipsLabel;
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
