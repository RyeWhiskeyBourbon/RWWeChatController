//
//  RWWeChatBar.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/15.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWeChatBar.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@interface RWWeChatBar ()

<
    RWWeChatBarDelegate,
    UITextViewDelegate
>

@property (nonatomic,strong)UIButton *makeVoiceMessage;

@property (nonatomic,strong)UIImageView *messageType;

@property (nonatomic,strong)UIImageView *expressionKeyboard;

@property (nonatomic,strong)UIImageView *otherFunction;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);

@end

@implementation RWWeChatBar

+ (instancetype)wechatBarWithAutoLayout:(void(^)(MASConstraintMaker *))autoLayout
{
    RWWeChatBar *bar = [[RWWeChatBar alloc] init];
    
    bar.autoLayout = autoLayout;
    
    return bar;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview.window)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViews];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViews];
    }
}

- (void)initViews
{
    _purposeMenu =
            [RWAccessoryPurposeMenu accessoryPurposeMenuWithFrame:__KEYBOARD_FRAME__];
    
    _inputView = [RWAccessoryInputView accessoryInputViewWithFrame:__KEYBOARD_FRAME__];
    
    _makeTextMessage = [[RWTextField alloc] init];
    [self addSubview:_makeTextMessage];
    
    _makeVoiceMessage = [[UIButton alloc] init];
    [self addSubview:_makeVoiceMessage];
    
    _messageType = [[UIImageView alloc] init];
    _messageType.tag = RWChatBarButtonOfMessageType;
    [self addSubview:_messageType];
    
    _expressionKeyboard = [[UIImageView alloc] init];
    _expressionKeyboard.tag = RWChatBarButtonOfExpressionKeyboard;
    [self addSubview:_expressionKeyboard];
    
    _otherFunction = [[UIImageView alloc] init];
    _otherFunction.tag = RWChatBarButtonOfOtherFunction;
    [self addSubview:_otherFunction];
}

- (void)setDefaultSettings
{
    _isTextMessage = YES;
    _makeVoiceMessage.hidden = YES;
    
    _makeTextMessage.backgroundColor = [UIColor whiteColor];
    [_makeTextMessage setMargins:5.f];
    _makeTextMessage.layer.cornerRadius = 3;
    _makeTextMessage.clipsToBounds = YES;
    _makeTextMessage.textView.font = __RWGET_SYSFONT(14);
    _makeTextMessage.textView.textAlignment = NSTextAlignmentLeft;
    _makeTextMessage.textView.delegate = self;
    _makeTextMessage.layer.borderWidth = 0.3;
    _makeTextMessage.layer.borderColor = [__BORDER_COLOR__ CGColor];
    
    _makeVoiceMessage.layer.cornerRadius = 3;
    _makeVoiceMessage.clipsToBounds = YES;
    _makeVoiceMessage.layer.borderWidth = 0.3;
    _makeVoiceMessage.layer.borderColor = [__BORDER_COLOR__ CGColor];
    
    [_makeVoiceMessage setTitle:@"按住  说话"
                       forState:UIControlStateNormal];
    [_makeVoiceMessage setTitleColor:__BORDER_COLOR__
                            forState:UIControlStateNormal];
    
    [_makeVoiceMessage setTitle:@"松开  发送"
                       forState:UIControlStateSelected];
    [_makeVoiceMessage setTitleColor:self.backgroundColor
                            forState:UIControlStateSelected];
    
    [_makeVoiceMessage addTarget:self
                          action:@selector(touchDownAtButton:)
                forControlEvents:UIControlEventTouchDown];
    
    [_makeVoiceMessage addTarget:self
                          action:@selector(touchUpInsideAtButton:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self addGestureRecognizers];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        if (!textView.text.length)
        {
            [textView resignFirstResponder];
            
            return NO;
        }
        
        if (_delegate)
        {
            [_delegate sendTextMessage:textView.text];
        }
        
        textView.text = nil;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_delegate)
    {
        [_delegate beginEditingTextAtChatBar:self];
        _faceResponceAccessory = RWChatBarButtonNone;
    }
    
    return YES;
}

