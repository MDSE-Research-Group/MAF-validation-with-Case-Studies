import UIKit

import CoreGraphics
import Alamofire
import MBProgressHUD

class ViewController : UIViewController,  AlarmAcknowledgmentDelegate,  UITableViewDataSource,  UITableViewDelegate {
	@IBOutlet weak var alarmSegment  :  UISegmentedControl!

	@IBOutlet weak var timeStampLabel  :  UILabel!

	@IBOutlet weak var tableView  :  UITableView!
@IBOutlet weak var timeStampView: UIView!
lazy var alarmsList = [Alarm]()
lazy var historicalAlarms = [Alarm]()
let sectionHeaders = ["LIMIT", "ROC", "DEVIATION", "DIGITAL"]
let commentsSegueIdentifier = "cellSelectionSegue"

 @IBAction func refreshButtonTapped(sender:Any)  {	
 			populateRecentAlarmArray()
 	}

 @IBAction func alarmSegmentVlaueChanged(sender:Any)  {	
 			if (alarmSegment.selectedSegmentIndex == 0){ // Recent Alarms
 //            populateRecentAlarmArray()
         }else if (alarmSegment.selectedSegmentIndex == 1) { // Historical Alarms
             populateHistoricalAlarmArray()
         }
          self.tableView.reloadData()
 	}

func populateRecentAlarmArray()  {	
			let hud = MBProgressHUD.showAdded(to: (self.navigationController?.view)!, animated: true)
        hud.label.text = "Loading Alarms..."
        self.alarmsList.removeAll()
        self.timeStampLabel.text = "Checking alarms..."
        let urlString = "\(Constants.Alarm_Server_IP_Address)\(Constants.Alarm_Server_Port)\(Constants.GET_ALL_ALARMS)"
        DataSyncHandler.defaultHandler.fetchAllRecentAlarmsFromServer(urlString: urlString) { (alarms, success, errorString) in
                    if (!errorString.isEmpty){
                        self.showAlert(with: "Error", message: errorString )
                    }else{
                        self.alarmsList = alarms!
                        self.timeStampLabel.text = "Updated at \(ClientUtilities.getCurrentTimeStamp())"
                    }
                    self.tableView.reloadData()
            hud.hide(animated: true)
            }
	}

func populateHistoricalAlarmArray()  {	
			historicalAlarms.removeAll()
        let alarms = DataSyncHandler.defaultHandler.readHistoricalAlarmFromJSONFile()
        historicalAlarms = alarms
        self.tableView.reloadData()
	}

func setUpTableViewCell(alarmObj : Alarm?,cell:AlarmTableViewCell)  {	
			if (alarmObj != nil) {
            cell.alarmTitle.text = alarmObj!.alarmTitle
            cell.alarmValue.text = String(alarmObj!.alarmCurrentValue)
            cell.alarmAcknowledged.text = "     >"
            
            var severity = AlarmSeverity.NORMAL
            var message = alarmObj?.alarmDescription
            switch (alarmObj!.alarmType) {
                
            case .LIMIT:
               if let limit = alarmObj as? LimitAlarm {
                let tempTuple = getLimitAlarmLogic(limit: limit)
                    severity = tempTuple.severity
                    message = tempTuple.message
                }
            case .DEVIATION:
                if let deviation = alarmObj as? DeviationAlarm {
                    let tempTuple = getDeviationAlarmLogic(deviation: deviation)
                    severity = tempTuple.severity
                    message = tempTuple.message
                }
            case .ROC:
                if let roc = alarmObj as? ROCAlarm {
                    let rangeValue = roc.alarmRange.value
                    if(roc.alarmCurrentValue >= rangeValue.lowercased()) {
                        message = roc.alarmRange.message
                        severity = roc.alarmRange.severityLevel
                    }
                }
            case .DIGITAL:
                if let digital = alarmObj as? DigitalAlarm {
                    let rangeValue = digital.alarmRange.value
                    if(digital.alarmCurrentValue.lowercased() == rangeValue.lowercased()) {
                        message = digital.alarmRange.message
                        severity = digital.alarmRange.severityLevel
                    }
                }
            }
            cell.alarmLimit.text = severity.rawValue
            cell.alarmMessage.text = message
            cell.contentView.backgroundColor = getAlarmCellColorAsPerSeverity(severity: severity)
            cell.alarmTitle.textColor = alarmObj!.isSupressed ? UIColor.lightGray : UIColor.black
            cell.alarmLimit.textColor = alarmObj!.isSupressed ? UIColor.lightGray : UIColor.black
            cell.alarmValue.textColor = alarmObj!.isSupressed ? UIColor.lightGray : UIColor.black
            cell.alarmMessage.textColor = alarmObj!.isSupressed ? UIColor.lightGray : UIColor.black
        }
	}

func getAppropriateArray(forSection:Int) -> [Alarm] {	
			var array = [Alarm]()
        if (alarmSegment.selectedSegmentIndex == 0){
            array = alarmsList.filter({ (alarm) -> Bool in
                alarm.alarmType == ClientUtilities.getTypeEnum(from: sectionHeaders[forSection])})
        }else if (alarmSegment.selectedSegmentIndex == 1){
            array = historicalAlarms.filter({ (alarm) -> Bool in
                alarm.alarmType == ClientUtilities.getTypeEnum(from: sectionHeaders[forSection])})
        }
        return array
	}

func showAlert(with title:String,message:String)  {	
			let alert = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("you pressed OK button")
        })
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
	}

