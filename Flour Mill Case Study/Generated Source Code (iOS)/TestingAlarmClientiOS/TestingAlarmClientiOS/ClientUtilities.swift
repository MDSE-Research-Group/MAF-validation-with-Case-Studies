
import Foundation

class ClientUtilities  {
	 		class func getTypeEnum(from : String?) -> AlarmType {	
	 					var typeElement: AlarmType = .LIMIT
	 		        if let typeValue = from {
	 		            switch typeValue {
	 		            case "LIMIT":
	 		                typeElement = .LIMIT
	 		            case "ROC":
	 		                typeElement = .ROC
	 		            case "DIGITAL":
	 		                typeElement = .DIGITAL
	 		            case "DEVIATION":
	 		                typeElement = .DEVIATION
	 		            default:
	 		                typeElement = .LIMIT
	 		            }
	 		        }
	 		        return typeElement
	 			}
	 
	 		class func makeJSONStringFromArray(alarmsList: [Alarm]) -> Data {	
	 					let jsonEncoder = JSONEncoder()
	 		        var jsonData : NSData!
	 		        do {
	 		            jsonData =  try jsonEncoder.encode(alarmsList) as NSData
	 		            var jsonString = String(data: jsonData as Data , encoding: String.Encoding.utf8)
	 		//            print(jsonString ?? "CHUSS")
	 		            let prefix = "{\"alarms\": "
	 		            let suffix = "}"
	 		            jsonString = prefix + jsonString! + suffix
	 		//            print(jsonString ?? "Again CHUSS")
	 		            jsonData = nil
	 		            jsonData = Data(jsonString!.utf8) as NSData
	 		        } catch let error as NSError {
	 		            print("Array to JSON conversion failed: \(error.localizedDescription)")
	 		        }
	 		        return jsonData as Data
	 			}
	 
	 		class func getCurrentTimeStamp() -> String {	
	 					let date = Date()
	 		        let calendar = Calendar.current
	 		        let hour = calendar.component(.hour, from: date)
	 		        let minutes = calendar.component(.minute, from: date)
	 		        let seconds = calendar.component(.second, from: date)
	 		        
	 		        let timeStamp = "\(hour):\(minutes):\(seconds)"
	 		        return timeStamp
	 			}
	 
	 		class func getSeverityEnum(from : String?) -> AlarmSeverity {	
	 					var severityElement: AlarmSeverity = .NORMAL
	 		        if let severityValue = from {
	 		            switch severityValue {
	 		            case "LOW":
	 		                severityElement = .LOW
	 		            case "MEDIUM":
	 		                severityElement = .MEDIUM
	 		            case "High":
	 		                severityElement = .HIGH
	 		            case "CRITICAL":
	 		                severityElement = .CRITICAL
	 		            case "CATASTROPHIC":
	 		                severityElement = .CATASTROPHIC
	 		            default:
	 		                severityElement = .NORMAL
	 		            }
	 		        }
	 		        return severityElement
	 			}
	 
}
extension String {
    func trimWhiteSpaces() -> String {
        let whiteSpaceSet = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whiteSpaceSet)
    }
}
