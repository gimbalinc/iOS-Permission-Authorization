# iOS Permission Authorization Sample App
This implementation exists primarily to demonstrate how you can turn off Gimbal's default location permission prompt to give you more control over how you want to ask users for their location.

Full Gimbal Docs [http://docs.gimbal.com/](http://docs.gimbal.com/)

## If you are using the one-phase approach, you would register Gimbal as is. 
Gimbal will request permission for you after you set your API key.

Objective C:
```[Gimbal setAPIKey:@”YOUR_API_KEY_HERE”];```

Swift:
```Gimbal.setAPIKey("YOUR_API_KEY_HERE")```



## If you are intending to use the two-phase approach

Ask for WhenInUse permission first, and call setAPIKey with the option flag.

Objective C:
```[Gimbal setAPIKey:@”YOUR_API_KEY” options:@{@"MANAGE_PERMISSIONS":@NO}];```

Swift:
```Gimbal.setAPIKey("YOUR_API_KEY", options: ["MANAGE_PERMISSIONS":false])```


Use CLLocationManager to request location authorization while the app is in use.

Objective C:
```@property CLLocationManager *locationManager;
self.locationManager = [[CLLocationManager alloc] init];
[self.locationManager requestWhenInUseAuthorization];```

Swift:
```import CoreLocation
let manager = CLLocationManager()
manager.requestWhenInUseAuthorization()```



Then at a later point prompt the user for always authorization.

Objective C:
```[self.locationManager requestAlwaysAuthorization];```

Swift:
```manager.requestAlwaysAuthorization()```








```objective c


```

```swift
import UIKit

class ViewController: UITableViewController, GMBLPlaceManagerDelegate {
    
    var placeManager: GMBLPlaceManager!
    var placeEvents : [GMBLVisit] = []
    
    override func viewDidLoad() -> Void {
        Gimbal.setAPIKey("PUT_YOUR_GIMBAL_API_KEY_HERE", options: nil)
        
        placeManager = GMBLPlaceManager()
        self.placeManager.delegate = self

        communicationManager = GMBLCommunicationManager()
        self.communicationManager.delegate = self

        Gimbal.start()
    }
    
    func placeManager(manager: GMBLPlaceManager!, didBeginVisit visit: GMBLVisit!) -> Void {
        NSLog("Begin %@", visit.place.description)
        self.placeEvents.insert(visit, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation:UITableViewRowAnimation.Automatic)
    }
    
    func placeManager(manager: GMBLPlaceManager!, didEndVisit visit: GMBLVisit!) -> Void {
        NSLog("End %@", visit.place.description)
        self.placeEvents.insert(visit, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return self.placeEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var visit: GMBLVisit = self.placeEvents[indexPath.row]
        
        if (visit.departureDate == nil) {
            cell.textLabel!.text = NSString(format: "Begin: %@", visit.place.name) as String
            cell.detailTextLabel!.text = NSDateFormatter.localizedStringFromDate(visit.arrivalDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        else {
            cell.textLabel!.text = NSString(format: "End: %@", visit.place.name) as String
            cell.detailTextLabel!.text = NSDateFormatter.localizedStringFromDate(visit.arrivalDate, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.MediumStyle)
        }
        
        return cell
    }
}
