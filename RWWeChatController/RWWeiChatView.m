
//
//  RWWeiChatView.m
//  RWWeChatController
//
//  Created by zhongyu on 16/7/13.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWWeiChatView.h"

@interface RWWeChatView ()

<
    UITableViewDelegate,
    UITableViewDataSource,
    RWWeChatViewEvent
>

@property (nonatomic,copy)void (^autoLayout)(MASConstraintMaker *);

@end

static NSString *const chatCell = @"chatCell";

@implementation RWWeChatView

+ (instancetype)chatViewWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout messages:(NSMutableArray *)messages
{
    RWWeChatView *chatView = [[RWWeChatView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    
    chatView.autoLayout = autoLayout;
    
    chatView.messages = messages;
    
    return chatView;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self mas_remakeConstraints:_autoLayout];
    
    if (_messages)
    {
        [self reloadData];
        [self scrollToRowAtIndexPath:
                        [NSIndexPath indexPathForRow:_messages.count-1 inSection:0]
                    atScrollPosition:UITableViewScrollPositionBottom
                            animated:NO];
    }
}

- (void)setMessages:(NSMutableArray *)messages
{
    _messages = messages;
    
    if (_messages)
    {
        [self reloadData];
    }
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (self.superview)
    {
        [self mas_remakeConstraints:_autoLayout];
    }
}

- (void)addMessage:(RWWeChatMessage *)message
{
    [_messages addObject:message];
    
    [self reloadData];
    [self scrollToRowAtIndexPath:
     [NSIndexPath indexPathForRow:_messages.count-1 inSection:0]
                atScrollPosition:UITableViewScrollPositionBottom
                        animated:NO];
}

- (void)removeMessage:(RWWeChatMessage *)message
{
    
}

- (void)touchSpace
{
    [_eventSource touchSpaceAtwechatView:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.allowsSelection = NO;
        self.scrollsToTop = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.allowsSelection = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerClass:[RWWeChatCell class] forCellReuseIdentifier:chatCell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSpace)];
        
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWWeChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatCell
                                                         forIndexPath:indexPath];
    
    cell.message = _messages[indexPath.row];
    cell.eventSource = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWWeChatMessage *message = _messages[indexPath.row];
    
    return message.itemHeight;
}

#pragma mark - text menu

NSNumber *getTopRestrain(RWWeChatCell * cell)
{
    CGFloat top = cell.frame.origin.y;
    
    if (cell.message.showTime)
    {
        CGSize itemSize =
                    getFitSize(cell.message.dateString, __RWGET_SYSFONT(10.f), 0, 1);
        top += (itemSize.height + __MARGINS__ + __TIME_MARGINS__ * 2);
    }
    
    return @(top);
}

- (void)addTextMenuWithWechatCell:(RWWeChatCell *)wechat
{
    [self removeTextMenu];
    
//    RWTextMenu *menu = [RWTextMenu textMenuWithAutoLayout:^(MASConstraintMaker *make) {
//        
//        make.width.equalTo(@(280));
//        make.height.equalTo(@(30));
//        make.centerX.equalTo(self.mas_centerX).offset(0);
//        make.bottom.equalTo(getTopRestrain(wechat));
//        
//    } responseOrder:^(RWTextMenuType type) {
//        
//    } isText:(wechat.message.messageType == RWMessageTypeText)];
    
    RWChatMenuView * menu = [RWChatMenuView menuWithAutoLayout:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(280));
        make.height.equalTo(@(40));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.bottom.equalTo(getTopRestrain(wechat));
        
    } order:^(RWTextMenuType type) {
        
    } message:wechat.message arrowheadX:getArrowheadX(wechat)];
    
    menu.tag = 19085;
    [self addSubview:menu];
}

- (void)removeTextMenu
{
    if ([self viewWithTag:19085])
    {
        [[self viewWithTag:19085] removeFromSuperview];
    }
}

#pragma mark - event Source

