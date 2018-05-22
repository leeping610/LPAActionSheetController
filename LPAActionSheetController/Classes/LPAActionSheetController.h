//
//  LPAActionSheetController.h
//  LPAActionSheetController
//
//  Created by 平果太郎 on 2018/5/21.
//

#import <UIKit/UIKit.h>

@interface LPAActionSheetAction : NSObject

@property (nonatomic, copy, readonly) NSString *title;

@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *textColor;

+ (instancetype)actionWithTitle:(NSString *)title textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor handler:(void (^)(LPAActionSheetAction *))handlerBlock;

@end

@interface LPAActionSheetController : UIViewController

/// 标题文字
@property (nonatomic, copy, readonly) NSString *titleText;
/// 标题旁图标
@property (nonatomic, strong, readonly) UIImage *titleImage;
/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// actionSheet背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 点击空白处关闭
@property (nonatomic, assign) BOOL tapToClose;

- (instancetype)initWithTitle:(NSString *)title titleImage:(UIImage *)titleImage dismissBlock:(void (^)(void))dismissBlock;
- (void)addAction:(LPAActionSheetAction *)action;

@end