- (void)touchDownAtButton:(UIButton *)button
{
    _makeVoiceMessage.backgroundColor = __BORDER_COLOR__;
    
    [_makeVoiceMessage setTitle:@"松开  发送"
                       forState:UIControlStateNormal];
    [_makeVoiceMessage setTitleColor:self.backgroundColor
                            forState:UIControlStateNormal];

    if (_delegate)
    {
        [_delegate tapeBeginAtChatBar:self];
    }
}

- (void)touchUpInsideAtButton:(UIButton *)button
{
    _makeVoiceMessage.backgroundColor = self.backgroundColor;
    
    [_makeVoiceMessage setTitle:@"按住  说话"
                       forState:UIControlStateNormal];
    [_makeVoiceMessage setTitleColor:__BORDER_COLOR__
                            forState:UIControlStateNormal];
    
    if (_delegate)
    {
        [_delegate tapeEndAtChatBar:self];
    }
}

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *tapMessageType = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapMessageType.numberOfTapsRequired = 1;
    _messageType.userInteractionEnabled = YES;
    [_messageType addGestureRecognizer:tapMessageType];
    
    UITapGestureRecognizer *tapExpression = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapExpression.numberOfTapsRequired = 1;
    _expressionKeyboard.userInteractionEnabled = YES;
    [_expressionKeyboard addGestureRecognizer:tapExpression];
    
    UITapGestureRecognizer *tapOtherFunc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWithGestureRecognizer:)];
    tapOtherFunc.numberOfTapsRequired = 1;
    _otherFunction.userInteractionEnabled = YES;
    [_otherFunction addGestureRecognizer:tapOtherFunc];
}

- (void)tapViewWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.view.tag)
    {
        case RWChatBarButtonOfMessageType:
            
            if (_isTextMessage)
            {
                _makeTextMessage.hidden = YES;
                _makeVoiceMessage.hidden = NO;
                _isTextMessage = NO;
            }
            else
            {
                _makeTextMessage.hidden = NO;
                _makeVoiceMessage.hidden = YES;
                _isTextMessage = YES;
            }
            
            break;
        case RWChatBarButtonOfExpressionKeyboard:
            
            _faceResponceAccessory = RWChatBarButtonOfExpressionKeyboard;
            
            if (!_isTextMessage)
            {
                _makeTextMessage.hidden = NO;
                _makeVoiceMessage.hidden = YES;
                _isTextMessage = YES;
            }
            
            [_makeTextMessage.textView resignFirstResponder];
            
            if (_delegate)
            {
                [_delegate openAccessoryInputViewAtChatBar:self];
            }
            
            break;
        case RWChatBarButtonOfOtherFunction:
            
            _faceResponceAccessory = RWChatBarButtonOfOtherFunction;
            
            [_makeTextMessage.textView resignFirstResponder];
            
            if (_delegate)
            {
                [_delegate openMultiPurposeMenuAtChatBar:self];
            }
            
            break;
            
        default: break;
    }
}

- (void)autoLayoutViews
{
    [_messageType mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [_otherFunction mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.right.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    [_expressionKeyboard mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(35));
        make.height.equalTo(@(35));
        make.right.equalTo(_otherFunction.mas_left).offset(-5);
        make.centerY.equalTo(self.mas_centerY).offset(0);
    }];
    
    UIImageView *weakType = _messageType;
    UIImageView *weakKeyboard = _expressionKeyboard;
    RWWeChatBar *weakSelf = self;
    
    [_makeTextMessage setAutoLayout:^(MASConstraintMaker *make) {
       
        make.left.equalTo(weakType.mas_right).offset(5);
        make.right.equalTo(weakKeyboard.mas_left).offset(-5);
        make.top.equalTo(weakSelf.mas_top).offset(7);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-7);
    }];
    
    [_makeVoiceMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_messageType.mas_right).offset(5);
        make.right.equalTo(_expressionKeyboard.mas_left).offset(-5);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
    }];
}

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    _makeVoiceMessage.backgroundColor = backgroundColor;
}

- (void)setDelegate:(id<RWWeChatBarDelegate>)delegate
{
    _delegate = delegate;
    
    _makeTextMessage.delegate = _delegate;
}

@end

@implementation RWTextField

+ (instancetype)textFieldWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout margins:(CGFloat)margins
{
    RWTextField *text = [[RWTextField alloc] init];
    
    [text setMargins:margins];
    [text setAutoLayout:autoLayout];
    
    return text;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_autoLayout];
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)setMargins:(CGFloat)margins
{
    _margins = margins;
    
    if (self.superview && _autoLayout)
    {
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        [self autoLayoutViewWithMargins:_margins];
    }
}

