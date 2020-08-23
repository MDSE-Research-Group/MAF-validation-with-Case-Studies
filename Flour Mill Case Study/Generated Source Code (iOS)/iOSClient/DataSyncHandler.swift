
import Foundation
import Alamofire

class DataSyncHandler  : NSObject {
	static let defaultHandler = DataSyncHandler()

			func fetchAllRecentAlarmsFromServer(urlString:String,completion:@escaping (_ responseArray: [Alarm]?, _ success:Bool, _ errorMsg:String)-> Void)  {	
						if NetworkManager.isConnectedToNetwork() {
			            
			            guard let url = URL(string: urlString) else {
			                return
			            }
			            Alamofire.request(url, method: .get).validate().responseData{ response in
			                
			                var alarmsArray = [Alarm]()
			                guard response.error == nil else {
			                    let errorString = response.error?.localizedDescription
			                    let jsonString = "Error while fetching remote Alarms: \(errorString ?? Constants.SERVER_NOT_AVAILABLE_MESSAGE)"
			                    completion(alarmsArray,false,jsonString)
			                    return
			                }
			                guard let responseData = response.data else {
			                    let jsonString = Constants.MALFORMED_DATA_RECEIVED
			                    completion(alarmsArray,false,jsonString)
			                    return
			                }
			                alarmsArray = self.decodeTheAlarmsData(alarmsData: responseData)
			                completion(alarmsArray, true, "")
			            }
			        }else {
			            let jsonString = (Constants.INTERNET_NOT_AVAILABLE_TITLE)
			            completion(nil,false,jsonString)
			            }
				}
	
			func decodeTheAlarmsData(alarmsData : Data) -> [Alarm] {	
						 var alarmList = [Alarm]()
			        let jsonDecoder = JSONDecoder()
			        do {
			            let results = try jsonDecoder.decode(Alarms.self, from:alarmsData)
			            for result in results.alarms {
			                print(result.alarmTitle)
			                alarmList.append(result)
			            }
			        } catch let error as NSError{
			            print("Error caught: \(error.localizedDescription)")
			        }
			        return alarmList
				}
	
			func checkFileExists() -> URL {	
						let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
			        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
			        
			        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("HistoricalAlarms.json")
			        let fileManager = FileManager.default
			        var isDirectory: ObjCBool = false
			        
			        if !fileManager.fileExists(atPath: (jsonFilePath?.path)!, isDirectory: &isDirectory){
			            let created = fileManager.createFile(atPath: (jsonFilePath?.path)!, contents: nil, attributes: nil)
			            if created {
			                print("File created ")
			            } else {
			                print("Couldn't create file for some reason")
			            }
			        } else {
			            print("File already exists")
			        }
			        return jsonFilePath!
				}
	
			func writeHistoricalAlarmToJSONFile(alarms:[Alarm])  {	
						let jsonFilePath = checkFileExists()
			        let jsonData = ClientUtilities.makeJSONStringFromArray(alarmsList: alarms)
			            
			        // Write that JSON to the file created earlier
			        do {
			            let file = try FileHandle(forWritingTo: jsonFilePath)
			            file.write(jsonData as Data)
			            print("JSON data was written to teh file successfully!")
			        } catch let error as NSError {
			            print("Couldn't write to file: \(error.localizedDescription)")
			        }
				}
	
			func readHistoricalAlarmFromJSONFile() -> [Alarm] {	
						let jsonFilePath = checkFileExists()
			        print(jsonFilePath)
			        var alarmList = [Alarm]()
			        do {
			            let data = try Data(contentsOf: URL(fileURLWithPath: jsonFilePath.path), options: .mappedIfSafe)
			            alarmList = decodeTheAlarmsData(alarmsData: data)
			            
			        } catch let error as NSError{
			            print("Couldn't read from file: \(error.localizedDescription)")
			        }
			        return alarmList
				}
	
			func deleteFile() -> Bool {	
						let jsonFilePath = checkFileExists()
			        var status: Bool
			        do {
			            try FileManager.default.removeItem(atPath: jsonFilePath.path)
			            status = true
			        }
			        catch let error as NSError {
			            print("Ooops! Something went wrong: \(error)")
			            status = false
			        }
			        return status
				}
	
}