func getAlarmCellColorAsPerSeverity(severity:AlarmSeverity) -> UIColor {	
			switch(severity){
        case .CATASTROPHIC:
            return Constants.Catastrophic_Color
        case .NORMAL:
            return Constants.Normal_Color
        case .LOW:
            return Constants.Low_Color
        case .MEDIUM:
            return Constants.Medium_Color
        case .HIGH:
            return Constants.High_Color
        case .CRITICAL:
            return Constants.Critical_Color
        }
	}

func getDeviationAlarmLogic(deviation:DeviationAlarm) -> (severity: AlarmSeverity, message: String) {	
			 var severity = AlarmSeverity.NORMAL
        var message = deviation.alarmDescription
        
        let exLowRangeValue = Double(deviation.exLow.value) ?? 0.0
        let lowLowRangeValue = Double(deviation.lowLow.value) ?? 0.0
        let lowRangeValue = Double(deviation.low.value) ?? 0.0
        let normalRangeValue = Double(deviation.normal.value) ?? 0.0
        let highRangeValue = Double(deviation.high.value) ?? 0.0
        let highHighRangeValue = Double(deviation.highHigh.value) ?? 0.0
        let exHighRangeValue = Double(deviation.exHigh.value) ?? 0.0
        
        let currentValue = Double(deviation.alarmCurrentValue) ?? 0.0
        let deadBand = deviation.deadBand
        
        if (deadBand..<exLowRangeValue).contains(currentValue){
            message = "It is Catastrophic!!!"
            severity = AlarmSeverity.CATASTROPHIC
        }else if ((exLowRangeValue..<lowLowRangeValue).contains(currentValue)) {
            message = deviation.exLow.message
            severity = deviation.exLow.severityLevel
        }else if(lowLowRangeValue..<lowRangeValue).contains(currentValue){
            message = deviation.lowLow.message
            severity = deviation.lowLow.severityLevel
        }else if(lowRangeValue..<normalRangeValue).contains(currentValue){
            message = deviation.low.message
            severity = deviation.low.severityLevel
        }else if(normalRangeValue..<highRangeValue).contains(currentValue){
            message = deviation.normal.message
            severity = deviation.normal.severityLevel
        }else if(highRangeValue..<highHighRangeValue).contains(currentValue){
            message = deviation.high.message
            severity = deviation.high.severityLevel
        }else if(highHighRangeValue..<exHighRangeValue).contains(currentValue){
            message = deviation.highHigh.message
            severity = deviation.highHigh.severityLevel
        }else if (currentValue >= exHighRangeValue){
            message = deviation.exHigh.message
            severity = deviation.exHigh.severityLevel
        }
        return(severity, message)
	}

func getLimitAlarmLogic(limit:LimitAlarm) -> (severity: AlarmSeverity, message: String) {	
			var severity = AlarmSeverity.NORMAL
        var message = limit.alarmDescription
        
        let exLowRangeValue = Double(limit.exLow.value) ?? 0.0
        let lowLowRangeValue = Double(limit.lowLow.value) ?? 0.0
        let lowRangeValue = Double(limit.low.value) ?? 0.0
        let normalRangeValue = Double(limit.normal.value) ?? 0.0
        let highRangeValue = Double(limit.high.value) ?? 0.0
        let highHighRangeValue = Double(limit.highHigh.value) ?? 0.0
        let exHighRangeValue = Double(limit.exHigh.value) ?? 0.0
        
        let currentValue = Double(limit.alarmCurrentValue) ?? 0.0
        let deadBand = limit.deadBand
        
        if (deadBand..<exLowRangeValue).contains(currentValue){
            message = "It is Catastrophic!!!"
            severity = AlarmSeverity.CATASTROPHIC
        }else if ((exLowRangeValue..<lowLowRangeValue).contains(currentValue)) {
            message = limit.exLow.message
            severity = limit.exLow.severityLevel
        }else if(lowLowRangeValue..<lowRangeValue).contains(currentValue){
            message = limit.lowLow.message
            severity = limit.lowLow.severityLevel
        }else if(lowRangeValue..<normalRangeValue).contains(currentValue){
            message = limit.low.message
            severity = limit.low.severityLevel
        }else if(normalRangeValue..<highRangeValue).contains(currentValue){
            message = limit.normal.message
            severity = limit.normal.severityLevel
        }else if(highRangeValue..<highHighRangeValue).contains(currentValue){
            message = limit.high.message
            severity = limit.high.severityLevel
        }else if(highHighRangeValue..<exHighRangeValue).contains(currentValue){
            message = limit.highHigh.message
            severity = limit.highHigh.severityLevel
        }else if (currentValue >= exHighRangeValue){
            message = limit.exHigh.message
            severity = limit.exHigh.severityLevel
        }
        return(severity, message)
	}




