import Foundation

class DigitalAlarm : Alarm {
			 var setPoint  :  Bool

			 var alarmRange  :  AlarmRange


	private enum CodingKeys: String, CodingKey {
			 case setPoint

			 case alarmRange
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.setPoint = try container.decode(Bool.self, forKey: .setPoint)

		self.alarmRange = try container.decode(AlarmRange.self, forKey: .alarmRange)
		 try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(setPoint, forKey: .setPoint)

		try container.encode(alarmRange, forKey: .alarmRange)
        try super.encode(to: encoder) 
	}
}

