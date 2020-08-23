import Foundation

class LimitAlarm : Alarm {

			 var lowLow  :  AlarmRange

			 var high  :  AlarmRange

			 var exLow  :  AlarmRange

			 var normal  :  AlarmRange

			 var low  :  AlarmRange

			 var highHigh  :  AlarmRange

			 var deadBand  :  Double

			 var setPoint  :  Double

			 var exHigh  :  AlarmRange

	private enum CodingKeys: String, CodingKey {
			 case lowLow

			 case high

			 case exLow

			 case normal

			 case low

			 case highHigh

			 case deadBand

			 case setPoint

			 case exHigh
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.lowLow = try container.decode(AlarmRange.self, forKey: .lowLow)

		self.high = try container.decode(AlarmRange.self, forKey: .high)

		self.exLow = try container.decode(AlarmRange.self, forKey: .exLow)

		self.normal = try container.decode(AlarmRange.self, forKey: .normal)

		self.low = try container.decode(AlarmRange.self, forKey: .low)

		self.highHigh = try container.decode(AlarmRange.self, forKey: .highHigh)

		self.deadBand = try container.decode(Double.self, forKey: .deadBand)

		self.setPoint = try container.decode(Double.self, forKey: .setPoint)

		self.exHigh = try container.decode(AlarmRange.self, forKey: .exHigh)
		try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(lowLow, forKey: .lowLow)

		try container.encode(high, forKey: .high)

		try container.encode(exLow, forKey: .exLow)

		try container.encode(normal, forKey: .normal)

		try container.encode(low, forKey: .low)

		try container.encode(highHigh, forKey: .highHigh)

		try container.encode(deadBand, forKey: .deadBand)

		try container.encode(setPoint, forKey: .setPoint)

		try container.encode(exHigh, forKey: .exHigh)
        try super.encode(to: encoder)
	}
}


