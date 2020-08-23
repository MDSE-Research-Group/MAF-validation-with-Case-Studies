package Models

import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility
import com.fasterxml.jackson.annotation.JsonAutoDetect


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data  class Alarms (var alarms :  MutableList<Alarm> )  {

constructor(): this(  mutableListOf() )

}

