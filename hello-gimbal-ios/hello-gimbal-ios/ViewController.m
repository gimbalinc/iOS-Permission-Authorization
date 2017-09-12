
#import "ViewController.h"
#import <Gimbal/Gimbal.h>

@interface ViewController () <GMBLPlaceManagerDelegate>
@property (nonatomic) GMBLPlaceManager *placeManager;
@property (nonatomic) NSMutableArray *placeEvents;
@property CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.placeEvents = [NSMutableArray new];
    
    // Set the MANAGE_PERMISSIONS option to NO to turn off Gimbal's default location prompt.
    [Gimbal setAPIKey:@"YOUR_API_KEY" options:@{@"MANAGE_PERMISSIONS":@NO}];
    
    // Use CLLocationManager to request WhenInUse location authorization.
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    
    // After a later time or after a user action, request Always location authorization.
    // Note: The user is not given the Never option in phase 2 using this approach.
    [self performSelector:@selector(getAlwaysAuthorizaton)
               withObject:nil
               afterDelay:10];
    
    self.placeManager = [GMBLPlaceManager new];
    self.placeManager.delegate = self;
    
    [Gimbal start];
}

// Method to request Always location authorization.
- (void) getAlwaysAuthorizaton {
    [self.locationManager requestAlwaysAuthorization];
}

# pragma mark - Gimbal Place Manager Delegate methods
- (void)placeManager:(GMBLPlaceManager *)manager didBeginVisit:(GMBLVisit *)visit
{
    NSLog(@"Begin %@", [visit.place description]);
    [self.placeEvents insertObject:visit atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)placeManager:(GMBLPlaceManager *)manager didEndVisit:(GMBLVisit *)visit
{
    NSLog(@"End %@", [visit.place description]);
    [self.placeEvents insertObject:visit atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

# pragma mark - Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.placeEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GMBLVisit *visit = (GMBLVisit*)self.placeEvents[indexPath.row];
    
    if (visit.departureDate == nil)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"Begin: %@", visit.place.name];
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:visit.arrivalDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"End: %@", visit.place.name];
        cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:visit.departureDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle];
    }
    
    return cell;
}


@end