- (void)wechatCell:(RWWeChatCell *)wechat event:(RWMessageEvent)event context:(id)context
{
    switch (event)
    {
        case RWMessageEventPressText:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressImage:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressVoice:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventPressVideo:
            
            [self addTextMenuWithWechatCell:wechat];
            break;
        case RWMessageEventTapImage:
            [_eventSource wechatCell:wechat event:event context:context]; break;
        case RWMessageEventTapVoice:
            [_eventSource wechatCell:wechat event:event context:context]; break;
        case RWMessageEventTapVideo:
            [_eventSource wechatCell:wechat event:event context:context]; break;
            
        default: break;
    }
}

@end

@interface RWWeChatCell ()

@property (nonatomic,strong)RWMarginsLabel *timeLabel;

@property (nonatomic,strong)UIImageView *headerImage;
@property (nonatomic,strong)UIImageView *arrowheadImage;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *);

@end

@implementation RWWeChatCell

- (void)setMessage:(RWWeChatMessage *)message
{
    _message = message;
    
    [self setTimeLabelAutoLayoutAndSettings];
    
    if (_message.isMyMessage) [self myMessageBaseLayout];
    else [self someoneMessageBaseLayout];
    
    switch (_message.messageType)
    {
        case RWMessageTypeText:  [self setTextMessageSettings];  break;
        case RWMessageTypeVoice: [self setVoiceMessageSettings]; break;
        case RWMessageTypeImage: [self setImageMessageSettings]; break;
        case RWMessageTypeVideo: [self setVideoMessageSettings]; break;
        default: break;
    }
}

- (void)initViews
{
    _timeLabel = [[RWMarginsLabel alloc] init];
    [self addSubview:_timeLabel];
    
    _headerImage = [[UIImageView alloc] init];
    [self addSubview:_headerImage];
    
    _contentLabel = [[RWMarginsLabel alloc] init];
    [self addSubview:_contentLabel];
    
    _voiceButton = [[UIButton alloc] init];
    [self addSubview:_voiceButton];
    
    _contentImage = [[UIImageView alloc] init];
    [self addSubview:_contentImage];
    
    _arrowheadImage = [[UIImageView alloc] init];
    [self addSubview:_arrowheadImage];
}

- (void)setDefaultSettings
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    _timeLabel.margins = __TIME_MARGINS__;
    _timeLabel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
    _timeLabel.textLabel.font = __RWGET_SYSFONT(10.f);
    _timeLabel.textLabel.numberOfLines = 1;
    _timeLabel.textLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textLabel.textColor = [UIColor whiteColor];
    
    _timeLabel.layer.cornerRadius = 3;
    _timeLabel.clipsToBounds = YES;
    
    _contentLabel.margins = __TEXT_MARGINS__;
    _contentLabel.textLabel.font = __RWCHAT_FONT__;
    _contentLabel.textLabel.numberOfLines = 0;
    _contentLabel.textLabel.textColor = [UIColor blackColor];
    
    _contentLabel.layer.cornerRadius = 6;
    _contentLabel.clipsToBounds = YES;
    
    [self addGestureRecognizers];
}

- (void)addGestureRecognizers
{
    UILongPressGestureRecognizer *pressText = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressText.minimumPressDuration = 1.5;
    
    [_contentLabel addGestureRecognizer:pressText];
    
    UILongPressGestureRecognizer *pressVoice = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressVoice.minimumPressDuration = 1.5;
    
    [_voiceButton addGestureRecognizer:pressVoice];
    
    [_voiceButton addTarget:self action:@selector(voicePlay) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *pressImage = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
    pressImage.minimumPressDuration = 1.5;
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageShow)];
    tapImage.numberOfTapsRequired = 1;
    
    [_contentImage addGestureRecognizer:tapImage];
    [_contentImage addGestureRecognizer:pressImage];
    
//    UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlay)];
//    UILongPressGestureRecognizer *pressVideo = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressMessage)];
//    pressVideo.minimumPressDuration = 1.5;
    
}

#pragma mark - click

