//
//  Messages.m
//  Nety
//
//  Created by Scott Cho on 7/7/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "Messages.h"

@interface Messages ()

@end

@implementation Messages

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeSettings];
    [self initializeDesign];
    [self addDemoMessages];
}

- (void)initializeSettings {
    self.senderId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    self.senderDisplayName = [[[UIDevice currentDevice] identifierForVendor] UUIDString];

    self.messages = [[NSMutableArray alloc] init];
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Set up message style
    JSQMessagesBubbleImageFactory *incomingImage = [[JSQMessagesBubbleImageFactory alloc] init];
    JSQMessagesBubbleImageFactory *outgoingImage = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageView = [outgoingImage outgoingMessagesBubbleImageWithColor:self.UIPrinciple.netyBlue];
    self.incomingBubbleImageView = [incomingImage incomingMessagesBubbleImageWithColor:self.UIPrinciple.netyGray];

    //Set up avatar image
    self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"NetyBlueLogo"] diameter:37.0f];
    
    //Set user avatar size to zero
    [[self.collectionView collectionViewLayout] setOutgoingAvatarViewSize:CGSizeZero];
    [[self.collectionView collectionViewLayout] setIncomingAvatarViewSize:CGSizeMake(37.0f, 37.0f)];
    [[self.collectionView collectionViewLayout] setMessageBubbleLeftRightMargin:150.0f];
    
    //Add top bar
    [self.UIPrinciple addTopbarColor:self];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    
    UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 50)];
    navbar.backgroundColor = self.UIPrinciple.netyBlue;
    [navbar setTranslucent:NO];
    
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = @"chat";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    navItem.leftBarButtonItem = leftButton;
    
    navbar.items = @[navItem];
    
    [self.view addSubview:navbar];
}

- (void)addDemoMessages {
    NSString *sender;
    
    for (int i = 1; i <= 10; i ++) {
        if (i % 2 == 0) {
            sender = @"server";
        } else {
            sender = self.senderId;
        }
        
        NSString *messageContent = [NSString stringWithFormat:@"Messages rn. %i", i];
        NSDate *todaysDate = [NSDate date];
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:sender senderDisplayName:sender date:todaysDate text:messageContent];
        
        [self.messages addObject:message];
        
    }
    
    //Reload messages
    [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.messages.count;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = self.messages[indexPath.row];
    return data;
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath {
    [self.messages removeObjectAtIndex:indexPath.row];
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {

    JSQMessage *data = self.messages[indexPath.row];
    
    if (data.senderId == self.senderId) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
    
}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *data = self.messages[indexPath.row];

    if (data.senderId == self.senderId) {
        return nil;
    } else {
        return self.incomingBubbleAvatarImage;
    }
}

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    
    [self.messages addObject:message];
    [self finishSendingMessage];
    
}

-(void)didPressAccessoryButton:(UIButton *)sender {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
