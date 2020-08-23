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
 open class Alarm (var alarmTitle :  String,
var isSupressed :   Boolean ,
var alarmType :   String ,
var isShelved :   Boolean ,
var ackComments :  String,
var alarmCurrentValue :  String,
var isAcknowledged :   Boolean ,
var alarmDescription :  String,
var alarmId :  String,
var alarmTag :  MutableList<AlarmTag> )  {

constructor(): this(  " " ,  false ,  " " ,  false ,  " " ,  " " ,  false ,  " " ,  " " ,  mutableListOf() )

}

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DigitalAlarm (var setPoint :   Boolean ,
var alarmRange :  AlarmRange)  : Alarm() {

constructor(): this(  false ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class ROCAlarm (var alarmRange :  AlarmRange,
var setPoint :  Double)  : Alarm() {

constructor(): this(  AlarmRange() ,  0.0 )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DeviationAlarm (var setPoint :  Double,
var Low :  AlarmRange,
var Normal :  AlarmRange,
var HighHigh :  AlarmRange,
var ExHigh :  AlarmRange,
var ExLow :  AlarmRange,
var LowLow :  AlarmRange,
var High :  AlarmRange,
var deadBand :  Double)  : Alarm() {

constructor(): this(  0.0 ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class LimitAlarm (var LowLow :  AlarmRange,
var High :  AlarmRange,
var ExLow :  AlarmRange,
var Normal :  AlarmRange,
var Low :  AlarmRange,
var HighHigh :  AlarmRange,
var deadBand :  Double,
var setPoint :  Double,
var ExHigh :  AlarmRange)  : Alarm() {

constructor(): this(  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 ,  0.0 ,  AlarmRange() )

}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class AlarmRange (var severityLevel :  AlarmSeverity,
var value :  String,
var ackRequired :   Boolean ,
var message :  String)  {

constructor(): this(  AlarmSeverity.LOW ,  " " ,  false ,  " " )

}

