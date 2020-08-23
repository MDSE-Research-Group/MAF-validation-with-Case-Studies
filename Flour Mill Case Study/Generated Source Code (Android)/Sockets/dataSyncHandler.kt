package Sockets

import Models.Alarm
import Models.ResponseData
import Utils.JSONReader
import Utils.Utilities
class DataSyncHandler {

companion object { 
fun newInstance() :DataSyncHandler {	
			return DataSyncHandler()
	}
}
 val alarmsList =  mutableListOf<Alarm>() 
fun fetchTagValuesFromServer(callBack:(responseData: String)->Unit)  {	
			val modelArray = Utilities.getModelsFromTokenizedStringsList()
        if (modelArray.size > 0) {
            modelArray.forEachIndexed { index, device ->
                val serializedXMLString = Utilities.write2XMLString(device)
//                println("Serialized XML String: \n $serializedXMLString")

                requestServerWithXMLStream(serializedXMLString) { alamObj->
                    alarmsList.add(alamObj)
                }
            }
            // Removing Duplicates from Alarms List
            var alarmUnique = alarmsList.distinctBy { it.alarmId }

            val jsonString  = JSONReader.makeJSONFromAlarms(alarmUnique)
            callBack(jsonString)
        }
	}

fun requestServerWithXMLStream(xmlRequestString:String,callBack:(alarmObj: Alarm)-> Unit)  {	
			val responseCheck = SocketManager.pingDAServerWith(xmlRequestString) {
            serverResponseCallBack(it) {
               mapResponseToAlarmList(it) {
                   callBack(it)
               }
            }
        }
	}

fun serverResponseCallBack(responseObj:String,callBack:(responseObj: ResponseData )-> Unit)  {	
			 val formattedString = Utilities.formatResponseString(responseObj)
         val dataObj = Utilities.convertXmlString2DataObject(formattedString, ResponseData::class.java) as ResponseData
         callBack(dataObj)
	}

fun mapResponseToAlarmList(responseObj:ResponseData,callBack: (alarmObj: Alarm) -> Unit)  {	
			val alarmsList  = JSONReader.globalAlarmsList.alarms.toMutableList()
       // Assigning CurrentValue based on TagAddress Matching
        alarmsList.forEach { alarmObj : Alarm ->
            alarmObj.alarmTag.forEach{
                if (it.tagAddress.toString() == responseObj.requestID){
                    val tag = responseObj.data.split(",").first()
                        it.tagValue = tag
                        alarmObj.alarmCurrentValue = tag
                    callBack(alarmObj)
                }
            }
        }
	}

}