- (void)pressMessage
{
    switch (_message.messageType)
    {
        case RWMessageTypeText:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressText
                             context:_message.message[getKey(RWMessageTypeText)]];
            break;
            
        case RWMessageTypeImage:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressImage
                             context:_message.message[getKey(RWMessageTypeImage)]];
            
            break;
            
        case RWMessageTypeVideo:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressVideo
                             context:_message.message[getKey(RWMessageTypeVideo)]];
            break;
            
        case RWMessageTypeVoice:
            
            [_eventSource wechatCell:self
                               event:RWMessageEventPressVoice
                             context:_message.message[getKey(RWMessageTypeVoice)]];
            
            break;
            
        default: break;
    }
}

- (void)voicePlay
{
    [_eventSource wechatCell:self
                       event:RWMessageEventTapVoice
                     context:_message.message[getKey(RWMessageTypeVoice)]];
}

- (void)imageShow
{
    [_eventSource wechatCell:self
                       event:RWMessageEventTapImage
                     context:_message.message[getKey(RWMessageTypeImage)]];
}

- (void)videoPlay
{
    [_eventSource wechatCell:self
                       event:RWMessageEventTapVideo
                     context:_message.message[getKey(RWMessageTypeVideo)]];
}

#pragma mark - settings With Type

- (void)setTextMessageSettings
{
    _voiceButton.hidden = YES;
    _contentImage.hidden = YES;
    _contentLabel.hidden = NO;
    
    _contentLabel.textLabel.textAlignment = NSTextAlignmentLeft;
    [self getAutoLayoutParameter];
    [_contentLabel setAutoLayout:_autoLayout];
    
    if (_message.isMyMessage)
    {
        _contentLabel.backgroundColor = [UIColor greenColor];
    }
    else
    {
        _contentLabel.backgroundColor = [UIColor lightGrayColor];
    }
    
    _contentLabel.textLabel.text = _message.message[getKey(RWMessageTypeText)];
}

- (void)setVoiceMessageSettings
{
    _contentLabel.hidden = YES;
    _contentImage.hidden = YES;
    _voiceButton.hidden = NO;
    
    [self getAutoLayoutParameter];
    [_voiceButton mas_remakeConstraints:_autoLayout];
}

- (void)setImageMessageSettings
{
    _contentLabel.hidden = YES;
    _voiceButton.hidden = YES;
    _contentImage.hidden = NO;
    
    [self getAutoLayoutParameter];
    [_contentImage mas_remakeConstraints:_autoLayout];
    
    _contentImage.image = _message.message[getKey(RWMessageTypeImage)];
}

- (void)setVideoMessageSettings
{
    
}

#pragma mark - autoLayout With Type

- (void)setTimeLabelAutoLayoutAndSettings
{
    if (_message.showTime)
    {
        CGSize textSize = getFitSize(_message.dateString, __RWGET_SYSFONT(10.f), 0, 1);
        
        RWWeChatCell *weakSelf = self;
        
        [_timeLabel setAutoLayout:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(textSize.width + __TIME_MARGINS__ * 2));
            make.height.equalTo(@(textSize.height + __TIME_MARGINS__ * 2));
            make.top.equalTo(weakSelf.mas_top).offset(__MARGINS__);
            make.centerX.equalTo(weakSelf.mas_centerX).offset(0);
        }];
        
        _timeLabel.textLabel.text = _message.dateString;
    }
    else
    {
        [_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.mas_top).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.equalTo(@(0));
            make.height.equalTo(@(0));
        }];
    }
}

- (void)myMessageBaseLayout
{
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = self.mas_top;
    }
    
    [_headerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__HEADER_SIZE__));
        make.height.equalTo(@(__HEADER_SIZE__));
        make.right.equalTo(self.mas_right).offset(-__MARGINS__);
        make.top.equalTo(masView).offset(__MARGINS__);
    }];
    
    [_arrowheadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(__ARROWHEAD_SIZE__));
        make.height.equalTo(@(__ARROWHEAD_SIZE__));
        make.centerY.equalTo(_headerImage.mas_centerY).offset(0);
        make.right.equalTo(_headerImage.mas_left).offset(-5);
    }];
    
    _headerImage.image = [UIImage imageNamed:@"MY"];
    _arrowheadImage.image = [[UIImage imageNamed:@"RightCa"] imageWithColor:[UIColor greenColor]];
}

