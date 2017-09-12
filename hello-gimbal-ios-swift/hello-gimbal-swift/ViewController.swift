import UIKit
import CoreLocation

class ViewController: UITableViewController, GMBLPlaceManagerDelegate, GMBLCommunicationManagerDelegate {
    
    var placeManager: GMBLPlaceManager!
    var communicationManager: GMBLCommunicationManager!
    var placeEvents : [GMBLVisit] = []
    
    // Use CLLocationManager to access location.
    var manager = CLLocationManager()
    
    override func viewDidLoad() -> Void {
        Gimbal.setAPIKey("PUT_YOUR_GIMBAL_API_KEY_HERE", options: ["MANAGE_PERMISSIONS":false])
        
        placeManager = GMBLPlaceManager()
        self.placeManager.delegate = self
        
        communicationManager = GMBLCommunicationManager()
        self.communicationManager.delegate = self
        
        // Request location when the app is in use.
        manager.requestWhenInUseAuthorization()
        
        // After some delay or use action prompt the user for access Always.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.requestAlwaysAuthorization()
        })
        Gimbal.start()
    }
    
    // Request Always authorization.
    func requestAlwaysAuthorization() {
        manager.requestAlwaysAuthorization()
    }
    
    func placeManager(_ manager: GMBLPlaceManager!, didBegin visit: GMBLVisit!) -> Void {
        NSLog("Begin %@", visit.place.description)
        self.placeEvents.insert(visit, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with:UITableViewRowAnimation.automatic)
    }
    
    func placeManager(_ manager: GMBLPlaceManager!, didEnd visit: GMBLVisit!) -> Void {
        NSLog("End %@", visit.place.description)
        self.placeEvents.insert(visit, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
    func communicationManager(_ manager: GMBLCommunicationManager!, presentLocalNotificationsForCommunications communications: [Any]!, for visit: GMBLVisit!) -> [Any]! {
        return communications
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> NSInteger {
        return self.placeEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let visit: GMBLVisit = self.placeEvents[indexPath.row]
        
        if (visit.departureDate == nil) {
            cell.textLabel!.text = NSString(format: "Begin: %@", visit.place.name) as String
            cell.detailTextLabel!.text = DateFormatter.localizedString(from: visit.arrivalDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.medium)
        }
        else {
            cell.textLabel!.text = NSString(format: "End: %@", visit.place.name) as String
            cell.detailTextLabel!.text = DateFormatter.localizedString(from: visit.departureDate, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.medium)
        }
        
        return cell
    }
}

