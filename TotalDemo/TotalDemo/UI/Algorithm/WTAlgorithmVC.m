//
//  WTAlgorithmVC.m
//  TotalDemo
//
//  Created by tyler on 8/19/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTAlgorithmVC.h"

struct Node {
    
    int data;
    struct Node *next;
};

@interface WTAlgorithmVC ()

@end

@implementation WTAlgorithmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //反转字符串
    [self reverseCharacters];
    
    //反转链表
    [self linkReverse];
    
    //合并两个有序数组
    [self mergeTwoOrderedDataArray];
    
    //心形
    
}

-(void)createLover {
    
    int width = 50, height = 50;
    for (int i=0; i<width*2; i++) {
        for (int j=0; j<height; j++) {
            
        }
    }
}

//1.字符串反转
-(void)reverseCharacters {
    
    NSString *hello = @"Hello world.";
    
    //OC
    NSMutableString *reversStr = [[NSMutableString alloc]initWithString:hello];
    for (int i=0; i<hello.length/2; i++) {
        [reversStr replaceCharactersInRange:NSMakeRange(i, 1) withString:[hello substringWithRange:NSMakeRange(hello.length-i-1, 1)]];
        [reversStr replaceCharactersInRange:NSMakeRange(hello.length-i-1, 1) withString:[hello substringWithRange:NSMakeRange(i, 1)]];
    }
    NSLog(@"Objective-C反转字符串: %@", reversStr);
    
    
    //C
    char resStr[100];
    memcpy(resStr, hello.UTF8String, hello.length);
    for (int i=0; i<hello.length/2; i++) {
        char tmp = resStr[i];
        resStr[i] = resStr[hello.length-i-1];
        resStr[hello.length-i-1] = tmp;
    }
    NSLog(@"C反转字符串method1: %@", [NSString stringWithUTF8String:resStr]);
    
    //C
    char resStr1[100];
    memcpy(resStr1, [hello cStringUsingEncoding:NSUTF8StringEncoding], hello.length);
    char *begin = resStr1;
    char *end = resStr1+strlen(resStr1)-1;
    while (begin<end) {
        char ch = *begin;
        *(begin++) = *end;
        *(end--) = ch;
    }
    NSLog(@"C反转字符串method2: %@", [NSString stringWithUTF8String:resStr1]);
}

//2.链表反转
-(void)linkReverse {
    
    struct Node *head = [self constructLink];
    NSLog(@"链表数据:");
    [self printLink:head];
    
    struct Node *nextNode = head->next;
    
    struct Node *tmp = NULL;
    head->next = NULL;
    while (nextNode!=NULL) {
        tmp = nextNode;
        nextNode = nextNode->next;
        tmp->next = head;
        head = tmp;
    }
    
    NSLog(@"翻转后链表数据:");
    [self printLink:head];
}
//打印链表数据
-(void)printLink:(struct Node*)link {
    
    if (link==NULL) {
        return;
    }
    
    struct Node *node = link;
    while (node!=NULL) {
        if (node->next != NULL) {
            printf("data=%d->", node->data);
        }else{
            printf("data=%d", node->data);
        }
        node = node->next;
    }
    printf("\n");
}
//构建链表
-(struct Node*)constructLink {
    
    struct Node *head = NULL;
    struct Node *cur = NULL;
    
    for (int i=0; i<10; i++) {
        struct Node *curNode = malloc(sizeof(struct Node));
        curNode->data = i+10;
        curNode->next = NULL;
        
        if (head==NULL) {
            head = curNode;
        }else {
            cur->next = curNode;
        }
        cur = curNode;
    }
    
    return head;
}

//3.有序数组合并
-(void)mergeTwoOrderedDataArray {
    
    int len1 = 5, len2 = 9;
    int data1[] = {3, 6, 9, 11, 15};
    int data2[] = {1, 2, 5, 10, 11, 12, 14, 17, 18};
    
    NSLog(@"合并前数组: ");
    [self printList:data1 lenght:len1];
    [self printList:data2 lenght:len2];
    
    int data[14]; //初始化
    int p=0, q=0, i=0;
    while (p<len1 && q<len2) {
        if (data1[p]<data2[q]) {
            data[i++] = data1[p++];
        }else{
            data[i++] = data2[q++];
        }
    }
    
    while (p<len1) {
        data[i++] = data1[p++];
    }
    
    while (q<len2) {
        data[i++] = data2[q++];
    }
    
    //
    NSLog(@"合并后数组: ");
    [self printList:data lenght:len1+len2];
}
-(void)printList:(int [])data lenght:(int)length {
    
    printf("数据: \n");
    for (int i=0; i<length; i++) {
        printf("%d, ", data[i]);
    }
    printf("\n");
}

//4.Hash算法

//5.查找两个子视图的共同父视图

//6.查找无序数组的中位数

@end
