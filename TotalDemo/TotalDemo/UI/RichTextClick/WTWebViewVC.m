//
//  WTWebViewVC.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WTWebViewVC.h"
#import <WebKit/WebKit.h>

@interface WTWebViewVC ()<WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property (weak, nonatomic) CALayer *progresslayer;

@end

@implementation WTWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initUI];
    
    [self loadData];
}

#pragma mark loadData
-(void)loadData {
    
    if (_urlPath) {
        NSURL *url = [NSURL URLWithString:_urlPath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
}

#pragma mark initUI
-(void)initUI {
    
    self.webView = [[WKWebView alloc]init];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.navigationDelegate=self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    
    //进度条
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor =[iGlobalFocusColor colorWithAlphaComponent:1].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    
    UIView *topline=[[UIView alloc]init];
    topline.backgroundColor=iColor(0xe6, 0xe6, 0xe6, 1);
    [self.view addSubview:topline];
    
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@3);
        make.leading.top.trailing.equalTo(@0);
    }];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.leading.top.trailing.equalTo(@0);
    }];
    
    //根据语言环境清除缓存
    [self deleteWKWebCache_ByLanguage];
}

#pragma mark set/get
-(void)setUrlPath:(NSString *)urlPath {
    _urlPath = urlPath;
}

#pragma mark 根据语言环境清除缓存 - WKWebView
-(void)deleteWKWebCache_ByLanguage {
    
    NSString *languageKey = @"Device_Language_Setting";
    // 查看当前手机的语言环境
    NSArray *array = [NSLocale preferredLanguages];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *localLanguageArray = [userDefault valueForKey:languageKey];
    //更新本地缓存
    [userDefault setObject:array forKey:languageKey];
    //比较语言设置
    if (localLanguageArray && localLanguageArray.count>0) {
        if (array && array.count>0) {
            NSString *language = array[0];
            NSString *localLanguage = localLanguageArray[0];
            if ([localLanguage isEqualToString:language]) {
                return;
            }
        }
    }
    //清除
    [self deleteWebCache];
}
// - html语言本地化
- (void)deleteWebCache {
    //allWebsiteDataTypes清除所有缓存
    //磁盘缓存、内存缓存、本地存储、会话存储、cookies、IndexedDB数据库、查询数据库
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
    }];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // 获取完整url并进行UTF-8转码
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strRequest hasPrefix:@"app://"]) {
        // 拦截点击链接
        
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progresslayer.frame = CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 3);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progresslayer.opacity = 0;
    });
    
    //获取加载到的网页内容
    //    NSString *doc = @"document.body.outerHTML";
    //    [self.webView evaluateJavaScript:doc
    //                     completionHandler:^(id _Nullable htmlStr, NSError * _Nullable error) {
    //                         if (error) {
    //                             NSLog(@"JSError:%@",error);
    //                         }
    //                         NSLog(@"html:%@",htmlStr);
    //                     }] ;
}

#pragma mark 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progresslayer.opacity = 1;
        NSLog(@"progress:%f", self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue]);
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
