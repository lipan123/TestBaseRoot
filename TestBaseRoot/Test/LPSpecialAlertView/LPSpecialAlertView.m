//
//  LPSpecialAlertView.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/1/7.
//

#import "LPSpecialAlertView.h"

@implementation LPSpecialAlertView

+(instancetype)alertViewWithTitle:(NSString *)title messageBtn:(NSArray *)messageBtns otherBtn:(NSArray *)otherBtns{
    LPSpecialAlertView *alertView = [[LPSpecialAlertView alloc] init];
    alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = kFitW(12);
    [alertView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(kFitW(302));
        make.height.mas_equalTo(kFitW(214));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:kFitW(18)];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentView.mas_top).offset(kFitW(19));
        make.centerX.mas_offset(0);
    }];
    
    if (messageBtns.count == 1) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 2000;
        btn.layer.cornerRadius = kFitW(16.5);
        btn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:35/255.0 alpha:1.0].CGColor;
        btn.layer.borderWidth = 0.5;
        [btn setTitle:messageBtns[0] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:255/255.0 green:96/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn addTarget:alertView action:@selector(messageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(kFitW(125));
            make.height.mas_equalTo(kFitW(33));
        }];
    }else if (messageBtns.count == 2) {
        UIButton *btn1 = [[UIButton alloc] init];
        btn1.tag = 2000;
        btn1.layer.cornerRadius = kFitW(16.5);
        btn1.layer.borderColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:35/255.0 alpha:1.0].CGColor;
        btn1.layer.borderWidth = 0.5;
        [btn1 setTitle:messageBtns[0] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithRed:255/255.0 green:96/255.0 blue:35/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn1 addTarget:alertView action:@selector(messageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(kFitW(20));
            make.width.mas_equalTo(kFitW(125));
            make.height.mas_equalTo(kFitW(33));
        }];
        
        UIButton *btn2 = [[UIButton alloc] init];
        btn2.tag = 2000+1;
        btn2.layer.cornerRadius = kFitW(16.5);
        btn2.backgroundColor = [UIColor colorWithRed:255/255.0 green:119/255.0 blue:37/255.0 alpha:1.0];
        [btn2 setTitle:messageBtns[1] forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn2 addTarget:alertView action:@selector(messageBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(btn1.mas_bottom).offset(kFitW(20));
            make.width.mas_equalTo(kFitW(125));
            make.height.mas_equalTo(kFitW(33));
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(-kFitW(40));
    }];
    
    for (NSInteger i= 0; i<otherBtns.count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 2000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:kFitW(16)];
        [btn setTitle:otherBtns[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:alertView action:@selector(otherBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*kFitW(302)/otherBtns.count);
            make.top.mas_equalTo(lineView.mas_bottom);
            make.bottom.mas_equalTo(contentView.mas_bottom);
            make.width.mas_equalTo(kFitW(302)/otherBtns.count);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(btn);
            make.width.mas_equalTo(0.5);
            make.left.mas_equalTo(i*kFitW(302)/otherBtns.count);
        }];
        if (i==0) {
            lineView.hidden = YES;
        }
    }
    
    return alertView;
}

- (void)addToFatherView:(UIView *)view{
    self.frame = view.bounds;
    [view addSubview:self];
}

#pragma mark - btnpress
- (void)messageBtnPressed:(UIButton *)sender{
    if (self.messageBtnBlock) {
        self.messageBtnBlock(sender.tag-2000);
    }
    [self removeFromSuperview];
}

- (void)otherBtnPressed:(UIButton *)sender{
    if (self.otherBtnBlock) {
        self.otherBtnBlock(sender.tag-2000);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
