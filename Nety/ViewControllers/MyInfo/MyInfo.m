//
//  MyInfo.m
//  Nety
//
//  Created by Scott Cho on 6/20/16.
//  Copyright © 2016 Scott Cho. All rights reserved.
//

#import "MyInfo.h"
#import "Experiences.h"

@interface MyInfo ()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation MyInfo
@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View Load
//---------------------------------------------------------


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeDesign];
    
    NSLog(@"%@", MY_USER);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    
    numberOfComponents = 7 + (int)[sectionInfo numberOfObjects];
    
    [self initializeSettings];
    
    [self.tableView reloadData];
    
}


#pragma mark - Initialization
//---------------------------------------------------------


- (void)initializeSettings {
    
    self.firdatabase = [[FIRDatabase database] reference];
    
}

- (void)initializeDesign {
    
    self.UIPrinciple = [[UIPrinciples alloc] init];
    
    //Color for the small view
    NSString *name = [NSString stringWithFormat:@"%@ %@", MY_USER.firstName, MY_USER.lastName];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationItem.title = name;
    
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    //If image is not NetyBlueLogo, start downloading and caching the image
    NSString *photoUrl = MY_USER.profileImageUrl;
    self.profileImageView = [[UIImageView alloc] init];
    
    if (![photoUrl isEqualToString:kDefaultUserLogoName]) {
        NSURL *profileImageUrl = [NSURL URLWithString:photoUrl];
        [self.profileImageView sd_setImageWithURL:profileImageUrl placeholderImage:[UIImage imageNamed:kDefaultUserLogoName]];
    } else {
        self.profileImageView.image = [UIImage imageNamed:kDefaultUserLogoName];
    }
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height / 2.2;
    
    [self.profileImageView setFrame:CGRectMake(0, 0, width, height)];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.tableView addParallaxWithView:self.profileImageView andHeight:height];
    [self.tableView.parallaxView setDelegate:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setAllowsSelection:YES];
    
    //Configure tableview height
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
}


