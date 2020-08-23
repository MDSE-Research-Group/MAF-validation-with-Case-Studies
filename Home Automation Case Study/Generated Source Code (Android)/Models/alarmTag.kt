package Models

import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility
import com.fasterxml.jackson.annotation.JsonAutoDetect


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data  class AlarmTag (var tagValue :  String,
var tagAddress :  String,
var tagName :  String,
var tagId :  String)  {

constructor(): this(  " " ,  " " ,  " " ,  " " )

}

