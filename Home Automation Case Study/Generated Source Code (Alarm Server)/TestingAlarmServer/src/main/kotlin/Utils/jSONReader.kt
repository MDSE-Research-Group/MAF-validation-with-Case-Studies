package Utils

import Models.Alarm
import Models.Alarms
import com.fasterxml.jackson.databind.ObjectMapper
import java.io.BufferedReader
import java.io.File
import java.io.FileNotFoundException

object JSONReader {
 
var globalTagsList : MutableList<String> = mutableListOf<String>()
 lateinit var globalAlarmsList : Alarms

	fun getAlarmsJsonFromConfigurationFile() :Alarms {
				val jsonString = readJSONFromFile("src/main/resources/alarms.json")
	        val mapper = ObjectMapper()
	        var alarmList: Alarms = mapper.readValue(jsonString, Alarms::class.java)
	        return alarmList
		}
	
	
	fun readJSONFromFile(filePath:String) :String {	
				try {
	            val bufferedReader: BufferedReader = File(filePath).bufferedReader() //Read the *.json file
	            val inputString = bufferedReader.use {
	                it.readText()
	            }
	            return inputString
	        }catch (e : FileNotFoundException){
	            return "File Not Found. Please verify the path."
	        }
		}
	
	
	fun makeJSONFromAlarms(alarmList:List<Alarm>) :String {	
		val tempList = updateAlarmListForDeviationLogic(alarmList)
		val mapper = ObjectMapper()
		val jsonString = mapper.writeValueAsString(tempList)
		return jsonString
	}
	
	
	fun getAlarmTags() :List<String> {	
		val alarmList = getAlarmsJsonFromConfigurationFile()
	        for (alarmObj in alarmList.alarms) {
	
	            if (alarmObj.alarmId.contains("DIGITAL")){alarmObj.alarmType = "DIGITAL"}
	            else if (alarmObj.alarmId.contains("DEVIATION")){alarmObj.alarmType = "DEVIATION"}
	            else if (alarmObj.alarmId.contains("ROC")){alarmObj.alarmType = "ROC"}
	            else if (alarmObj.alarmId.contains("LIMIT")){alarmObj.alarmType = "LIMIT"}
	
	            for(tag in alarmObj.alarmTag) {
	                if (!alarmObj.alarmId.isNullOrEmpty()) {
	                    globalTagsList.add(tag.tagAddress)
	                }
	            }
	            println(alarmObj)
	        }
	        globalAlarmsList = alarmList
	        globalTagsList = globalTagsList.distinct().toMutableList()
	
	        return globalTagsList
		}
	
	
	fun updateAlarmListForDeviationLogic(alarmList:List<Alarm>) :List<Alarm> {	
				alarmList.forEach { alarmObj ->
	
	            if (alarmObj.alarmType == "DEVIATION" ){
	                val curValue = Utilities.deviationAlarmLogic(alarmObj.alarmTag[0].tagValue, alarmObj.alarmTag[1].tagValue)
	                alarmObj.alarmCurrentValue = curValue.toString()
	            }
	        }
	        return alarmList
		}
	
}
