package Utils

import Models.Destination
import Models.Device
import Models.Input
import com.fasterxml.jackson.dataformat.xml.XmlMapper
import java.io.File
import kotlin.math.abs

object Utilities {


	
	fun validateIPAddress(ipAddress:String) :Boolean {	
				return false
		}
	
	
	fun getModelsFromTokenizedStringsList() :List<Device> {	
				val devicesList  = mutableListOf<Device>()
	        val alarmTags = JSONReader.getAlarmTags()
	        alarmTags.forEachIndexed { index, tagString ->
	            val tokenizedList = tokenizeString(tagString)
	            if (tokenizedList.size >1) {
	                // Make Model
	                val tempObj = makeModel(tokenizedList, index)
	                devicesList.add(tempObj)
	            }
	        }
	        return devicesList
		}
	
	
	fun makeModel(tagInfo:List<String>,index:Int) :Device {	
				       val deviceName = "Device $index"
	        val deviceID = index
	        val ip = tagInfo[0]
	        val port = tagInfo[1].toInt()
	        val location  = tagInfo[2]
	        val startingNum = tagInfo[3].toInt()
	        val numOfInputs = tagInfo[4].toInt()
	
	        val inputsList = mutableListOf<Input>()
	        inputsList.add(Input(startingNum, numOfInputs))
	        val destinations = mutableListOf<Destination>()
	        destinations.add(Destination(location, inputsList))
	        val deviceObj = Device(deviceID, deviceName, ip,port, destinations)
	        return deviceObj
		}
	
	
	fun tokenizeString(message:String) :List<String> {	
				val tempList = message.split("/")
	        return tempList
		}
	
	
	fun formatResponseString(message:String) :String {	
				var tempString = message.removePrefix("null<?xml version=\"1.0\" encoding=\"utf-16\"?><ArrayOfResponseData xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">")
	        tempString = tempString.removeSuffix("</ArrayOfResponseData>")
	        println("Formatted Response String: $tempString")
	        return tempString
		}
	
	
	fun convertXmlString2DataObject(xmlString:String,cls:Class<*>) :Any {	
				val xmlMapper = XmlMapper()
	        return xmlMapper.readValue(xmlString, cls)
		}
	
	
	fun write2XMLString(obj:Any) :String {	
				val xmlMapper = XmlMapper()
	        // use the line of code for pretty-print XML on console. We should remove it in production.
	//        xmlMapper.enable(SerializationFeature.INDENT_OUTPUT);
	        var tempString =  xmlMapper.writeValueAsString(obj)
	        val prefix="<?xml version=\"1.0\" encoding=\"utf-16\"?>"
	        val deviceAttribute = "<Device xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
	
	        if (tempString.contains("<Device>")){
	            tempString = tempString.replace("<Device>", deviceAttribute, true)
	        }
	        tempString = prefix + tempString
	        println("Formatted Request String: $tempString")
	        return tempString
		}
	
	
	fun deviationAlarmLogic(tag1Value:String,tag2Value:String) :Double {	
				val resultingValue = (abs(tag1Value.toDouble()-tag2Value.toDouble())/tag1Value.toDouble())*100
	        return resultingValue
		}
	
}
