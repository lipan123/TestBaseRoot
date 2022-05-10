//
//  HomePageViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "HomePageViewController.h"
#import "lpppViewController.h"
#import "DynamicViewController.h"
#import "MessageBtnViewController.h"
#import "MenuViewController.h"

#import "TableVieCellModel.h"

static NSString *Identifier = @"IdentifierCell";

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"王薇薇";
    //加载自定义的导航栏
    [self setupNavView];
    //设置角标
    [self setTabBarBadgeValue:@"12" withIndex:0];
    //设置tableview
    [self.dataArray addObject:[TableVieCellModel initTitle:@"测试视频播放" withViewController:@"lpppViewController"]];
    [self.dataArray addObject:[TableVieCellModel initTitle:@"测试cell高度自适应" withViewController:@"DynamicViewController"]];
    [self.dataArray addObject:[TableVieCellModel initTitle:@"测试内容为按钮的弹窗" withViewController:@"MessageBtnViewController"]];
    [self.dataArray addObject:[TableVieCellModel initTitle:@"测试菜单" withViewController:@"MenuViewController"]];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(-tabarHeight));
    }];
    
    [[RACObserve(self.navigationItem, title) take:2] subscribeNext:^(id  _Nullable x) {
            if (x) {
                NSLog(@"123");
            }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //隐藏自带的导航栏
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupNavView{
    self.naviView.backgroundColor = [UIColor orangeColor];
    [self.naviView.centerButton setTitle:@"自定首页" forState:UIControlStateNormal];
    [self.naviView.leftButton setTitle:@"左边" forState:UIControlStateNormal];
    CGSize sizeThatFits = [self.naviView.leftButton sizeThatFits:CGSizeZero];
    [self.naviView.leftButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sizeThatFits.width);
        make.height.mas_equalTo(sizeThatFits.height);
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableVieCellModel *model = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.textLabel.text = model.title;
    return cell;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableVieCellModel *model = self.dataArray[indexPath.row];
    UIViewController *controller = [[NSClassFromString(model.viewController) alloc] init];
    if ([controller isKindOfClass:[lpppViewController class]]) {
        lpppViewController *vc = (lpppViewController *)controller;
        vc.isLandScape = NO;     //如果general中设置了支持自动旋转,负值为yes
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = 44.0f;
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
