//
//  WTRichTextClickVC.m
//  TotalDemo
//
//  Created by ocean on 2019/1/5.
//  Copyright © 2019年 wzt. All rights reserved.
//

#import "WTRichTextClickVC.h"
#import "WTWebViewVC.h"

@interface WTRichTextClickVC ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) MASConstraint *heightconstrain;

@end

@implementation WTRichTextClickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *content = @"这是一个网址http://www.jianshu.com/users/37f2920f6848 字符串！简书首页是用户进入简书后的默认页面，根据用户所关注的专题、作者，实时为用户推送最新的创作作品。\n除了有和用户兴趣最相关的作品推送以外，简书首页同时会为用户推荐热门的专题、创作者，帮助用户发现新的热门专题。\n这是一个网址http://www.jianshu.com/users/37f2920f6848字符串！简书首页是用户进入简书后的默认页面，根据用户所关注的专题、作者，实时为用户推送最新的创作作品。\n除了有和用户兴趣最相关的作品推送以外，简书首页同时会为用户推荐热门的专题、创作者，帮助用户发现新的热门专题。";
    
    //1.方法一
    NSString *htmlStr = @"http://www.jianshu.com/users/37f2920f6848";
    NSRange range = [content rangeOfString:htmlStr];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:content];
    [attrStr addAttribute:NSLinkAttributeName
                    value:htmlStr
                    range:NSMakeRange(range.location, range.length)];
    //self.textView.attributedText = attrStr;
    
    
    //2.方法二
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.text = content;
    
    
    //3.UITextView自适应高度
    CGSize size = [self.textView sizeThatFits:self.textView.frame.size];
    _heightconstrain.mas_equalTo(size.height);
    [self.view layoutIfNeeded];
}


-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    NSLog(@"url=%@", URL.absoluteString);

    WTWebViewVC *vc = [[WTWebViewVC alloc]init];
    vc.urlPath = URL.absoluteString;
    [self.navigationController pushViewController:vc animated:YES];

    return NO;
}

-(UITextView*)textView {
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.textColor = [UIColor blackColor];
        _textView.editable = NO;
        _textView.selectable = YES;
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
        _textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_textView];
        
        //UITextView自适应高度
        __weak typeof(self) weakSelf = self;
        _heightconstrain = nil;
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(15);
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            weakSelf.heightconstrain = make.height.mas_equalTo(MAXFLOAT);
        }];
    }
    return _textView;
}























//利用替换先把重复元素替换掉,再根据length长度做判断
- (NSInteger )getDuplicateSubStrCountInCompleteStr:(NSString *)completeStr withSubStr:(NSString *)subStr
{
    NSInteger subStrCount = [completeStr length] - [[completeStr stringByReplacingOccurrencesOfString:subStr withString:@""] length];
    return subStrCount / [subStr length];
}

//利用切分先得数组,再根据索引计算
- (NSMutableArray *)getDuplicateSubStrLocInCompleteStr:(NSString *)completeStr withSubStr:(NSString *)subStr
{
    NSArray * separatedStrArr = [completeStr componentsSeparatedByString:subStr];
    NSMutableArray * locMuArr = [[NSMutableArray alloc]init];
    
    NSInteger index = 0;
    for (NSInteger i = 0; i<separatedStrArr.count-1; i++) {
        NSString * separatedStr = separatedStrArr[i];
        index = index + separatedStr.length;
        NSNumber * loc_num = [NSNumber numberWithInteger:index];
        [locMuArr addObject:loc_num];
        index = index+subStr.length;
    }
    return locMuArr;
}

//正则匹配查找
-(void)regexSearchString {
    
    NSString *string = @"123 &1245; Ross Test 12 <url>http://www.baidu.com</url> 百度地址<url>http://www.baidu.com</url> \n百度地址<url>http://www.baidu.com</url>";
    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"&[^;]*;" options:NSRegularExpressionCaseInsensitive error:&error];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<url>*</url>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
    NSLog(@"%@", modifiedString);
}




@end
