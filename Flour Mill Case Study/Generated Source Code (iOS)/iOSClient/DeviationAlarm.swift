import Foundation

class DeviationAlarm : Alarm {

			 var setPoint  :  Double

			 var low  :  AlarmRange

			 var normal  :  AlarmRange

			 var highHigh  :  AlarmRange

			 var exHigh  :  AlarmRange

			 var exLow  :  AlarmRange

			 var lowLow  :  AlarmRange

			 var high  :  AlarmRange

			 var deadBand  :  Double

	private enum CodingKeys: String, CodingKey {
			 case setPoint

			 case low

			 case normal

			 case highHigh

			 case exHigh

			 case exLow

			 case lowLow

			 case high

			 case deadBand
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.setPoint = try container.decode(Double.self, forKey: .setPoint)

		self.low = try container.decode(AlarmRange.self, forKey: .low)

		self.normal = try container.decode(AlarmRange.self, forKey: .normal)

		self.highHigh = try container.decode(AlarmRange.self, forKey: .highHigh)

		self.exHigh = try container.decode(AlarmRange.self, forKey: .exHigh)

		self.exLow = try container.decode(AlarmRange.self, forKey: .exLow)

		self.lowLow = try container.decode(AlarmRange.self, forKey: .lowLow)

		self.high = try container.decode(AlarmRange.self, forKey: .high)

		self.deadBand = try container.decode(Double.self, forKey: .deadBand)
		try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(setPoint, forKey: .setPoint)

		try container.encode(low, forKey: .low)

		try container.encode(normal, forKey: .normal)

		try container.encode(highHigh, forKey: .highHigh)

		try container.encode(exHigh, forKey: .exHigh)

		try container.encode(exLow, forKey: .exLow)

		try container.encode(lowLow, forKey: .lowLow)

		try container.encode(high, forKey: .high)

		try container.encode(deadBand, forKey: .deadBand)
        try super.encode(to: encoder)
	}
}


