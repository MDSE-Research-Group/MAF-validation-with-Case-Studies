package Models

import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility
import com.fasterxml.jackson.annotation.JsonAutoDetect

import com.fasterxml.jackson.annotation.JsonSubTypes
import com.fasterxml.jackson.annotation.JsonTypeInfo

@JsonTypeInfo(
        use = JsonTypeInfo.Id.NAME,
        include = JsonTypeInfo.As.PROPERTY,
        property = "alarmType")
@JsonSubTypes(
        JsonSubTypes.Type(value = LimitAlarm::class, name = "LIMIT"),
        JsonSubTypes.Type(value = DigitalAlarm::class, name = "DIGITAL"),
        JsonSubTypes.Type(value = DeviationAlarm::class, name = "DEVIATION"),
        JsonSubTypes.Type(value = ROCAlarm::class, name = "ROC"))

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
 open class Alarm (var alarmTag :  MutableList<AlarmTag> ,
var alarmType :   String ,
var alarmTitle :  String,
var alarmCurrentValue :  String,
var alarmDescription :  String,
var isShelved :   Boolean ,
var isSupressed :   Boolean ,
var alarmId :  String,
var isAcknowledged :   Boolean ,
var ackComments :  String)  {

constructor(): this(  mutableListOf() ,  " " ,  " " ,  " " ,  " " ,  false ,  false ,  " " ,  false ,  " " )

}

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DigitalAlarm (var setPoint :   Boolean ,
var alarmRange :  AlarmRange)  : Alarm() {

constructor(): this(  false ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class ROCAlarm (var setPoint :  Double,
var alarmRange :  AlarmRange)  : Alarm() {

constructor(): this(  0.0 ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DeviationAlarm (var setPoint :  Double,
var ExLow :  AlarmRange,
var ExHigh :  AlarmRange,
var Normal :  AlarmRange,
var High :  AlarmRange,
var HighHigh :  AlarmRange,
var Low :  AlarmRange,
var deadBand :  Double,
var LowLow :  AlarmRange)  : Alarm() {

constructor(): this(  0.0 ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class LimitAlarm (var LowLow :  AlarmRange,
var HighHigh :  AlarmRange,
var Normal :  AlarmRange,
var Low :  AlarmRange,
var High :  AlarmRange,
var ExHigh :  AlarmRange,
var setPoint :  Double,
var deadBand :  Double,
var ExLow :  AlarmRange)  : Alarm() {

constructor(): this(  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 ,  0.0 ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class AlarmRange (var value :  String,
var severityLevel :  AlarmSeverity,
var ackRequired :   Boolean ,
var message :  String)  {

constructor(): this(  " " ,  AlarmSeverity.LOW ,  false ,  " " )

}

