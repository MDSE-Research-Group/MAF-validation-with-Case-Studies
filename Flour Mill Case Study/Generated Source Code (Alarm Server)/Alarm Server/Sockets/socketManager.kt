package Sockets

import Utils.Constants
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.net.ConnectException
import java.net.Socket
import java.net.SocketException
import java.net.UnknownHostException
class SocketManager {

companion object { 
fun pingDAServerWith(message:String,callBack:(responseData: String)-> Unit) :String {	
			try {
                val socket = Socket(Constants.DAServerIPAddress, Constants.DAServerPort)
                socket.use {
                        var responseString : String? = null
                        it.getOutputStream().write(message.toByteArray())
                        val bufferReader = BufferedReader(InputStreamReader(it.inputStream))
                        while (true) {
                            val line = bufferReader.readLine() ?: break
                            responseString += line
                            if (line == "exit") break
                        }
                        bufferReader.close()
                        if (responseString != null) callBack(responseString)
                    it.close()
                    return "Done"
                }
            }catch (he: UnknownHostException){
                val exceptionString = "${Constants.UnknownHostException} with an exception:\n ${he.printStackTrace()}"
                return   exceptionString

            }catch (ioe: IOException){
                val exceptionString = "${Constants.IOException} with an exception:\n ${ioe.printStackTrace()}"
                return   exceptionString
            } catch (ce: ConnectException){
                val exceptionString = "${Constants.ConnectException} with an exception:\n ${ce.printStackTrace()}"
                return   exceptionString
            }catch (se: SocketException){
                val exceptionString = "${Constants.SocketException} with an exception:\n ${se.printStackTrace()}"
                return   exceptionString
            }
	}
}


}
