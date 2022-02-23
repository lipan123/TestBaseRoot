//
//  MenuScrollView.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/1/19.
//

#import "MenuScrollView.h"

@implementation MenuScrollView

-(id)initWithFrame:(CGRect)frame MenuData:(NSArray *)arr MenuSize:(CGSize)size ScrollDirection:(ScrollDirection)direction MenusInLine:(NSInteger)numLine MenuInList:(NSInteger)numList MenuDelegate:(id)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        NumInLine = numLine;
        NumInList = numList;
        MenuSize = size;
        MenuCount = arr.count;
        self.arr_DataSource = arr;
        self.scrolldirection = direction;
        self.delegate = delegate;
        [self InitControls];
    }
    return self;
}

-(void)InitControls{
    CGFloat v_width = 0;
    CGFloat v_height = 0;
    NSInteger z= MenuCount%NumInLine==0?MenuCount/NumInLine:MenuCount/NumInLine+1;
    
    if (self.scrolldirection == Horizontal) { //水平
        v_width= CGRectGetWidth(self.frame)/NumInLine;
        v_height= CGRectGetHeight(self.frame)/NumInList;
        z =MenuCount%(NumInList)==0?MenuCount/(NumInList):MenuCount/(NumInList)+1;  //几列
        
        if (scrollView == nil) {
            scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        }
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(v_width*z, self.frame.size.height);
        scrollView.alwaysBounceVertical = NO;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        for (int i = 0; i< MenuCount; i++) {
            
            CGFloat vx = 0;
            CGFloat vy = 0;
            if (i<=(NumInLine*NumInList-1)) {
                int j = i/NumInLine;    //行
                int k = i%NumInLine;  //列
                vx = 0 + k*v_width;
                vy = 0 + j*v_height;
            }else {
                int j = i/NumInList;    //列
                int k = i%NumInList;  //行
                vx = 0 + j*v_width;
                vy = 0 + k*v_height;
            }
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(vx, vy, v_width, v_height)];
            view.backgroundColor = [UIColor clearColor];
            
            //imgeview
            UIImageView *imgView = [[UIImageView alloc] init];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.width.mas_equalTo(MenuSize.width);
                make.height.mas_equalTo(MenuSize.height);
            }];
            //lab
            UILabel * lab = [[UILabel alloc] init];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:kFitW(12)];
            [lab setBackgroundColor:[UIColor clearColor]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imgView.mas_bottom).offset(kFitW(8));
                make.left.right.mas_equalTo(0);
            }];
            
            //big Button
            UIButton * bigbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bigbtn.frame = view.bounds;
            bigbtn.tag = i;
            [bigbtn setBackgroundColor:[UIColor clearColor]];
            [bigbtn addTarget:self action:@selector(MenuBtnAction:) forControlEvents:UIControlEventTouchDown];
            [view addSubview:bigbtn];
            
            if (self.arr_DataSource.count>0) {
                MenuModel *model = (MenuModel *)self.arr_DataSource[i];
                if ([model.imgNameOrUrl hasPrefix:@"http"]) {
                    
                }else {
                    imgView.image = [UIImage imageNamed:model.imgNameOrUrl];
                }
                NSString *str = [NSString stringWithFormat:@"%@",model.title];
                [lab setText:str];
            }
            [scrollView addSubview:view];
        }
        
    }else if (self.scrolldirection == Vertical){ //纵向
        v_width= CGRectGetWidth(self.frame)/NumInLine;
        v_height= CGRectGetHeight(self.frame)/NumInList;
        
        if (scrollView == nil) {
            scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        }
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(self.frame.size.width, z*v_height);
        scrollView.alwaysBounceVertical = NO;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        for (int i = 0; i< MenuCount; i++) {
            
            CGFloat vx = 0;
            CGFloat vy = 0;
            int j = i/NumInLine;    //行
            int k = i%NumInLine;  //列
            vx = 0 + k*v_width;
            vy = 0 + j*v_height;
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(vx, vy, v_width, v_height)];
            view.backgroundColor = [UIColor clearColor];
            
            //imgeview
            UIImageView *imgView = [[UIImageView alloc] init];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.width.mas_equalTo(MenuSize.width);
                make.height.mas_equalTo(MenuSize.height);
            }];
            //lab
            UILabel * lab = [[UILabel alloc] init];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:kFitW(12)];
            [lab setBackgroundColor:[UIColor clearColor]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imgView.mas_bottom).offset(kFitW(8));
                make.left.right.mas_equalTo(0);
            }];
            
            //big Button
            UIButton * bigbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bigbtn.frame = view.bounds;
            bigbtn.tag = i;
            [bigbtn setBackgroundColor:[UIColor clearColor]];
            [bigbtn addTarget:self action:@selector(MenuBtnAction:) forControlEvents:UIControlEventTouchDown];
            [view addSubview:bigbtn];
            
            if (self.arr_DataSource.count>0) {
                MenuModel *model = (MenuModel *)self.arr_DataSource[i];
                if ([model.imgNameOrUrl hasPrefix:@"http"]) {
                    //网络加载
                }else {
                    imgView.image = [UIImage imageNamed:model.imgNameOrUrl];
                }
                NSString *str = [NSString stringWithFormat:@"%@",model.title];
                [lab setText:str];
            }
            [scrollView addSubview:view];
        }
        
    }else{ //不翻页
        v_width = self.frame.size.width/NumInLine;
        v_height = self.frame.size.height/z;
        
        for (int i = 0; i< MenuCount; i++) {
            CGFloat vx = 0;
            CGFloat vy = 0;
            
            int j = i/NumInLine;    //行
            int k = i%NumInLine;            //列
            vx = 0 + k*v_width;
            vy = 0 + j*v_height;
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(vx, vy, v_width, v_height)];
            view.backgroundColor = [UIColor clearColor];
            
            //imgeview
            UIImageView *imgView = [[UIImageView alloc] init];
            [view addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(0);
                make.width.mas_equalTo(MenuSize.width);
                make.height.mas_equalTo(MenuSize.height);
            }];
            //lab
            UILabel * lab = [[UILabel alloc] init];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:kFitW(12)];
            [lab setBackgroundColor:[UIColor clearColor]];
            [lab setTextAlignment:NSTextAlignmentCenter];
            [view addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imgView.mas_bottom).offset(kFitW(8));
                make.left.right.mas_equalTo(0);
            }];
            
            //big Button
            UIButton * bigbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bigbtn.frame = view.bounds;
            bigbtn.tag = i;
            [bigbtn setBackgroundColor:[UIColor clearColor]];
            [bigbtn addTarget:self action:@selector(MenuBtnAction:) forControlEvents:UIControlEventTouchDown];
            [view addSubview:bigbtn];
            
            if (self.arr_DataSource.count>0) {
                MenuModel *model = (MenuModel *)self.arr_DataSource[i];
                if ([model.imgNameOrUrl hasPrefix:@"http"]) {
                    //网络加载
                }else {
                    imgView.image = [UIImage imageNamed:model.imgNameOrUrl];
                }
                NSString *str = [NSString stringWithFormat:@"%@",model.title];
                [lab setText:str];
            }
            [self addSubview:view];
        }
    }

}

-(void)reloadMenuData:(NSArray *)arr{
    self.arr_DataSource = arr;
    MenuCount = arr.count;
    //移除所有子view
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    [self InitControls];
}

-(void)MenuBtnAction:(id)sender{
    UIButton * btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(BtnPressWithTag:)]) {
        [self.delegate BtnPressWithTag:btn.tag];
    }
}

@end