- (void)someoneMessageBaseLayout
{
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = self.mas_top;
    }
    
    [_headerImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__HEADER_SIZE__));
        make.height.equalTo(@(__HEADER_SIZE__));
        make.left.equalTo(self.mas_left).offset(__MARGINS__);
        make.top.equalTo(masView).offset(__MARGINS__);
    }];
    
    [_arrowheadImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(__ARROWHEAD_SIZE__));
        make.height.equalTo(@(__ARROWHEAD_SIZE__));
        make.centerY.equalTo(_headerImage.mas_centerY).offset(0);
        make.left.equalTo(_headerImage.mas_right).offset(5);
    }];
    
    _headerImage.image = [UIImage imageNamed:@"someOne.jpg"];
    _arrowheadImage.image = [[UIImage imageNamed:@"LifeCa"] imageWithColor:[UIColor lightGrayColor]];
}

- (void)getAutoLayoutParameter
{    
    CGFloat left = __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 3.f;
    CGFloat right = __MARGINS__ + __HEADER_SIZE__ + __ARROWHEAD_SIZE__ + 3.f;
    
    __block RWWeChatCell *weakSelf = self;
    
    MASViewAttribute *masView = _timeLabel.mas_bottom;
    
    if (!_message.showTime)
    {
        masView = weakSelf.mas_top;
    }
    
    switch (_message.messageType)
    {
        case RWMessageTypeText:
        {
            NSString *context = _message.message[getKey(RWMessageTypeText)];
            CGSize size = getFitSize(context, __RWCHAT_FONT__, 0, 1);
            
            if ((size.width + __TEXT_MARGINS__ * 2) < __TEXT_LENGHT__)
            {
                if (_message.isMyMessage)
                {
                    left += (__TEXT_LENGHT__ - (size.width + __TEXT_MARGINS__ * 2));
                }
                else
                {
                    right += (__TEXT_LENGHT__ - (size.width + __TEXT_MARGINS__ * 2));
                }
                
                _contentLabel.textLabel.textAlignment = NSTextAlignmentCenter;
            }
            break;
        }
        case RWMessageTypeImage:
        {
            UIImage *image = _message.message[getKey(RWMessageTypeImage)];
            CGSize size = getFitImageSize(image);
            
            if (_message.isMyMessage)
            {
                left += (__PICxVID_MAX_WIDTH__ - size.width);
            }
            else
            {
                right += (__PICxVID_MAX_WIDTH__ - size.width);
            }
            
            _arrowheadImage.image = nil;
            
            break;
        }
        case RWMessageTypeVideo:
        {
            break;
        }
            
        default: break;
    }
    
    
    _autoLayout = ^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mas_left).offset(left);
        make.right.equalTo(weakSelf.mas_right).offset(-right);
        make.top.equalTo(masView).offset(10);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
    };
}

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

@end

NSString *getKey(RWMessageType type)
{
    return [NSString stringWithFormat:@"%d",(int)type];
}

CGSize getFitSize(NSString *text,UIFont *font,CGFloat width,CGFloat lines)
{
    UILabel *temp = [[UILabel alloc] init];
    
    temp.bounds = CGRectMake(0, 0, width, 0);
    temp.text = text;
    temp.numberOfLines = lines;
    
    [temp sizeToFit];
    
    return temp.bounds.size;
}

CGSize getFitImageSize(UIImage *image)
{
    CGSize imageSize = image.size;
    
    if (imageSize.width > __PICxVID_MAX_WIDTH__)
    {
        imageSize.height = __PICxVID_MAX_WIDTH__ / imageSize.width * imageSize.height;
        imageSize.width = __PICxVID_MAX_WIDTH__;
    }
    
    if (imageSize.height > __PICxVID_MAX_HEIGHT__)
    {
        imageSize.width = __PICxVID_MAX_HEIGHT__ / imageSize.height * imageSize.width;
        imageSize.height = __PICxVID_MAX_HEIGHT__;
    }
    
    return imageSize;
}

