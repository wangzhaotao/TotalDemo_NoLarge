//
//  WTRefreshTableVC.m
//  TotalDemo
//
//  Created by tyler on 11/14/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTRefreshTableVC.h"
#import <MJRefresh/MJRefresh.h>
#import "WTRefreshHeader.h"
#import "WTGifRefreshHeader.h"

#define KMainScreenWidth     [UIScreen mainScreen].bounds.size.width
#define KMainScreenWHeight   [UIScreen mainScreen].bounds.size.height


@interface WTRefreshTableVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *gifView;

@end


@implementation WTRefreshTableVC

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    [self initData];
    
    [self createRefreshHead2];
    
    
}

#pragma mark refresh
-(void)createRefreshHead3 {
    //模拟下拉刷新
    WTGifRefreshHeader *header = [WTGifRefreshHeader headerWithRefreshingBlock:^{
        [self toRefreshWiFiListData];
    }];
    self.tableView.mj_header = header;
}
-(void)createRefreshHead2 {
    
    //模拟下拉刷新
    WTRefreshHeader *header = [WTRefreshHeader headerWithRefreshingBlock:^{
        [self toRefreshWiFiListData];
    }];
    self.tableView.mj_header = header;
}

-(void)createRefreshHead1 {
    self.tableView.mj_header = [self commonMJHeaderWithTar:self action:@selector(toRefreshWiFiListData)];
}
-(MJRefreshNormalHeader *)commonMJHeaderWithTar:(id)tar action:(SEL)sel{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingTarget:tar refreshingAction:sel];
    
    header.stateLabel.font = iFont(14);
    header.lastUpdatedTimeLabel.font = iFont(12);
    header.stateLabel.textColor = [UIColor grayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    return header;
}




#pragma mark data
-(void)toRefreshWiFiListData {
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<5; i++) {
            [weakSelf.dataArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    });
}

-(void)initData {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    for (int i=0; i<5; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"这是第 %ld 行cell", indexPath.row+1];
    
    return cell;
}


#pragma mark initUI
-(void)initUI {
    
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
    //
    UIImageView *gifView = [[UIImageView alloc]init];
    [self.view addSubview:gifView];
    _gifView = gifView;
    [self testAnimation];
    
    
    
    
    //layout
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(@0);
        make.height.equalTo(@(3*KMainScreenWHeight/4));
    }];
    [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(tableView.mas_bottom).offset(5);
        make.width.height.equalTo(@(KMainScreenWidth/4));
    }];
}

-(void)testAnimation {
    
    //UIImageView播放数组动画
    self.gifView.animationImages= [self loadAnimationImages];
    self.gifView.animationDuration = 0.4 ;
    self.gifView.animationRepeatCount = MAXFLOAT;
    [self.gifView startAnimating];
}

-(NSArray<UIImage*>*)loadAnimationImages {
    
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"animation" ofType:@"gif"];

    //获取gif文件数据

    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:dataPath], NULL);

    //获取gif文件中图片的个数

    size_t count =CGImageSourceGetCount(source);

    //存放所有图片数组

    NSMutableArray <UIImage*>*imageArray = [[NSMutableArray alloc] init];

    //遍历gif

    for(int i=0; i<count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        UIImage* img = [UIImage imageWithCGImage: image];
        [imageArray addObject:img];
    }
    
    return imageArray;
}



@end
