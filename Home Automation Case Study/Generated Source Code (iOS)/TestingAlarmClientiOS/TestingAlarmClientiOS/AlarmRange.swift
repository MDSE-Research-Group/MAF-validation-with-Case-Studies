import Foundation

class AlarmRange :  Codable {
			 var severityLevel  :  AlarmSeverity

			 var ackRequired  :  Bool

			 var message  :  String

			 var value  :  String

		init(value: String, message: String, severity: AlarmSeverity, acknowledged: Bool){
        self.value = value
        self.message = message
        self.severityLevel = severity
        self.ackRequired = acknowledged
    }

	private enum CodingKeys: String, CodingKey {
			 case severityLevel

			 case ackRequired

			 case message

			 case value
	}
	
	 required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		self.severityLevel = try container.decode(AlarmSeverity.self, forKey: .severityLevel)

		self.ackRequired = try container.decode(Bool.self, forKey: .ackRequired)

		self.message = try container.decode(String.self, forKey: .message)

		self.value = try container.decode(String.self, forKey: .value)
		
	}

	public  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(severityLevel, forKey: .severityLevel)

		try container.encode(ackRequired, forKey: .ackRequired)

		try container.encode(message, forKey: .message)

		try container.encode(value, forKey: .value)
       
	}
}

