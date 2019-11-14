//
//  WTKVCTestVC.m
//  TotalDemo
//
//  Created by tyler on 7/22/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTKVCTestVC.h"
#import "WTPersonObj.h"
#import "NSObject+Ex.h"

#define img(name) ((name&&[name isEqualToString:@""])?nil:[UIImage imageNamed:name])  //[UIImage imageNamed:(name)]

@interface WTKVCTestVC ()

@end

@implementation WTKVCTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
//    WTPersonObj *person = [[WTPersonObj alloc]init];
//    [person setValue:@"Wang Test" forKey:@"name"];
//
//    [person setValue:@"2001010256" forKey:@"objID"];
//
//    [person setValue:@"我是地球人" forKey:@"earth"];
//
//    [person setValue:@"我是哲学家" forKey:@"person"];
//
//    NSString *name = [person valueForKey:@"name"];
//
//    NSString *objID = [person valueForKey:@"objID"];
//
//    NSString *earth = [person valueForKey:@"earth"];
//
//    NSString *per = [person valueForKey:@"person"];
//
//    NSLog(@"name: %@", name);
//    NSLog(@"objID: %@", objID);
//    NSLog(@"earth: %@", earth);
//    NSLog(@"per: %@", per);
//
//
//    UIImage *img = img(@"moguPic");
//    NSLog(@"%@", img);
    
    
    NSDictionary *dic = @{@"sn":@"10001001", @"age":@(20), @"name":@"Tony", @"job":@"student"};
    WTPersonObj *tony = [[WTPersonObj alloc]init];
    [tony setValuesForKeysWithDictionary:dic];
    
    NSDictionary *res = tony.dictionary;
    NSLog(@"res = %@", res);
}





@end