#pragma mark - Protocols and Delegates
//---------------------------------------------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfComponents;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) {
        return 10;
    } else {
        return UITableViewAutomaticDimension;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *status = MY_USER.status;
    NSString *summary = MY_USER.summary;
    NSString *identity = MY_USER.identity;
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    
    NSArray *experiences = [sectionInfo objects];
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoSpaceCell" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (indexPath.row >= 1 && indexPath.row <= 3) {
        
        MyInfoMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoMainCell" forIndexPath:indexPath];
        
        cell.mainInfoLabel.textColor = self.UIPrinciple.netyBlue;
        
        [cell.mainInfoImage setTintColor:self.UIPrinciple.netyBlue];
        
        switch (indexPath.row) {
            case 1:
                cell.mainInfoImage.image = [[UIImage imageNamed:@"Identity"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
                if ([identity isEqualToString:@""]) {
                    cell.mainInfoLabel.text = @"No description";
                } else {
                    cell.mainInfoLabel.text = identity;
                }
                
                break;
            case 2: {
                cell.mainInfoImage.image = [[UIImage imageNamed:@"Status"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
                if ([status isEqualToString:@""]) {
                    cell.mainInfoLabel.text = @"No status";
                } else {
                    cell.mainInfoLabel.text = status;
                }
                
                break;
            }
            case 3: {
                cell.mainInfoImage.image = [[UIImage imageNamed:@"Summary"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                
                if ([summary isEqualToString:@""]) {
                    cell.mainInfoLabel.text = @"No summary";
                } else {
                    cell.mainInfoLabel.text = summary;
                }
                
                break;
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
        
    } else if (indexPath.row >= 4 && indexPath.row <= 5) {
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoSpaceCell" forIndexPath:indexPath];
        
        if (indexPath.row == 4) {
            
            float cellHeight = cell.contentView.frame.size.height;
            float cellWidth = cell.contentView.frame.size.width;
            
            UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight - 1, cellWidth, 1)];/// change size as you need.
            separatorLineView.backgroundColor = self.UIPrinciple.netyBlue;
            [cell.contentView addSubview:separatorLineView];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } else if (indexPath.row == 6) {
        
        MyInfoMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoMainCell" forIndexPath:indexPath];
        
        cell.mainInfoImage.image = [[UIImage imageNamed:@"LightBulbSmall"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        [cell.mainInfoImage setTintColor:self.UIPrinciple.netyBlue];
        
        cell.mainInfoLabel.textColor = self.UIPrinciple.netyBlue;
        
        if ([experiences count] == 0) {
            cell.mainInfoLabel.text = @"No experiences";
        } else {
            cell.mainInfoLabel.text = @"Experiences";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
        
    } else {
        
        MyInfoExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyInfoExperienceCell" forIndexPath:indexPath];
        
        Experiences* expir = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-7 inSection:0]];
        
        NSLog(@"Ex: %@",expir);
        
        cell.experienceName.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDate.textColor = self.UIPrinciple.netyBlue;
        cell.experienceDescription.textColor = self.UIPrinciple.netyBlue;
        
        cell.experienceName.text = expir.name;
        cell.experienceDate.text = expir.endDate;
        
        cell.experienceDescription.text = expir.descript;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch(indexPath.row) {
            
        case 1: {
            MyInfoEditType1 *editNameAndIdentity = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditType1"];
            
            [self.navigationController pushViewController:editNameAndIdentity animated:YES];
            
            break;
        }
        case 2: {
            MyInfoEditType2 *editStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditType2"];
            
            editStatus.statusOrSummary = 0;
            
            [self.navigationController pushViewController:editStatus animated:YES];
            
            break;
        }
        case 3: {
            MyInfoEditType2 *editSummary = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditType2"];
            
            editSummary.statusOrSummary = 1;
            
            [self.navigationController pushViewController:editSummary animated:YES];
            
            break;
        }
        case 6: {
            MyInfoEditTable *editTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoEditTable"];
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
            
            NSMutableArray* array = [NSMutableArray array];
            for (Experiences* expir in [sectionInfo objects])
            {
                NSMutableDictionary *rowData = [NSMutableDictionary dictionary];
                
                [rowData setObject:expir.descript forKey:@"description"];
                [rowData setObject:expir.endDate forKey:@"endDate"];
                [rowData setObject:expir.name forKey:@"name"];
                [rowData setObject:expir.startDate forKey:@"startDate"];
                [array addObject:rowData];
            }
            
            editTableVC.experienceArray = array;
            
            [self.navigationController pushViewController:editTableVC animated:YES];
            
            break;
        }
            
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


//When photo choosing screen shows, customize nav controller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //Customizing view controller here
    [viewController.navigationController.navigationBar setBackgroundColor:self.UIPrinciple.netyBlue];
    [viewController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [viewController.navigationController.navigationBar setTranslucent:NO];
    [self.UIPrinciple addTopbarColor:viewController];
    
    //Style navbar
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [self.UIPrinciple netyFontWithSize:18], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [viewController.navigationController.navigationBar setTitleTextAttributes:attributes];
    
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //You can retrieve the actual UIImage
    
    [self changeImage:picker getInfo:info];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Buttons
//---------------------------------------------------------


//For image tapped
- (IBAction)imageTapped:(id)sender {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = (id)self;
    pickerLibrary.allowsEditing = YES;
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:pickerLibrary animated:YES completion:nil];
    
    NSLog(@"tapped");
}


#pragma mark - View Disappear
//---------------------------------------------------------



#pragma mark - Custom methods
//---------------------------------------------------------


-(void)changeImage: (UIImagePickerController *)picker getInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedimage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (![UIImagePNGRepresentation(image) isEqualToData:UIImagePNGRepresentation(editedimage)]) {
        image = editedimage;
    }
    
    
    //Get userID and save to database
    NSString *userID = MY_USER.userID;
    
    //Uploading profile image
    NSString *uniqueImageID = [[NSUUID UUID] UUIDString];
    
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *profileImageRef = [[[storage reference] child:@"profileImages"] child:uniqueImageID];
    
    //If user doesn't set profile image, set it to default image without uploading it.
    NSData *pickedImage = UIImagePNGRepresentation(image);
    NSData *originalImage = UIImagePNGRepresentation(self.profileImageView.image);
    
    if (![originalImage isEqualToData:pickedImage]) {
        
        NSData *uploadData = pickedImage;
        
        [profileImageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"%@", error.localizedDescription);
                [self.UIPrinciple oneButtonAlert:@"OK" controllerTitle:@"Can not upload image" message:@"Please try again at another time" viewController:self];
                
            } else {
                
                NSLog(@"image url saved");
                
                [[[[self.firdatabase child:kUsers] child:userID] child:kProfilePhoto] setValue: [[metadata downloadURL] absoluteString]];
                
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
            
        }];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}


//---------------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CoreData

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Experiences" inManagedObjectContext:MY_API.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"user == %@",MY_USER];

    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:MY_API.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    [_tableView reloadData];
}

@end
