import Foundation

class Alarm : Codable {

			 var alarmTitle  :  String

			 var isSupressed  :  Bool

			 var alarmType  :  AlarmType

			 var isShelved  :  Bool

			 var ackComments  :  String

			 var alarmCurrentValue  :  String

			 var isAcknowledged  :  Bool

			 var alarmDescription  :  String

			 var alarmId  :  String

	private enum CodingKeys: String, CodingKey {
			 case alarmTitle 

			 case isSupressed 

			 case alarmType 

			 case isShelved 

			 case ackComments 

			 case alarmCurrentValue 

			 case isAcknowledged 

			 case alarmDescription 

			 case alarmId 
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


