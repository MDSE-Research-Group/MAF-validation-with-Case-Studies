package ApplicationHandler

import Models.Alarm
import Sockets.DataSyncHandler
import Utils.Constants
import io.ktor.application.Application
import io.ktor.application.ApplicationCall
import io.ktor.application.call
import io.ktor.http.ContentType
import io.ktor.http.HttpStatusCode
import io.ktor.pipeline.PipelineContext
import io.ktor.request.receive
import io.ktor.response.respond
import io.ktor.response.respondText
import io.ktor.routing.get
import io.ktor.routing.post
import io.ktor.routing.routing

 fun Application.myModule()  {	
 			routing {
 
         post(Constants.POST_ENDPOINT) {
             errorAware {
                 val postObject = call.receive<Alarm>()
                 println("Received HTTP_POST request for Alarm entity: $postObject")
 //                call.respond(PostRepository.add(postObject))
             }
         }
         get(Constants.GET_ALL_ALARMS) {
             errorAware {
                 println("Received HTTP_GET request for all Alarm entities")
                 var dataString = ""
                 DataSyncHandler.newInstance().fetchTagValuesFromServer {
                     dataString = "{ alarms:" + it+ "}"
                     }
                 call.respondText(dataString, ContentType.Text.JavaScript, HttpStatusCode.OK)
             }
         }
     }
 	}
 

private suspend  fun <R> PipelineContext<*, ApplicationCall>.errorAware(block: suspend ()-> R) : R? {
    return try{
        block()
    }catch (e: Exception){
        call.respondText("""{"error": "$e"}""", ContentType.parse("application/json"), HttpStatusCode.InternalServerError)
        null
    }
}

private suspend fun ApplicationCall.respondSuccessJson(value: Boolean = true) = respond("""{"success": "$value"}""")