func prepare(segue:UIStoryboardSegue,sender:Any)  {	
			if  segue.identifier == commentsSegueIdentifier,
            let destination = segue.destination as? CommentsViewController,
            let alarmIndex = tableView.indexPathForSelectedRow{
            let array = getAppropriateArray(forSection: alarmIndex.section)
            destination.alarmObj = array[alarmIndex.row]
            destination.customDelegate = self
            destination.historicalAlarm = self.alarmSegment.selectedSegmentIndex == 1 ? true: false
        }
	}


func tableView(_ tableView:UITableView,titleForHeaderInSection section:Int) -> String? {	
			return sectionHeaders[section]
	}


override func didReceiveMemoryWarning()  {	
			super.didReceiveMemoryWarning()
	}


func numberOfSections(in tableView:UITableView) -> Int {	
			let count = sectionHeaders.count
        return count
	}


func alarmNotAcknowledged()  {	
			self.tableView.reloadData()
	}


func tableView(_ tableView:UITableView,canEditRowAt indexPath:IndexPath) -> Bool {	
			if (alarmSegment.selectedSegmentIndex == 1) { return true} else {return false}
	}


func tableView(_ tableView:UITableView,editActionsForRowAt indexPath:IndexPath) -> [UITableViewRowAction]? {	
			if (alarmSegment.selectedSegmentIndex == 1) {
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                // delete item at indexPath
                self.alarmsList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print(self.alarmsList)
            }
            return [delete]
        }else {return nil}
	}


func tableView(_ tableView:UITableView,numberOfRowsInSection section:Int) -> Int {	
			let array = getAppropriateArray(forSection: section)
        var rowCount = 0
        rowCount = array.count > Constants.Number_OF_Rows_For_Type ? Constants.Number_OF_Rows_For_Type : array.count
        return rowCount
	}


func alarmAcknowledgementWithComments(alarmObj:Alarm)  {	
			if let index = alarmsList.index(where: {$0.alarmId == alarmObj.alarmId}) {
            alarmsList.remove(at: index)
        }
        var alarmsArray = DataSyncHandler.defaultHandler.readHistoricalAlarmFromJSONFile()
        alarmsArray.append(alarmObj)
        print(alarmsArray)
        let deletionStatus = DataSyncHandler.defaultHandler.deleteFile()
        if deletionStatus {
            DataSyncHandler.defaultHandler.writeHistoricalAlarmToJSONFile(alarms: alarmsArray)
        }
        
        self.tableView.reloadData()
	}


func tableView(_ tableView:UITableView,didSelectRowAt indexPath:IndexPath)  {	
			let array = getAppropriateArray(forSection: indexPath.section)
        let alarmObj = array[indexPath.row]
        if (alarmObj.isSupressed || alarmObj.isAcknowledged){
            tableView.deselectRow(at: indexPath, animated: false)}
        self.performSegue(withIdentifier: commentsSegueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
	}


	override func viewDidLoad() {
		super.viewDidLoad()
        self.title = "Alarms"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_background")!)
        timeStampView.backgroundColor = UIColor(patternImage: UIImage(named: "paper_background2")!)
        populateRecentAlarmArray()
        Timer.scheduledTimer(withTimeInterval: Constants.Repeat_Timer_In_Seconds, repeats: Constants.Auto_Sync) { timer in
            print("Timer fired!")
            self.populateRecentAlarmArray()
        }
    }


func tableView(_ tableView:UITableView,cellForRowAt indexPath:IndexPath) -> UITableViewCell {	
			let cell  = tableView.dequeueReusableCell(withIdentifier: "AlarmCellIdentifier", for: indexPath) as! AlarmTableViewCell        
        let array = getAppropriateArray(forSection: indexPath.section)
        let alarmObj  = array[indexPath.row]
    setUpTableViewCell(alarmObj: alarmObj, cell: cell)
        return cell
	}

}
