
package Models

import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlElementWrapper
import com.fasterxml.jackson.dataformat.xml.annotation.JacksonXmlProperty

data class Device (val deviceID: Int) {

 var port : Int

@JacksonXmlElementWrapper(localName = "destinations") @JacksonXmlProperty(localName = "Destination") 
 var destination : List<Destination> 


 var deviceName : String


 var ipAddress : String

	init {
        deviceName = ""
        ipAddress = ""
        port = -1
        destination = listOf()
    }

 	constructor(deviceID: Int, devName: String, ip: String, port: Int, dest: List<Destination>): this(deviceID){
       this.deviceName = devName
        this.ipAddress = ip
        this.port = port
        this.destination = dest
    }
}
