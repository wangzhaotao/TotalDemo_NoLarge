//
//  WztSpecialCharactEncodeVC.m
//  TotalDemo
//
//  Created by ocean on 3/4/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WztSpecialCharactEncodeVC.h"

@interface WztSpecialCharactEncodeVC ()

@end

@implementation WztSpecialCharactEncodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    NSString *path = @"http://study.minshenglife.com:7100/api/v1/sso?openUser=2Xxad8F+IOEAHrt5K6Lm4w==&openPwd=/luuvx4Q0BQysuMKfE5dMA==曾仕林";
    NSString *encode = [self stringEncode:path];
    NSString *decode = [self stringDecode:encode];
    
    NSDictionary *dic = @{@"path":path};
    NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSDictionary *dictionary =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    
    NSLog(@"原字符串: %@", path);
    NSLog(@"encode字符串: %@", encode);
    NSLog(@"decode字符串: %@", decode);
    NSLog(@"原字典: %@", dic);
    NSLog(@"系统编码字典: %@", dictionary);
    NSLog(@"原字典-path: %@", dic[@"path"]);
    NSLog(@"系统编码字典-path: %@", dictionary[@"path"]);
}

- (NSString *)stringEncode:(NSString *)str {
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR("#%<>[\\]^`{|}\"]+"), kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)stringDecode:(NSString *)str {
    NSString *result = [(NSString *)str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end
