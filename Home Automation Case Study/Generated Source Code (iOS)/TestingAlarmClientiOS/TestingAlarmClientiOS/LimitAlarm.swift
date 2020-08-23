import Foundation

class LimitAlarm : Alarm {

			 var highHigh  :  AlarmRange

			 var setPoint  :  Double

			 var exHigh  :  AlarmRange

			 var deadBand  :  Double

			 var lowLow  :  AlarmRange

			 var low  :  AlarmRange

			 var exLow  :  AlarmRange

			 var normal  :  AlarmRange

			 var high  :  AlarmRange

	private enum CodingKeys: String, CodingKey {
			 case highHigh

			 case setPoint

			 case exHigh

			 case deadBand

			 case lowLow

			 case low

			 case exLow

			 case normal

			 case high
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.highHigh = try container.decode(AlarmRange.self, forKey: .highHigh)

		self.setPoint = try container.decode(Double.self, forKey: .setPoint)

		self.exHigh = try container.decode(AlarmRange.self, forKey: .exHigh)

		self.deadBand = try container.decode(Double.self, forKey: .deadBand)

		self.lowLow = try container.decode(AlarmRange.self, forKey: .lowLow)

		self.low = try container.decode(AlarmRange.self, forKey: .low)

		self.exLow = try container.decode(AlarmRange.self, forKey: .exLow)

		self.normal = try container.decode(AlarmRange.self, forKey: .normal)

		self.high = try container.decode(AlarmRange.self, forKey: .high)
		try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(highHigh, forKey: .highHigh)

		try container.encode(setPoint, forKey: .setPoint)

		try container.encode(exHigh, forKey: .exHigh)

		try container.encode(deadBand, forKey: .deadBand)

		try container.encode(lowLow, forKey: .lowLow)

		try container.encode(low, forKey: .low)

		try container.encode(exLow, forKey: .exLow)

		try container.encode(normal, forKey: .normal)

		try container.encode(high, forKey: .high)
        try super.encode(to: encoder)
	}
}


