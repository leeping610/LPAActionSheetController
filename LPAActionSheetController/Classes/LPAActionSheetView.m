//
//  LPAActionSheetView.m
//  LPAActionSheetController
//
//  Created by 平果太郎 on 2018/5/21.
//

#import "LPAActionSheetView.h"

#define LPAResourcesPath [[NSBundle mainBundle] pathForResource:@"Frameworks/LPAActionSheetController.framework/LPAActionSheetController" ofType:@"bundle"]
#define LPAResourcesBundle [NSBundle bundleWithPath:LPAResourcesPath]

#define LPAImageResource(imageName) LPAResourcesBundle ? [UIImage imageNamed:imageName inBundle:LPAResourcesBundle compatibleWithTraitCollection:nil] : [UIImage imageNamed:imageName inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LPAActionSheetController" ofType:@"bundle"]] compatibleWithTraitCollection:nil]

CGFloat const kLPAActionSheetViewRowHeight = 60.0f;

static NSString *const kLPAActionSheetTableViewCellIdentifier = @"LPAActionSheetTableViewCellIdentifier";

static NSString *const kLPAActionSheetButtonTitleTextKey = @"LPAActionSheetButtonTitleTextKey";
static NSString *const kLPAActionSheetButtonTextColorKey = @"LPAActionSheetButtonTextColorKey";
static NSString *const kLPAActionSheetButtonBackgroundColorKey = @"LPAActionSheetButtonBackgroundColorKey";

@interface LPAActionSheetButton : UIButton

@end

@implementation LPAActionSheetButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 10.0f;
    }
    return self;
}

@end

@class LPAActionSheetTableViewCell;

@protocol LPAActionSheetTableViewCellDelegate <NSObject>

- (void)actionSheetTableViewCellButtonDidClicked:(LPAActionSheetTableViewCell *)cell;

@end

@interface LPAActionSheetTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *buttonBackgroundColor;
@property (nonatomic, strong) UIColor *buttonTextColor;

@property (nonatomic, weak) id<LPAActionSheetTableViewCellDelegate> delegate;
@property (nonatomic, strong) LPAActionSheetButton *actionSheetButton;

@end

@implementation LPAActionSheetTableViewCell

#pragma mark - Life Cycle (LPAActionSheetTableViewCell)

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.actionSheetButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_actionSheetButton setFrame:CGRectMake(20, 0, CGRectGetWidth(self.contentView.bounds) - 40,
                                            CGRectGetHeight(self.contentView.bounds))];
}

#pragma mark - Event Response (LPAActionSheetTableViewCell)

- (void)actionSheetButtonHandler:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetTableViewCellButtonDidClicked:)]) {
        [self.delegate actionSheetTableViewCellButtonDidClicked:self];
    }
}

#pragma mark - Custom Accessors (LPAActionSheetTableViewCell)

- (LPAActionSheetButton *)actionSheetButton {
    if (!_actionSheetButton) {
        _actionSheetButton = [LPAActionSheetButton buttonWithType:UIButtonTypeCustom];
        [_actionSheetButton addTarget:self action:@selector(actionSheetButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionSheetButton;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    [_actionSheetButton setTitle:_title forState:UIControlStateNormal];
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor {
    _buttonTextColor = buttonTextColor;
    [_actionSheetButton setTitleColor:_buttonBackgroundColor forState:UIControlStateNormal];
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor {
    _buttonBackgroundColor = buttonBackgroundColor;
    [_actionSheetButton setBackgroundColor:buttonBackgroundColor];
}

@end

@interface LPAActionSheetView () <UITableViewDelegate, UITableViewDataSource, LPAActionSheetTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *footerImageView;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *buttonList;

@end

@implementation LPAActionSheetView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 12.0f;
        
        _buttonList = [[NSMutableArray alloc] init];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_tableView setFrame:self.bounds];
}

- (void)addActionSheetButtonWithTitle:(NSString *)title textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor {
    NSMutableDictionary *buttonDictionary = [[NSMutableDictionary alloc] init];
    [buttonDictionary setValue:title forKey:kLPAActionSheetButtonTitleTextKey];
    [buttonDictionary setValue:textColor forKey:kLPAActionSheetButtonTextColorKey];
    [buttonDictionary setValue:backgroundColor forKey:kLPAActionSheetButtonBackgroundColorKey];
    [_buttonList addObject:buttonDictionary];
}

#pragma mark - Event Response

- (void)closeButtonHandler:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetViewDidCloseButtonClicked:)]) {
        [self.delegate actionSheetViewDidCloseButtonClicked:self];
    }
}

#pragma mark - LPAActionSheetTableViewCell Delegate

- (void)actionSheetTableViewCellButtonDidClicked:(LPAActionSheetTableViewCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (indexPath) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheetView:didClickedButtonAtIndex:)]) {
            [self.delegate actionSheetView:self didClickedButtonAtIndex:indexPath.section];
        }
    }
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _buttonList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LPAActionSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLPAActionSheetTableViewCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[LPAActionSheetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:kLPAActionSheetTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *buttonDictionary = _buttonList[indexPath.section];
    cell.title = buttonDictionary[kLPAActionSheetButtonTitleTextKey];
    cell.buttonTextColor = buttonDictionary[kLPAActionSheetButtonTextColorKey];
    cell.buttonBackgroundColor = buttonDictionary[kLPAActionSheetButtonBackgroundColorKey];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 10.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _buttonList.count - 1) {
        return 10.0f;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (_rowHeight) {
            _tableView.rowHeight = _rowHeight;
        }else {
            _tableView.rowHeight = kLPAActionSheetViewRowHeight;
        }
        [_tableView registerClass:[LPAActionSheetTableViewCell class]
           forCellReuseIdentifier:kLPAActionSheetTableViewCellIdentifier];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), 50)];
        _tableHeaderView.backgroundColor = self.backgroundColor;
        [_tableHeaderView addSubview:self.titleLabel];
        [_tableHeaderView addSubview:self.headerImageView];
        [_titleLabel setFrame:CGRectMake((CGRectGetWidth(_tableHeaderView.bounds) - CGRectGetWidth(_titleLabel.frame)) / 2, 0, CGRectGetWidth(_titleLabel.bounds), 50)];
        [_headerImageView setFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame) - 21,
                                              (CGRectGetHeight(_tableHeaderView.bounds) - 13) / 2, 13, 13)];
    }
    return _tableHeaderView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:_tableHeaderView.bounds];
        _titleLabel.text = _title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        _headerImageView.image = _titleImage;
    }
    return _headerImageView;
}

- (void)setTitleImage:(UIImage *)titleImage {
    _titleImage = titleImage;
    _headerImageView.image = _titleImage;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    if (_title) {
        _tableView.tableHeaderView = self.tableHeaderView;
    }else {
        _tableView.tableHeaderView = nil;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (_titleColor) {
        self.titleLabel.textColor = _titleColor;
    }
}

- (void)setShowCloseButton:(BOOL)showCloseButton {
    _showCloseButton = showCloseButton;
    if (_showCloseButton) {
        UIImage *image = LPAImageResource(@"close");
        if (image) {
            UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.bounds), 30)];
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeButton setImage:image forState:UIControlStateNormal];
            [closeButton setFrame:CGRectMake((CGRectGetWidth(tableFooterView.bounds) - 20) / 2, 0, 20, 20)];
            [closeButton addTarget:self action:@selector(closeButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
            [tableFooterView addSubview:closeButton];
            _tableView.tableFooterView = tableFooterView;
        }
    }else {
        _tableView.tableFooterView = nil;
    }
}

@end
