package Models

import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility
import com.fasterxml.jackson.annotation.JsonAutoDetect


@JsonAutoDetect(fieldVisibility = Visibility.ANY)
data  class AlarmTag (var tagAddress :  String,
var tagValue :  String,
var tagId :  String,
var tagName :  String)  {

constructor(): this(  " " ,  " " ,  " " ,  " " )

}

