//
//  LPAActionSheetController.m
//  LPAActionSheetController
//
//  Created by 平果太郎 on 2018/5/21.
//

#import "LPAActionSheetController.h"
#import "LPAActionSheetView.h"

@interface LPAActionSheetAction ()

/// 按钮标题
@property (nonatomic, copy, readwrite) NSString *title;
/// 按钮文本颜色/背景颜色
@property (nonatomic, strong, readwrite) UIColor *textColor;
@property (nonatomic, strong, readwrite) UIColor *backgroundColor;
/// 点击按钮触发动作
@property (nonatomic, copy) void(^handlerBlcok)(LPAActionSheetAction *actionSheetAction);

@end

@implementation LPAActionSheetAction

+ (instancetype)actionWithTitle:(NSString *)title textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor handler:(void (^)(LPAActionSheetAction *))handlerBlock {
    LPAActionSheetAction *actionSheetAction = [[LPAActionSheetAction alloc] init];
    actionSheetAction.title = title;
    actionSheetAction.textColor = textColor;
    actionSheetAction.backgroundColor = backgroundColor;
    actionSheetAction.handlerBlcok = handlerBlock;
    return actionSheetAction;
}

@end

@interface LPAActionSheetController () <LPAActionSheetViewDelegate>

@property (nonatomic, strong) LPAActionSheetView *actionSheetView;

@property (nonatomic, copy, readwrite) NSString *titleText;
@property (nonatomic, strong, readwrite) UIImage *titleImage;

@property (nonatomic, strong) NSMutableArray *actionList;
@property (nonatomic, copy) void(^dismissBlock)(void);

@end

@implementation LPAActionSheetController

#pragma mark - Life Cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _actionList = [[NSMutableArray alloc] init];
        _tapToClose = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title titleImage:(UIImage *)titleImage dismissBlock:(void (^)(void))dismissBlock {
    self = [self init];
    if (self) {
        _titleText = title;
        _titleImage = titleImage;
        _dismissBlock = dismissBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureHandler:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:self.actionSheetView];
    [_actionList enumerateObjectsUsingBlock:^(LPAActionSheetAction *action, NSUInteger idx, BOOL *stop){
        [self.actionSheetView addActionSheetButtonWithTitle:action.title
                                                  textColor:action.textColor
                                            backgroundColor:action.backgroundColor];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /// Animation to show
    CGRect actionSheetFrame = self.actionSheetView.frame;
    actionSheetFrame.origin.y = CGRectGetHeight(self.view.bounds) - actionSheetFrame.size.height - 20.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.actionSheetView.frame = actionSheetFrame;
    } completion:^(BOOL finished){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAction:(LPAActionSheetAction *)action {
    if (action) {
        [_actionList addObject:action];
    }
}

#pragma mark - Event Response

- (void)viewTapGestureHandler:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGRect actionSheetFrame = self.actionSheetView.frame;
    actionSheetFrame.origin.y = CGRectGetHeight(self.view.bounds) + actionSheetFrame.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        self.actionSheetView.frame = actionSheetFrame;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished){
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - LPAActionSheetViewDelegate

- (void)actionSheetView:(LPAActionSheetView *)actionSheetView didClickedButtonAtIndex:(NSUInteger)index {
    LPAActionSheetAction *action = _actionList[index];
    CGRect actionSheetFrame = self.actionSheetView.frame;
    actionSheetFrame.origin.y = CGRectGetHeight(self.view.bounds) + actionSheetFrame.size.height;
    [UIView animateWithDuration:0.3f animations:^{
        self.actionSheetView.frame = actionSheetFrame;
        self.view.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished){
        if (action.handlerBlcok) {
            action.handlerBlcok(action);
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Custom Accessors

- (LPAActionSheetView *)actionSheetView {
    if (!_actionSheetView) {
        CGFloat height = _actionList.count * kLPAActionSheetViewRowHeight + (_actionList.count + 1 * 10) + 60.0f;
        if (!_tapToClose) {
            height += 30;
        }
        if (height - 40 > CGRectGetHeight(self.view.bounds)) {
            height = CGRectGetHeight(self.view.bounds) - 40;
        }
        _actionSheetView = [[LPAActionSheetView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(self.view.bounds) + height,
                                                                                CGRectGetWidth(self.view.bounds) - 30, height)];
        _actionSheetView.delegate = self;
        _actionSheetView.title = _titleText;
        _actionSheetView.titleColor = _titleColor;
        _actionSheetView.tapToClose = _tapToClose;
        if (_backgroundColor) {
            _actionSheetView.backgroundColor = _backgroundColor;
        }else {
            _actionSheetView.backgroundColor = [UIColor whiteColor];
        }
    }
    return _actionSheetView;
}

@end