NSString *getDate(NSDate *messageDate)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *month = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *day = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setYear:year.integerValue];
    [comps setMonth:month.integerValue];
    [comps setDay:day.integerValue];
    
    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    if ([messageDate timeIntervalSinceDate:today] > 0)
    {
        [dateFormatter setDateFormat:@"HH:ss"];
        
        NSString *time = [dateFormatter stringFromDate:messageDate];
        
        return time;
    }
    else if ([messageDate timeIntervalSinceDate:today] > -24 * 60 * 60)
    {
        [dateFormatter setDateFormat:@"HH:ss"];
        
        NSString *time = [dateFormatter stringFromDate:messageDate];
        
        return [NSString stringWithFormat:@"昨天 %@",time];
    }
    
    [dateFormatter setDateFormat:@"EEEE HH:ss"];
    
    return [dateFormatter stringFromDate:messageDate];
}

@implementation RWWeChatMessage

+ (instancetype)message:(id)message type:(RWMessageType)type myMessage:(BOOL)isMyMessage messageDate:(NSDate *)messageDate showTime:(BOOL)showTime
{
    RWWeChatMessage *item = [[RWWeChatMessage alloc] init];
    
    item.showTime = showTime;
    item.message = @{getKey(type):message};
    item.isMyMessage = isMyMessage;
    [item setMessageType:type];
    
    if (messageDate)
    {
        item.messageDate = messageDate;
    }
    
    return item;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _itemHeight = __CELL_LENGTH__;
    }
    
    return self;
}

- (void)setMessageDate:(NSDate *)messageDate
{
    _messageDate = messageDate;
    _dateString = getDate(_messageDate);
}

- (void)setMessageType:(RWMessageType)messageType
{
    _messageType = messageType;
    
    if (_messageType == RWMessageTypeText)
    {
        NSString *text = _message[getKey(messageType)];
        CGSize itemSize = getFitSize(text, __RWCHAT_FONT__, __TEXT_LENGHT__, 0);
        
        _itemHeight = _itemHeight + itemSize.height + __MARGINS__ * 2 + __TEXT_MARGINS__ * 2 - __CELL_LENGTH__;
        
        if (_itemHeight < __CELL_LENGTH__)
        {
            _itemHeight = __CELL_LENGTH__;
        }
    }
    else if (_messageType == RWMessageTypeImage)
    {
        CGSize imageSize = getFitImageSize(_message[getKey(messageType)]);
        
        _itemHeight = imageSize.height + __MARGINS__ * 2;
    }
    
    if (_showTime)
    {
        if (!_dateString)
        {
            _showTime = NO;
            return;
        }
        
        CGSize itemSize = getFitSize(_dateString, __RWGET_SYSFONT(10.f), 0, 1);
        _itemHeight += (itemSize.height + __MARGINS__ + __TIME_MARGINS__ * 2);
    }
}

@end

@implementation RWMarginsLabel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _textLabel = [[UILabel alloc] init];
        [self addSubview:_textLabel];
        _textLabel.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    [self mas_remakeConstraints:autoLayout];
    
    [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(_margins);
        make.left.equalTo(self.mas_left).offset(_margins);
        make.right.equalTo(self.mas_right).offset(-_margins);
        make.bottom.equalTo(self.mas_bottom).offset(-_margins);
    }];
}

- (void)setMargins:(CGFloat)margins
{
    _margins = margins;
    
    if (!_autoLayout)
    {
        return;
    }
    
    [_textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(_margins);
        make.left.equalTo(self.mas_left).offset(_margins);
        make.right.equalTo(self.mas_right).offset(-_margins);
        make.bottom.equalTo(self.mas_bottom).offset(-_margins);
    }];
}

@end

@interface RWChatMenuView ()

@property (nonatomic,strong)RWTextMenu *menu;
@property (nonatomic,strong)UIImageView *arrowhead;
@property (nonatomic,copy)void (^order)(RWTextMenuType type);
@property (nonatomic,copy)void (^autoLayout)(MASConstraintMaker *make);
@property (nonatomic,assign)CGFloat arrowheadX;

