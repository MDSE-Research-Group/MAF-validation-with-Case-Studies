import Foundation
import UIKit

struct Constants {








	static let Low_Color =   UIColor.green

	static let Critical_Color =   UIColor(displayP3Red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1.0) 

	static let Alarm_Server_Port =  ":5500"
    
    static let Alarm_Server_IP_Address =  "http://192.168.31.168"

	static let Catastrophic_Color =   UIColor.red

	static let Auto_Sync =   true 

	static let High_Color =   UIColor.orange

	static let GET_ALL_ALARMS =  "/api/get/all" 

	static let Repeat_Timer_In_Seconds =   360.0

	static let Normal_Color =   UIColor.white

	static let MALFORMED_DATA_RECEIVED =  "Malformed data received from fetchAllAlarms service. Please verify your request" 

	static let INTERNET_NOT_AVAILABLE_MESSAGE =  "NETWORK NOT FOUND. Please check your internet connection." 

	static let Medium_Color =   UIColor.yellow

	static let Number_OF_Rows_For_Type =   5 

	static let SERVER_NOT_AVAILABLE_MESSAGE =  "Could not connect to the Alarm Server" 

	
 static let INTERNET_NOT_AVAILABLE_TITLE = "NO NETWORK CONNECTION."
}
