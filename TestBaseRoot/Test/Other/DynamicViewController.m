//
//  DynamicViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/2/28.
//

#import "DynamicViewController.h"
#import "DynamicCellModel.h"
#import "DynamicCell.h"

@interface DynamicViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *imgArray = @[@"drinksCate",@"boozeCate",@"washCate"];
    NSArray *titleArray = @[@"本呢么么么么么可可可可可",@"",@"库斯库斯卡卡卡卡萨卡卡卡卡卡卡卡卡卡卡卡卡卡卡卡卡卡据萨达阿松就啊时空阿萨德卡上的卡刷卡卡卡卡刷卡刷卡刷卡卡萨卡"];
    NSArray *tipsArray = @[@"啊啊啊啊啊啊啊",@"222卡斯萨卡斯啦咔咔咔咔咔咔咔咔咔咔咔咔咔咔",@""];

    [imgArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DynamicCellModel *model = [[DynamicCellModel alloc] init];
        model.imgName = obj;
        model.titleString = titleArray[idx];
        model.tipsString = tipsArray[idx];
        [self.dataArray addObject:model];
    }];
    NSLog(@"-----------%@",self.dataArray);
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(-tabarHeight));
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DynamicCellModel *model = self.dataArray[indexPath.section];
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    cell.dynamicModel = model;
    return cell;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 100;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[DynamicCell class] forCellReuseIdentifier:@"DynamicCell"];
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
