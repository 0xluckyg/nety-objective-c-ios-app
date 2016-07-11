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
    JSQMessagesBubbleImageFactory *incomingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleCompactTaillessImage] capInsets:UIEdgeInsetsZero];
    JSQMessagesBubbleImageFactory *outgoingImage = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage jsq_bubbleCompactTaillessImage] capInsets:UIEdgeInsetsZero];

    
    self.outgoingBubbleImageView = [outgoingImage outgoingMessagesBubbleImageWithColor:self.UIPrinciple.netyBlue];
    self.incomingBubbleImageView = [incomingImage incomingMessagesBubbleImageWithColor:self.UIPrinciple.netyGray];

    //Set up avatar image
    self.incomingBubbleAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"NetyBlueLogo"] diameter:35.0f];
    
    
    //Set user avatar size to zero
    [[self.collectionView collectionViewLayout] setOutgoingAvatarViewSize:CGSizeZero];
    [[self.collectionView collectionViewLayout] setIncomingAvatarViewSize:CGSizeMake(35.0f, 35.0f)];
    [[self.collectionView collectionViewLayout] setMessageBubbleLeftRightMargin:150.0f];
    
    //Set font
    [[self.collectionView collectionViewLayout] setMessageBubbleFont:[self.UIPrinciple netyFontWithSize:15]];
    
    //Change buttons
    
    [self.inputToolbar.contentView.leftBarButtonItem setImage:[[UIImage imageNamed:@"Camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:normal];
    self.inputToolbar.contentView.leftBarButtonItem.tintColor = self.UIPrinciple.netyGray;
    self.inputToolbar.contentView.textView.font = [self.UIPrinciple netyFontWithSize:15];
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"Send" forState:normal];

    
    
    //Style the navigation bar
    UINavigationItem *navItem= [[UINavigationItem alloc] init];
    navItem.title = @"chat";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:normal target:self action:@selector(bacButtonPressed)];
    
    navItem.leftBarButtonItem = leftButton;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [self.navigationController.navigationBar setItems:@[navItem]];
    [self.navigationController.navigationBar setBarTintColor:self.UIPrinciple.netyBlue];
    [self.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)bacButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

//Date for top labels
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 6 == 0) {
//        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:[NSDate date]];
    }

    return nil;
}


//Height for top labels
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 6 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}


- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Source"
                                                                   message:@"This is an alert."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          
                                                      }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