@end

CGFloat getArrowheadX(RWWeChatCell *cell)
{
    CGFloat centerX;
    
    switch (cell.message.messageType)
    {
        case RWMessageTypeText: centerX = cell.contentLabel.center.x; break;
        case RWMessageTypeVoice: centerX = cell.voiceButton.center.x; break;
        case RWMessageTypeImage: centerX = cell.contentImage.center.x; break;
        case RWMessageTypeVideo:    break;
        default:break;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat arrowheadX = centerX - (centerX - screenWidth / 2) / 2;
    
    if (arrowheadX < 0)
    {
        return 0;
    }
    
    return arrowheadX;
}

@implementation RWChatMenuView

+ (instancetype)menuWithAutoLayout:(void (^)(MASConstraintMaker *make))autoLayout order:(void (^)(RWTextMenuType type))order message:(RWWeChatMessage *)message arrowheadX:(CGFloat)arrowheadX
{
    RWChatMenuView *view = [[RWChatMenuView alloc] init];
    view.arrowheadX = arrowheadX;
    view.message = message;
    view.order = order;
    view.autoLayout = autoLayout;
    
    return view;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *arrowheadBottom = [[UIImage imageNamed:@"bottomCa"] imageWithColor:[UIColor blackColor]];
        
        _arrowhead = [[UIImageView alloc] initWithImage:arrowheadBottom];
        
        [self addSubview:_arrowhead];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (!_autoLayout)
    {
        return;
    }
    
    [self mas_makeConstraints:_autoLayout];
    
    [_arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.centerX.equalTo(self.mas_centerX).offset(_arrowheadX);
    }];
    
    if (!_menu)
    {
        _menu = [RWTextMenu textMenuWithAutoLayout:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(_arrowhead.mas_top).offset(1);
            
        } responseOrder:^(RWTextMenuType type) {
            
            _order(type);
            
        } isText:(_message.messageType == RWMessageTypeText)];
        
        [self addSubview:_menu];
    }
}

@end

@interface RWTextMenu ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)NSArray *resource;

@property (nonatomic,copy)void (^autoLayout)(MASConstraintMaker *);
@property (nonatomic,copy)void (^order)(RWTextMenuType type);

@end

@implementation RWTextMenu

+ (instancetype)textMenuWithAutoLayout:(void (^)(MASConstraintMaker *))autoLayout responseOrder:(void (^)(RWTextMenuType type))order isText:(BOOL)isText
{
    RWTextMenu *menu = [[RWTextMenu alloc] init];
    menu.autoLayout = autoLayout;
    menu.order = order;
    menu.isText = isText;
    
    return menu;
}

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)
           collectionViewLayout:flowLayout];
    
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        [self registerClass:[RWTextMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([RWTextMenuCell class])];
        
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [self mas_makeConstraints:_autoLayout];
    
    _resource = _isText?@[@"复制",@"转发",@"收藏",@"删除"]:@[@"转发",@"收藏",@"删除"];
    
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _resource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWTextMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWTextMenuCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = _resource[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width / _resource.count, collectionView.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWTextMenuCell *cell = (RWTextMenuCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([cell.textLabel.text isEqualToString:@"复制"])
    {
        _order(RWTextMenuTypeOfCopy);
    }
    else if ([cell.textLabel.text isEqualToString:@"转发"])
    {
        _order(RWTextMenuTypeOfRelay);
    }
    else if ([cell.textLabel.text isEqualToString:@"收藏"])
    {
        _order(RWTextMenuTypeOfCollect);
    }
    else if ([cell.textLabel.text isEqualToString:@"删除"])
    {
        _order(RWTextMenuTypeOfDelete);
    }
}

@end

@implementation RWTextMenuCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.backgroundColor = [UIColor blackColor];
        
        [self addSubview:_textLabel];
        
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0.5);
            make.right.equalTo(self.mas_right).offset(-0.5);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
        }];
    }
    
    return self;
}

@end

@implementation UIImage (changeColor)

- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