- (void)autoLayoutViewWithMargins:(CGFloat)margins
{
    [_textView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(margins);
        make.right.equalTo(self.mas_right).offset(-margins);
        make.top.equalTo(self.mas_top).offset(2);
        make.bottom.equalTo(self.mas_bottom).offset(-2);
    }];
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.bounces = NO;
        _textView.returnKeyType = UIReturnKeySend;
        [self addSubview:_textView];
        _textView.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    if (_delegate)
    {
        [_delegate keyBoardWillShowWithSize:keyboardSize];
    }
}

- (void)keyboardWasHidden:(NSNotification *)notification
{
    if (_delegate)
    {
        [_delegate keyBoardWillHidden];
    }
}

@end

NSArray *defaultEmoticons()
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0x1F600; i <= 0x1F64F; i++)
    {
        if (i < 0x1F641 || i > 0x1F644)
        {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

@implementation RWAccessoryBaseView

- (void)initViews
{
    self.backgroundColor = __BORDER_COLOR__;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _inputView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self addSubview:_inputView];
    
    _inputView.backgroundColor = self.backgroundColor;
    
    _inputView.showsVerticalScrollIndicator = NO;
    _inputView.showsHorizontalScrollIndicator = NO;
    _inputView.pagingEnabled = YES;
    
    _inputView.delegate = self;
    _inputView.dataSource = self;
    
    _pageView = [[UIPageControl alloc] init];
    [self addSubview:_pageView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initViews];
    }
    
    return self;
}

@end

@implementation RWAccessoryInputView

+ (instancetype)accessoryInputViewWithFrame:(CGRect)frame
{
    return  [[RWAccessoryInputView alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.inputView registerClass:[RWInputViewCell class]
       forCellWithReuseIdentifier:NSStringFromClass([RWInputViewCell class])];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.resource = defaultEmoticons();
    
    self.pageView.numberOfPages = _resource.count % 32?
                                  _resource.count / 32 + 1:
                                  _resource.count / 32;
    
    self.pageView.currentPage = 0;
    self.pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageView.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self autoLayoutViews];
    [self.inputView reloadData];
}

- (void)autoLayoutViews
{
    [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.equalTo(@(20));
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.pageView.mas_top).offset(-10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 32 == 4)
    {
        self.pageView.currentPage = indexPath.row / 32;
    }
    
    RWInputViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWInputViewCell class]) forIndexPath:indexPath];
    
    cell.item.text = _resource[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/8, collectionView.bounds.size.height/4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

@implementation RWAccessoryPurposeMenu

+ (instancetype)accessoryPurposeMenuWithFrame:(CGRect)frame
{
    return  [[RWAccessoryPurposeMenu alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.inputView registerClass:[RWPurposeMenuCell class]
           forCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuCell class])];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    self.resource = @[@{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]},
                      @{@"title":@"设置",@"image":[UIImage imageNamed:@"MY"]}];
    
    self.pageView.numberOfPages = _resource.count % 8?
                                  _resource.count / 8 + 1:
                                  _resource.count / 8;
    
    self.pageView.currentPage = 0;
    self.pageView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageView.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self autoLayoutViews];
    [self.inputView reloadData];
}

- (void)autoLayoutViews
{
    [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.height.equalTo(@(20));
    }];
    
    [self.inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
        make.bottom.equalTo(self.pageView.mas_top).offset(-10);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWPurposeMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWPurposeMenuCell class]) forIndexPath:indexPath];
    
    cell.imageView.image = _resource[indexPath.row][@"image"];
    cell.title.text = _resource[indexPath.row][@"title"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/4, collectionView.bounds.size.height/2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

@implementation RWInputViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _item = [[UILabel alloc] init];
        _item.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_item];
        
        [_item mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    
    return self;
}

@end

@implementation RWPurposeMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:15];
        [self addSubview:_title];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@(20));
        }];
        
        CGFloat height = frame.size.height - 20 - 10;
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(height));
            make.height.equalTo(@(height));
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.top.equalTo(self.mas_top).offset(5);
        }];
    }
    
    return self;
}

@end

