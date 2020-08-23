import Foundation

class DigitalAlarm : Alarm {
			 var alarmRange  :  AlarmRange

			 var setPoint  :  Bool


	private enum CodingKeys: String, CodingKey {
			 case alarmRange

			 case setPoint
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.alarmRange = try container.decode(AlarmRange.self, forKey: .alarmRange)

		self.setPoint = try container.decode(Bool.self, forKey: .setPoint)
		 try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(alarmRange, forKey: .alarmRange)

		try container.encode(setPoint, forKey: .setPoint)
        try super.encode(to: encoder) 
	}
}

