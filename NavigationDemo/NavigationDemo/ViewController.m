//
//  ViewController.m
//  NavigationDemo
//
//  Created by Meng Fan on 2017/5/25.
//  Copyright © 2017年 Haowan. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"

#define     kWidth      [UIScreen mainScreen].bounds.size.width
#define     kHeight     [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;

//自定义导航栏
@property (nonatomic, strong) UIView            *navigationView;
//Nav
@property (nonatomic, strong) UIImageView       *navBgImgView;
@property (nonatomic, strong) UIButton          *settingButton;
@property (nonatomic, strong) UILabel           *titleLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self resetNav];
}

#pragma mark - setupViews
//重设导航栏
- (void)resetNav {
    
    //设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    //设置自定义导航栏
    [self.view addSubview:self.navigationView];
    [self.navigationView addSubview:self.navBgImgView];
    [self.navigationView addSubview:self.titleLabel];
    [self.navigationView addSubview:self.settingButton];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.frame = CGRectMake((kWidth-100)/2, 64-28-10, 100, 28);
    self.settingButton.frame = CGRectMake(kWidth-20-20, 64-10-20, 20, 20);
    
    /*
    //Masonry
    MPWeakSelf(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        MPStrongSelf(self);
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        MPStrongSelf(self);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
     */
}


- (void)setupViews {
    [self.view addSubview:self.tableView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    return cell;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //初始值-20,往上滑 > -20;
    CGFloat alpha;
    
    //这里的300意思是滑动300距离的时候完全不透明，可以调节
    CGFloat offsetY = 300;
    CGPoint point = self.tableView.contentOffset;
    alpha =  point.y/offsetY;
    alpha = (alpha <= 0) ? 0 : alpha;
    alpha = (alpha >= 1) ? 1 : alpha;
    
    self.navBgImgView.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.navigationView.backgroundColor = [UIColor colorWithRed:(236)/255.0 green:(59)/255.0 blue:(59)/255.0 alpha:alpha];
}

#pragma mark - action
- (void)settingAction {
    
    NSLog(@"setting");
    SettingViewController *vc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - lazyLoading
-(UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
        headerView.image = [UIImage imageNamed:@"header_bg"];
        _tableView.tableHeaderView = headerView;
    
    }
    return _tableView;
}

-(UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
        _navigationView.backgroundColor = [UIColor colorWithRed:(236)/255.0 green:(59)/255.0 blue:(59)/255.0 alpha:0.0];
    }
    return _navigationView;
}

-(UIImageView *)navBgImgView {
    if (!_navBgImgView) {
        _navBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
        
        _navBgImgView.image = [UIImage imageNamed:@"Nav"];
        _navBgImgView.alpha = 0;
    }
    return _navBgImgView;
}

-(UIButton *)settingButton {
    if (!_settingButton) {
        
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        
        _settingButton.frame = CGRectMake(0, 0, 20, 20);
        [_settingButton addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _settingButton;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的";
        _titleLabel.alpha = 0.0f;
        [_titleLabel sizeToFit];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _titleLabel;
}




#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
