//
//  MenuScrollView.h
//  TestBaseRoot
//
//  Created by hxmac001 on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    Horizontal,    //水平滑动
    Vertical,      //垂直滑动
    None,          //不滑动
} ScrollDirection;

@protocol MenuScrollViewDelegate;
@interface MenuScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    NSInteger NumInLine;
    NSInteger NumInList;
    CGSize MenuSize;
    NSInteger MenuCount;
}

@property(nonatomic,assign)ScrollDirection scrolldirection;
@property(nonatomic,strong)NSArray * arr_DataSource;
@property(nonatomic,assign)id<MenuScrollViewDelegate>delegate;
/**
 菜单视图初始化方法1
 @param frame 大小
 @param arr 数据源
 @param size 菜单的大小
 @param direction scrollview的滚动方向
 @param numLine 每行的菜单数目
 @param numList 多少行 (竖直滑动只需设置初始多少行就行,不滑动不用设置)
 @param delegate 代理
 @return 菜单视图
 */
-(id)initWithFrame:(CGRect)frame
          MenuData:(NSArray *)arr
          MenuSize:(CGSize)size
   ScrollDirection:(ScrollDirection)direction
       MenusInLine:(NSInteger)numLine
        MenuInList:(NSInteger)numList
      MenuDelegate:(id)delegate;
/**
 *    刷新菜单数据
 *   @param arr    菜单数组
 */
-(void)reloadMenuData:(NSArray *)arr;
@end

@protocol MenuScrollViewDelegate <NSObject>
@optional

-(void)BtnPressWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
