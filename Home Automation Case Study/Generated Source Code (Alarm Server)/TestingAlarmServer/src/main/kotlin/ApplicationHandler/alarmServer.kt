package ApplicationHandler

import Sockets.DataSyncHandler
import com.typesafe.config.ConfigFactory
import io.ktor.application.Application
import io.ktor.config.HoconApplicationConfig
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty

fun main(args:Array<String>)  {

//    DataSyncHandler.newInstance().fetchTagValuesFromServer { alarmList ->
//        alarmList.forEach {
//            println("The Alarm Object : $it")
//        }
//    }


    val config = HoconApplicationConfig(ConfigFactory.load())
     var port = config.propertyOrNull("ktor.deployment.port")?.getString() ?: "8080"
     var hostName: String? = config.propertyOrNull("ktor.deployment.hostname")?.getString()
     println("The hostname is:$hostName at port: $port" )
     if(hostName!= null){
         embeddedServer(Netty,
                 //watchPaths = listOf("ApplicationHandler.main"),
//                 host = hostName!!,
                 port = port.toInt(),
                 module = Application::myModule,
                 configure = {
                     //Size of the queue to store [ApplicationCall] instances that cannot be immediately processed
                     requestQueueLimit = 16
                     //Number of concurrently running requests from the same http pipeline
                     runningLimit = 100
                     //Timeout in seconds for sending responses to client
                     responseWriteTimeoutSeconds = 360

                 }).start(true)
     }
     println("server started")

}