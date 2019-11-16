//
//  ViewController.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "ViewController.h"
#import "TestVC2.h"
#import "WTGuidePage1VC.h"
#import "WTLogManager.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <NSDictionary*>*dataArray;

@property (nonatomic, copy) NSString *test;
@property (nonatomic, strong) TestVC2 *vc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.title = @"Hello world";
    //
    [self initData];
    
    NSArray * ary = nil;
    
    printf("Test: %d\n",(1 < ary.count-1));

    
    //assert(false);
    
    //[self regexSearchString];
    
    NSLog(@"堆栈信息: %@", [NSThread callStackSymbols]);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"ViewController view will appear...");
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"ViewController view did appear...");
}

//正则匹配查找
-(void)regexSearchString {
    
    NSString *string = @"<url>http://www.baidu.com</url> 百度地址<url>http://www.baidu.com</url> \n百度地址<url>http://www.baidu.com</url> 123 &1245; Ross Test 12 ";
    NSError *error = nil;
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"&[^;]*;" options:NSRegularExpressionCaseInsensitive error:&error];
    //    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/(\"[^\"]*\"|'[^']*')/" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSLog(@"%@", modifiedString);
}

#pragma mark init
-(void)initData {
    
    NSString *fileName = @"main.plist";
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray *datas = dataDic[@"datas"];
    [self.dataArray addObjectsFromArray:datas];
    [self.tableView reloadData];
}

#pragma mark actions
-(void)clickCellAction:(NSIndexPath*)idxPath {
    
    NSDictionary *dic = self.dataArray[idxPath.row];
    NSString *vcName = dic[@"vc"];
    if (vcName) {
        UIViewController *controller = [NSClassFromString(vcName) new];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(void)toNewGuideAction:(NSIndexPath*)idxPath {
    
    [BCNewGuidePageManager saveNewUserFirstToAddDevice:YES];
    WTGuidePage1VC *vc = [WTGuidePage1VC new];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    NSString *method = dic[@"method"];
    if (method) {
        SEL methodAction = NSSelectorFromString(method);
        if ([self respondsToSelector:methodAction]) {
            [self performSelector:methodAction withObject:indexPath afterDelay:0];
        }
    }else {
        
        //发送App打印日志到指定邮箱
        [[WTLogManager share]sendLogContentMailToMe:nil target:self];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}


#pragma mark set/get
-(UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(@0);
        }];
    }
    return _tableView;
}
-(NSMutableArray<NSDictionary*>*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
