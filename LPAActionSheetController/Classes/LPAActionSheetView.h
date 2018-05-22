//
//  LPAActionSheetView.h
//  LPAActionSheetController
//
//  Created by 平果太郎 on 2018/5/21.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN CGFloat const kLPAActionSheetViewRowHeight;

@class LPAActionSheetView;

@protocol LPAActionSheetViewDelegate <NSObject>

- (void)actionSheetView:(LPAActionSheetView *)actionSheetView didClickedButtonAtIndex:(NSUInteger)index;
- (void)actionSheetViewDidCloseButtonClicked:(LPAActionSheetView *)actionSheetView;

@end

@interface LPAActionSheetView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *titleImage;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat rowHeight;
/// default is no
@property (nonatomic, assign) BOOL showCloseButton;

@property (nonatomic, weak) id<LPAActionSheetViewDelegate> delegate;

- (void)addActionSheetButtonWithTitle:(NSString *)title
                            textColor:(UIColor *)textColor
                      backgroundColor:(UIColor *)backgroundColor;

@end
