# iOS Permission Authorization Sample App
This implementation exists primarily to demonstrate how you can turn off Gimbal's default location permission prompt to give you more control over how you want to ask users for their location.

We have an excellent blog article that discusses best practices with Apple's changes to location authorization, located here https://gimbal.com/ios11-location-services-best-practices/.

Full Gimbal Docs [http://docs.gimbal.com/](http://docs.gimbal.com/)

## You can only ask for location once.
This means this demo will only work once. To see how the prompts appear again, you must delete and reinstall the app.

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
```
@property CLLocationManager *locationManager;
self.locationManager = [[CLLocationManager alloc] init];
[self.locationManager requestWhenInUseAuthorization];
```

Swift:
```
import CoreLocation
let manager = CLLocationManager()
manager.requestWhenInUseAuthorization()
```



Then at a later point prompt the user for always authorization.

Objective C:
```[self.locationManager requestAlwaysAuthorization];```

Swift:
```manager.requestAlwaysAuthorization()```




