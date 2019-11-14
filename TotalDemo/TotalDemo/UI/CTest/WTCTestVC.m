//
//  WTCTestVC.m
//  TotalDemo
//
//  Created by tyler on 7/12/19.
//  Copyright © 2019 wzt. All rights reserved.
//

#import "WTCTestVC.h"
#include <string.h>
#include <stdio.h>
#import "WTBlockObj.h"

@interface WTCTestVC ()

@end

@implementation WTCTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //
    self.title = NSStringFromClass([self class]);
    
    
    
    //[self test6];
    
    //希尔排序
    //[self shellSortTest];
    
    //插入排序
    //[self insertSort2];
    
    //快速排序
    [self quickSortTest];
    
    //[self dataStoreTest];
    
    //[self blockTest];
}

-(void)blockTest {
    
    WTBlockObj *obj = [[WTBlockObj alloc]init];
    obj.name = @"Test";
    obj.age = 21;
    obj.name_new = @"Test New";
    obj.age_new = 21;
    
    int count = 10;
    void(^block)(void) = ^(void) {
        
        NSLog(@"obj.name=%@, obj.age=%ld, obj.name_new=%@, obj.age_new=%ld", obj.name, obj.age, obj.name_new, obj.age_new);
        NSLog(@"Count=%d", count);
    };
    
    count = count+11;
    obj.name = @"Test111";
    obj.age = 22;
    obj.name_new = @"Test New111";
    obj.age_new = 23;
    block();
}

-(void)dataStoreTest {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"login" ofType:@"plist"];
    
    NSDictionary *dic = @{@"token":@"12345678", @"name":@"Test", @"age":@"10"};
    NSLog(@"开始循环写入...");
    for (int i=0; i<1000; i++) {
        [dic writeToFile:path atomically:NO];
        NSLog(@"i=%d", i);
    }
    NSLog(@"结束循环写入...");
    
}

/* ********* 排序 ********* */
void printArrayData(int *a, int length) {
    
    for (int j = 0; j < length; j++) {
        printf("%d ,", a [j]);
    }
    
    printf("\n");
}
/// **** Shell排序 ***** ///
//    进行插入排序
//    初始时从dk开始增长，每次比较步长为dk
void Insrtsort(int *a, int n,int dk) {
    for (int i = dk; i < n; ++i) {
        int j = i - dk;
        if (a[i] < a[j]) {    //    比较前后数字大小
            int tmp = a[i];        //    作为临时存储
            a[i] = a[j];
            while (j>=0 && a[j] > tmp) {    //    寻找tmp的插入位置
                a[j+dk] = a[j];
                j -= dk;
            }
            a[j+dk] = tmp;        //    插入tmp
        }
        
        printf("dk=%d \n", dk);
        printArrayData(a, n);
    }
}

void ShellSort(int *a, int n) {
    int dk = n / 2;        //    设置初始dk
    printf("n = %d, k=%d\n", n, dk);
    while (dk >= 1) {
        Insrtsort(a, n, dk);
        dk /= 2;
    }
}
-(void)shellSortTest {
    
    int a[] = {5, 12, 35, 42, 11, 2, 9, 41, 26, 18, 4};
    int n = sizeof(a) / sizeof(int);
    ShellSort(a, n);
    printf("排序好的数组为: \n");
    printArrayData(a, 10);
}
/// **** Shell排序 ***** ///

// / **** 插入排序 **** / 算法复杂度: o(n)~o(n2)
-(void)insertSort2 {
    int a[] = {5, 12, 35, 42, 11, 2, 9, 41, 26, 18, 4};
    int length = sizeof(a) / sizeof(int);
    
    //insertSortMethod(a, length);
    shellSort(a, length);
    printArrayData(a, length);
}
void insertSortMethod(int a[], int length)
{
    int i,j;
    for (i=1; i<length; i++) {
        if (a[i]<a[i-1]) {
            int tmp = a[i];
            for (j=i; j>0; j--) {
                if (a[j-1]>tmp) {
                    a[j] = a[j-1];
                }else {
                    break;
                }
            }
            a[j] = tmp;
        }
    }
}

//希尔排序
void shellSort(int num[],int count)
{
    int shellNum = 2;
    int gap = round(count/shellNum);
    
    while (gap > 0) {
        for (int i = gap; i < count; i++) {
            int temp = num[i];
            int j = i;
            while (j >= gap && num[j - gap] > temp) {
                num[j] = num[j - gap];
                j = j - gap;
                printf("------gap=%d-------", gap);
                printArrayData(num, count);
            }
            num[j] = temp;
            printf("------for-------");
            printArrayData(num, count);
        }
        gap = round(gap/shellNum);
        printf("------while-------");
        printArrayData(num, count);
    }
}

