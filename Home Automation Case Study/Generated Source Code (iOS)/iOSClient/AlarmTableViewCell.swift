import UIKit
class AlarmTableViewCell : UITableViewCell {
		 @IBOutlet weak var alarmValue  :  UILabel! 

		 @IBOutlet weak var alarmAcknowledged  :  UILabel! 

		

		 @IBOutlet weak var alarmMessage  :  UILabel! 

		 @IBOutlet weak var alarmTitle  :  UILabel! 

		 @IBOutlet weak var alarmLimit  :  UILabel! 
	override 		func setSelected(_ selected:Bool,animated:Bool)  {	
						super.setSelected(selected, animated: animated)
				}
	
}
