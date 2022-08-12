//
//  RelaxationViewController.m
//  TestBaseRoot
//
//  Created by hxmac001 on 2021/12/22.
//

#import "RelaxationViewController.h"

//  定义一个链表
struct Node {
    int data;
    struct Node *next;
};

@interface RelaxationViewController ()

@end

@implementation RelaxationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"休闲";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //字符串反转
    char ch[] = "hello,world";
    char_reverse(ch);
    NSLog(@"reverse result is %s \n",ch);
    
    NSString *str = @"hello,world";
    NSInteger strLength = str.length;
    NSString *str1=@"";
    for (NSInteger i = strLength-1; i<strLength; i--) {
        NSRange range = NSMakeRange(i, 1);
        str1 = [str1 stringByAppendingString:[str substringWithRange:range]];
        if (i==0) {
            break;
        }
    }
    NSLog(@"倒叙遍历字符串为%@",str1);
    
    //单链表反转
//    struct Node *head = constructList();
//    printList(head);
    printf("------\n");
//    struct Node *newHead = reverseList(head);
//    printList(newHead);
    
    //有序数组合并
    int a[5] = {1,4,6,7,9};
    int b[8] = {2,3,5,6,7,8,10,11};
    //用于存储归并结果
    int result[13];
    //归并操作
    mergeList(a, 5, b, 8, result);
    //打印归并结果
    printf("merge result is ");
    for (int i=0; i<13; i++) {
        printf("%d",result[i]);
    }
}

#pragma mark - 字符串反转
void char_reverse(char* cha){
    //指向第一个字符
    char* begin = cha;
    //指向最后一个字符
    char* end = cha + strlen(cha) - 1;
    while (begin < end) {
        //交换前后两个字符,同时移动指针
        char temp = *begin;
        *(begin++) = *end;
        *(end--) = temp;
    }
}

#pragma mark - 链表反转
//链表反转
struct Node * reverseList(struct Node *head){
    //定义遍历指针,初始化为头结点
    struct Node *p = head;
    //反转后的链表头部
    struct Node *newH = NULL;
    //遍历链表
    while (p != NULL) {
        //记录下一个结点
        struct Node *temp = p->next;
        //当前结点的next指向新链表头部
        p->next = newH;
        //更改新链表头部为当前结点
        newH = p;
        //移动p指针
        p = temp;
    }
    return newH;
}
//构造一个链表
struct Node * constructList(void){
    //头结点定义
    struct Node *head = NULL;
    //记录当前尾结点
    struct Node *cur = NULL;
    for (int i = 1; i<5; i++) {
        struct Node *node = malloc(sizeof(struct Node));
        node->data = i;
        //头结点为空,新结点即为头结点
        if (head == NULL) {
            head = node;
        }
        //当前结点的next为新结点
        else{
            cur->next = node;
        }
        
        //设置当前结点为新结点
        cur = node;
    }
    return head;
}
//打印链表中的数据
void printList(struct Node *head){
    struct Node *temp = head;
    while ((temp->next) !=NULL) {
        printf("node is %d \n", temp->data);
        temp = temp->next;
    }
}

#pragma mark - 有序数组合并
void mergeList(int a[], int aLen, int b[], int bLen, int result[]){
    int p= 0;   //遍历数组a的指针
    int q= 0;   //遍历数组b的指针
    int i = 0;  //记录当前存储位置
    
    //任一数组没有达到边界则进行遍历
    while (p < aLen && q <bLen) {
        //如果a数组对应位置的值小于b数组对应位置的值
        if (a[p] <= b[q]) {
            //存储a数组的值
            result[i] = a[p];
            //移动a数组的遍历指针
            p++;
        }else{
            //存储b数组的值
            result[i] = b[q];
            //移动b数组的遍历指针
            q++;
        }
        //指向合并结果的下一个存储位置
        i++;
    }
    
    //如果a数组有剩余
    while (p<aLen) {
        //将a数组剩余部分拼接到合并结果的后面
        result[i] = a[p++];
        i++;
    }
    //如果b数组有剩余
    while (q<bLen) {
        //将a数组剩余部分拼接到合并结果的后面
        result[i] = b[q++];
        i++;
    }
}

@end