//快速排序
-(void)quickSortTest {
    
    int a[] = {5, 12, 35, 42, 11, 2, 9, 41, 26, 18, 4};
    int length = sizeof(a) / sizeof(int);
    
    quickSort(a, length, 0, length-1);
    printArrayData(a, length);
}
void quickSort(int num[],int count,int left,int right)
{
    if (left >= right){
        
        return ;
    }
    int key = num[left];
    int lp = left;           //左指针
    int rp = right;          //右指针
    while (lp < rp) {
        if (num[rp] < key) {
            int temp = num[rp];
            for (int i = rp - 1; i >= lp; i--) {
                num[i + 1] = num[i];
            }
            num[lp] = temp;
            lp ++;
            rp ++;
        }
        rp --;
        printArrayData(num, count);
    }
    printArrayData(num, count);
    quickSort(num,count,left,lp - 1);
    quickSort(num,count,rp + 1,right);
}






-(void)test1 {
    
    //1.memchr
    NSString *s = @"This is for testing4 haha.";
    const char *ss = s.UTF8String;
    int len = (int)[s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    const char key = 'f';
    
    void *res = memchr(ss, key, len);
    
    NSString *r1 = [NSString stringWithUTF8String:res];
    
    printf("%s\n", res);
    NSLog(@"%@", r1);
}

//memcmp
-(void)test2 {
    
    NSString *s1 = @"0.0.1.33.1";
    const char *ss1 = s1.UTF8String;
    int len1 = (int)[s1 lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *s2 = @"0.0.1.33";
    const char *ss2 = s2.UTF8String;
    int len2 = (int)[s2 lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    int len = MIN(len1, len2);
    
    int res = memcmp(ss1, ss2, len);
    printf("res=%d, %s %s %s", res, ss1, res==0?"=":res>0?">":"<", ss2);
    /*
     res<0: s1<s2
     res>0: s1>s2;
     res=0: s1=s2;
     */
}

//memcpy ??????????????
-(void)test3 {
    
    char s1[] = "Hello world.\0";
    
    char *s2 = "Hello world.\0";
    
    char *r1 = malloc(14);
    memcpy(r1, s1, 14);

    char *r2 = malloc(14);
    memcpy(r2, s2, 14);
    
    char r3[14] = {0};
    memcpy(r3, s1, 14);
    
    char r4[14] = {0};
    memcpy(r4, s2, 14);
    
    printf("r1 = %s\n", r1);       //Hello world.
    printf("r2 = %s\n", r2);       //Hello world.
    printf("r3 = %s\n", r3);       //Hello world.Hello world.
    printf("r4 = %s\n", r4);       //Hello world.Hello world.Hello world.
    
    printf("地址-s1 = %p\n", &s1);
    printf("地址-s2 = %p\n", &s2);
    printf("地址-r1 = %p\n", &r1);
    printf("地址-r2 = %p\n", &r2);
    printf("地址-r3 = %p\n", &r3);
    printf("地址-r4 = %p\n", &r4);
    
    free(r1);
    free(r2);
}

//memmove(void *dest, const void *src, size_t n)
-(void)test4 {
    
    char s1[] = "Hello world.\0";
    
    //char *s2 = "Hello world.\0";
    
    char r1[14] = {0};
    
    char *r2 = {0};
    
    char *r3 = malloc(14);
    
    memmove(r1, s1, 14);
    
    memmove(r2, s1, 14);
    
    memmove(r3, s1, 14);
    
    printf("r1 = %s\n", r1);
    printf("r2 = %s\n", r2);
    printf("r3 = %s\n", r3);
}

//memset
-(void)test5 {
    
    //char s1[] = "Hello world.\0";
    
    char *r1 = calloc(1, 14);
    memset(r1, '0', 14);
    
    char *r2 = alloca(14);
    memset(r2, '1', 14);
    
    char *r3 = malloc(14);
    memset(r3, '2', 14);
    
    printf("r1 = %s\n", r1);
    printf("r2 = %s\n", r2);
    printf("r3 = %s\n", r3);
}

-(void)test6 {
    
    NSLog(@"main: %@", [NSThread currentThread]);
    
    dispatch_queue_t serialQuque = dispatch_queue_create("GCD_SERIAL_QUEUE", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQuque, ^{
        
        NSLog(@"serial11: %@", [NSThread currentThread]);
    });
    
    dispatch_async(serialQuque, ^{
        
        NSLog(@"serial22: %@", [NSThread currentThread]);
    });
}


//strcat
-(void)test11 {
    
    char s1[15] = "Hello ";
    char *s2 = "world.";
    
    char *s3 = malloc(20);
    
    
    char *res = strcat(s1, s2);
    printf("res = %s\n", res);
    
    char *res2 = strcat(s3, s1);
    printf("res2 = %s\n", res2);
}



@end
