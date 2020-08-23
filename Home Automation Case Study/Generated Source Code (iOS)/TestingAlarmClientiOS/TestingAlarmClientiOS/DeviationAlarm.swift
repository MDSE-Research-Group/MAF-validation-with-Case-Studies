import Foundation

class DeviationAlarm : Alarm {

			 var normal  :  AlarmRange

			 var exHigh  :  AlarmRange

			 var exLow  :  AlarmRange

			 var deadBand  :  Double

			 var high  :  AlarmRange

			 var lowLow  :  AlarmRange

			 var setPoint  :  Double

			 var highHigh  :  AlarmRange

			 var low  :  AlarmRange

	private enum CodingKeys: String, CodingKey {
			 case normal

			 case exHigh

			 case exLow

			 case deadBand

			 case high

			 case lowLow

			 case setPoint

			 case highHigh

			 case low
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.normal = try container.decode(AlarmRange.self, forKey: .normal)

		self.exHigh = try container.decode(AlarmRange.self, forKey: .exHigh)

		self.exLow = try container.decode(AlarmRange.self, forKey: .exLow)

		self.deadBand = try container.decode(Double.self, forKey: .deadBand)

		self.high = try container.decode(AlarmRange.self, forKey: .high)

		self.lowLow = try container.decode(AlarmRange.self, forKey: .lowLow)

		self.setPoint = try container.decode(Double.self, forKey: .setPoint)

		self.highHigh = try container.decode(AlarmRange.self, forKey: .highHigh)

		self.low = try container.decode(AlarmRange.self, forKey: .low)
		try super.init(from: decoder)
	}

	public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(normal, forKey: .normal)

		try container.encode(exHigh, forKey: .exHigh)

		try container.encode(exLow, forKey: .exLow)

		try container.encode(deadBand, forKey: .deadBand)

		try container.encode(high, forKey: .high)

		try container.encode(lowLow, forKey: .lowLow)

		try container.encode(setPoint, forKey: .setPoint)

		try container.encode(highHigh, forKey: .highHigh)

		try container.encode(low, forKey: .low)
        try super.encode(to: encoder)
	}
}


