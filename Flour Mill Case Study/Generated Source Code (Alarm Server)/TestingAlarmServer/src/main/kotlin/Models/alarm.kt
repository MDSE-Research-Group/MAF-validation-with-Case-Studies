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
open class Alarm (var alarmType :   String ,
                  var alarmTag :  MutableList<AlarmTag> ,
                  var ackComments :  String,
                  var isShelved :   Boolean ,
                  var isSupressed :   Boolean ,
                  var alarmDescription :  String,
                  var alarmTitle :  String,
                  var alarmId :  String,
                  var isAcknowledged :   Boolean ,
                  var alarmCurrentValue :  String)  {

 constructor(): this(  " " ,  mutableListOf() ,  " " ,  false ,  false ,  " " ,  " " ,  " " ,  false ,  " " )

}

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DigitalAlarm (var alarmRange :  AlarmRange,
                         var setPoint :   Boolean )  : Alarm() {
 constructor(): this(  AlarmRange() ,  false )
}

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class ROCAlarm (var alarmRange :  AlarmRange,
                     var setPoint :  Double)  : Alarm() {
 constructor(): this(  AlarmRange() ,  0.0 )
}

@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class DeviationAlarm (var ExHigh :  AlarmRange,
                           var Low :  AlarmRange,
                           var setPoint :  Double,
                           var LowLow :  AlarmRange,
                           var ExLow :  AlarmRange,
                           var Normal :  AlarmRange,
                           var HighHigh :  AlarmRange,
                           var deadBand :  Double,
                           var High :  AlarmRange)  : Alarm() {
 constructor(): this(  AlarmRange() ,  AlarmRange() ,  0.0 ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 ,  AlarmRange() )
}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class LimitAlarm (var Low :  AlarmRange,
                       var ExHigh :  AlarmRange,
                       var Normal :  AlarmRange,
                       var LowLow :  AlarmRange,
                       var HighHigh :  AlarmRange,
                       var deadBand :  Double,
                       var High :  AlarmRange,
                       var ExLow :  AlarmRange,
                       var setPoint :  Double)  : Alarm() {
 constructor(): this(  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  AlarmRange() ,  0.0 ,  AlarmRange() ,  AlarmRange() ,  0.0 )
}


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data class AlarmRange (var value :  String,
                       var ackRequired :   Boolean ,
                       var message :  String,
                       var severityLevel :  AlarmSeverity)  {
 constructor(): this(  " " ,  false ,  " " ,  AlarmSeverity.LOW )
}
