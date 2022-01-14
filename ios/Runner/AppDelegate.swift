import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let CHANNEL = FlutterMethodChannel(name: "sendSms": binaryMessenger: controller)

    CHANNEL.setMethodCallHandler { [unowned self] (call, result) in
        id call.method == "send" {
            guard let args = call.arguments else { return }
            let mArgs = args as? [String: Any]
            let num = mArgs?("phoneNumber") as? String
            let msg = mArgs?("message") as? String
            sendSMS(num, msg, result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


      func sendSMSText(num: String, message: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [num]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
      }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}
