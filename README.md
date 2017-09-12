# iOS Permission Authorization Sample App
This implementation exists primarily to demonstrate how you can turn off Gimbal's default location permission prompt to give you more control over how you want to ask users for their location.

We have an excellent blog article that discusses best practices with Apple's changes to location authorization. https://gimbal.com/ios11-location-services-best-practices/

Full Gimbal Docs [http://docs.gimbal.com/](http://docs.gimbal.com/)

## You can only ask for location once.
This means this demo will only work once. To see how the prompts appear again, you must delete and reinstall the app.

## Default Implementation
By default, Gimbal will request “ALWAYS” location permission when [Gimbal start] is called. If you are using the one-phase approach nothing needs to be done - simply set your API key and start Gimbal. 

Objective C:
```
[Gimbal setAPIKey:@"YOUR_API_KEY_HERE"];
[Gimbal start];
```
Swift:
```
Gimbal.setAPIKey("YOUR_API_KEY_HERE")
Gimbal.start()
```

## Custom Implementation
If you are intending to use the two-phase approach, where you initially ask the user the “When In Use” permission and later, when trust has been established, you ask for “Always” permission. You need to tell Gimbal not to ask for permission on your behalf. To do this, you must call setAPIKey with the MANAGE_PERMISSIONS option flag.

Objective C:
```[Gimbal setAPIKey:@”YOUR_API_KEY” options:@{@"MANAGE_PERMISSIONS":@NO}];```

Swift:
```Gimbal.setAPIKey("YOUR_API_KEY", options: ["MANAGE_PERMISSIONS":false])```

Then, typically before you start Gimbal, you use CLLocationManager to request location authorization while the app is in use.

Objective C:
```
@property CLLocationManager *locationManager;
self.locationManager = [[CLLocationManager alloc] init];
[self.locationManager requestWhenInUseAuthorization];
```

Swift:
```
let manager = CLLocationManager()
manager.requestWhenInUseAuthorization()
```


Then start Gimbal:

Objective C:
```[Gimbal start];```

Swift:
```Gimbal.start()```



Then at a later point, when the user has become comfortable with sharing their location, prompt the user for always authorization.

Objective C:
```[self.locationManager requestAlwaysAuthorization];```

Swift:
```manager.requestAlwaysAuthorization()```



At this point, Gimbal will recognize that the location permission has been changed and will start monitoring places at all times.








