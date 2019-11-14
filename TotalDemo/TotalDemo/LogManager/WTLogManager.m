//
//  WTLogManager.m
//  LogToLocalDemo
//
//  Created by wztMac on 2019/5/25.
//  Copyright © 2019 wztMac. All rights reserved.
//

#import "WTLogManager.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

//记得处理之前之前的崩溃操作，因为可能其它框架以环境在处理异常
static NSUncaughtExceptionHandler *_previousHandler;

@interface WTLogManager () <MFMailComposeViewControllerDelegate>
@property (nonatomic, copy) NSString *logPath;
@property (nonatomic, strong) UIViewController *target;

@end

@implementation WTLogManager

+(instancetype)share {
    static WTLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WTLogManager alloc]init];
    });
    return instance;
}
-(instancetype)init {
    if (self = [super init]) {
        _logPath = createLogFileName();
    }
    return self;
}

-(void)initRedirectLogToFile {
    
    // Override point for customization after application launch.
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"model:%@ name:%@",[device model], [device name]);
    if ([[device model] isEqualToString:@"iPhone"] || [[device model] isEqualToString:@"iPad"]) {
        [self redirectNSLogToDocumentFolder];
    }
    NSLog(@"NSLog重定向测试");
}

- (void)sendLogContentMailToMe:(NSString*)logPath1 target:(UIViewController*)target {
    
    NSString *logPath = logPath1;
    if (!logPath) {
        logPath = _logPath;
    }
    
    NSString *logData = [[NSString alloc]initWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:nil];
    if (logData)
    {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        if(mailCompose)
        {
            //设置代理
            [mailCompose setMailComposeDelegate:self];
            
            NSArray *toAddress = [NSArray arrayWithObject:@"wzt1229@126.com"];
            NSArray *ccAddress = [NSArray arrayWithObject:@"tyler.wang@anker.com"];;
            NSString *emailBody = @"<H1>日志信息</H1>";
            
            //设置收件人
            [mailCompose setToRecipients:toAddress];
            //设置抄送人
            [mailCompose setCcRecipients:ccAddress];
            //设置邮件内容
            [mailCompose setMessageBody:emailBody isHTML:YES];
            
            NSData* pData = [[NSData alloc]initWithContentsOfFile:logPath];
            
            //设置邮件主题
            NSString *dateStr = [self getCurrentTimeString];
            NSString *title = [NSString stringWithFormat:@"App打印日志-%@", dateStr];
            [mailCompose setSubject:title];
            //设置邮件附件{mimeType:文件格式|fileName:文件名}
            NSString *fileName = [NSString stringWithFormat:@"%@.log", title];
            [mailCompose addAttachmentData:pData mimeType:@"txt" fileName:fileName];
            //设置邮件视图在当前视图上显示方式
            _target = target;
            [target presentViewController:mailCompose animated:YES completion:nil];
        }
        return;
    }
}

#pragma mark delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *msg;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            [self alertWithTitle:nil msg:msg];
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            [self alertWithTitle:nil msg:msg];
            [self removeLog];
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            [self alertWithTitle:nil msg:msg];
            break;
        default:
            break;
    }
    
    [_target dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark private methods
-(void)removeLog {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:_logPath]) {
        NSError *removeError = nil;
        [fileManager removeItemAtPath:_logPath error:&removeError];
        if (!removeError) {
            NSLog(@"删除文件成功");
        }
    }
}

- (void)alertWithTitle:(NSString *)title  msg:(NSString *)msg {
    if (title && msg) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)redirectNSLogToDocumentFolder {
    
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]) { //在模拟器不保存到文件中
        return;
    }
    
    NSString *logFilePath = _logPath;
    NSLog(@"打印日志path: %@", logFilePath);
    // 将log输入到文件
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    
    //记得处理之前之前的崩溃操作，因为可能其它框架以环境在处理异常
    static NSUncaughtExceptionHandler *_previousHandler;
    _previousHandler = NSGetUncaughtExceptionHandler();
    //未捕获的Objective-C异常日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

void UncaughtExceptionHandler(NSException* exception) {
    
    //处理之前的异常处理
    _previousHandler(exception);
    
    //自定义异常处理操作
    NSString* name = [ exception name ];
    NSString* reason = [ exception reason ];
    NSArray* symbols = [ exception callStackSymbols ]; // 异常发生时的调用栈
    NSMutableString* strSymbols = [ [ NSMutableString alloc ] init ]; //将调用栈拼成输出日志的字符串
    for ( NSString* item in symbols )
    {
        [ strSymbols appendString: item ];
        [ strSymbols appendString: @"\r\n" ];
    }
    
    //错误详情
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *crashString = [NSString stringWithFormat:@"<- %@ ->[ Uncaught Exception ]\r\nName: %@, Reason: %@\r\n[ Fe Symbols Start ]\r\n%@[ Fe Symbols End ]\r\n\r\n", dateStr, name, reason, strSymbols];
    
    //将crash日志保存到Document目录下的Log文件夹下
    NSString *logFilePath = createLogFileName();//[logDirectory stringByAppendingPathComponent:@"UncaughtException.log"];
    NSLog(@"崩溃日志path: %@", logFilePath);
    //把错误日志写到文件中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logFilePath]) {
        [crashString writeToFile:logFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        [outFile seekToEndOfFile];
        [outFile writeData:[crashString dataUsingEncoding:NSUTF8StringEncoding]];
        [outFile closeFile];
    }
}

NSString* createLogFileName() {
    
    //将NSlog打印信息保存到Document目录下的Log文件夹下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
    if (!fileExists) {
        [fileManager createDirectoryAtPath:logDirectory  withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
//    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *name = @"EufySecurity_NSLog";
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"/%@.log",name];
    
    NSLog(@"打印日志path: %@", logFilePath);
    
    return logFilePath;
}

-(NSString*)getCurrentTimeString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return dateStr;
}

@end
