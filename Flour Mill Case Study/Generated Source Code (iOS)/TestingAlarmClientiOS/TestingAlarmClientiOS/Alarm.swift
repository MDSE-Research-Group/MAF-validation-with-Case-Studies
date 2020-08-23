import Foundation

class Alarm : Codable {

			 var alarmDescription  :  String

			 var ackComments  :  String

			 var isShelved  :  Bool

			 var isAcknowledged  :  Bool

			 var alarmId  :  String

			 var alarmCurrentValue  :  String

			 var isSupressed  :  Bool

			 var alarmTitle  :  String

			 var alarmType  :  AlarmType

	private enum CodingKeys: String, CodingKey {
			 case alarmDescription 

			 case ackComments 

			 case isShelved 

			 case isAcknowledged 

			 case alarmId 

			 case alarmCurrentValue 

			 case isSupressed 

			 case alarmTitle 

			 case alarmType 
	}
	
	init(id: String, title: String, type: AlarmType, value: String, shelved: Bool, supressed: Bool,description: String, comments: String, acknowledged: Bool = false) {
        
        alarmId = id
        alarmTitle = title
        alarmType =  type
        alarmCurrentValue = value
        isShelved = shelved
        isSupressed = supressed
        alarmDescription = description
        ackComments = comments
        isAcknowledged = acknowledged
    }
}

struct Alarms: Decodable {
    let alarms: [Alarm]
    
    enum AlarmsKey: CodingKey {
        case alarms
    }
    
    enum AlarmTypeKey: CodingKey {
        case alarmType
    }
    
    enum AlarmTypes: String, Decodable {
        case digital = "DIGITAL"
        case limit = "LIMIT"
        case deviation = "DEVIATION"
        case roc = "ROC"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlarmsKey.self)
        var alarmsArrayForType = try container.nestedUnkeyedContainer(forKey: AlarmsKey.alarms)
        var tempAlarms = [Alarm]()
        
        var alarmsArray = alarmsArrayForType
        while(!alarmsArrayForType.isAtEnd)
        {
            let alarm = try alarmsArrayForType.nestedContainer(keyedBy: AlarmTypeKey.self)
            let type = try alarm.decode(AlarmTypes.self, forKey: AlarmTypeKey.alarmType)
            switch type {
            case .limit:
                print("found Limit")
                tempAlarms.append(try alarmsArray.decode(LimitAlarm.self))
            case .digital:
                print("found Digital")
                tempAlarms.append(try alarmsArray.decode(DigitalAlarm.self))
            case .deviation:
                print("found Deviation")
                tempAlarms.append(try alarmsArray.decode(DeviationAlarm.self))
            case .roc:
                print("found ROC")
                tempAlarms.append(try alarmsArray.decode(ROCAlarm.self))
            }
        }
        self.alarms = tempAlarms
    }
}


