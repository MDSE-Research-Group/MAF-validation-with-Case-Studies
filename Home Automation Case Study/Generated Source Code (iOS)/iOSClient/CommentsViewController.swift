import UIKit

protocol AlarmAcknowledgmentDelegate: class {
    func alarmAcknowledgementWithComments(alarmObj: Alarm)
    func alarmNotAcknowledged()
}

class CommentsViewController : UIViewController,  UITextViewDelegate {
	@IBOutlet weak var commentsTxtView  :  UITextView!

	@IBOutlet weak var saveBtn  :  UIButton!
weak var customDelegate : AlarmAcknowledgmentDelegate?
var alarmObj : Alarm? = nil
var historicalAlarm = false
var alarmComments = ""
var defaultComment = "No Comments yet by the operator."
 @IBAction func saveBtnTapped(sender:Any)  {	
 			if (alarmObj != nil) {
             alarmObj?.ackComments = commentsTxtView.text
         }
         commentsTxtView.resignFirstResponder()
         self.customDelegate?.alarmAcknowledgementWithComments(alarmObj: alarmObj!)
         self.navigationController?.popViewController(animated: true)
 	}




func textViewDidEndEditing(_ textView:UITextView)  {	
			if let text = textView.text,
            text == alarmComments || text.isEmpty {
            saveBtn.isEnabled = false
        }else {saveBtn.isEnabled = true}
	}


	override func viewDidLoad() {
		super.viewDidLoad()
        self.title = "Acknowledgement"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "paper_background")!)
        commentsTxtView.layer.borderWidth = 1.0
        commentsTxtView.layer.borderColor = UIColor.black.cgColor
        alarmComments = alarmObj?.ackComments ?? defaultComment
        commentsTxtView.text = alarmComments
        saveBtn.isEnabled = false
        if historicalAlarm {
            commentsTxtView.resignFirstResponder()
            commentsTxtView.isEditable = false
        }else{
            commentsTxtView.becomeFirstResponder()
        }
    }


override func didReceiveMemoryWarning()  {	
			super.didReceiveMemoryWarning()
	}


func textViewDidBeginEditing(_ textView:UITextView)  {	
			saveBtn.isEnabled = true
	}


override func touchesBegan(_ touches:Set<UITouch>,with event:UIEvent?)  {	
			let touch = touches.first
         if touch?.view == self.view {
            commentsTxtView.resignFirstResponder()
        }
	}

}
