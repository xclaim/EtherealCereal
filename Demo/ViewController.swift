import UIKit
import EtherealCereal

class ViewController: UIViewController {

    let etherealCereal = EtherealCereal()

    lazy var privateKeyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    lazy var publicKeyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    lazy var derivedKeyLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()

    lazy var addressLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()

    lazy var signatureLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(self.privateKeyLabel)
        self.view.addSubview(self.publicKeyLabel)
        self.view.addSubview(self.addressLabel)
        self.view.addSubview(self.derivedKeyLabel)
        self.view.addSubview(self.messageLabel)
        self.view.addSubview(self.signatureLabel)
        
        let margin = CGFloat(16)
        let topMargin = CGFloat(100)
        let minHeight = CGFloat(36)

        self.privateKeyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.privateKeyLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topMargin).isActive = true
        self.privateKeyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.privateKeyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.publicKeyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.publicKeyLabel.topAnchor.constraint(equalTo: self.privateKeyLabel.bottomAnchor, constant: margin).isActive = true
        self.publicKeyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.publicKeyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.addressLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.addressLabel.topAnchor.constraint(equalTo: self.publicKeyLabel.bottomAnchor, constant: margin).isActive = true
        self.addressLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.addressLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.derivedKeyLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.derivedKeyLabel.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: margin).isActive = true
        self.derivedKeyLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.derivedKeyLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.messageLabel.topAnchor.constraint(equalTo: self.derivedKeyLabel.bottomAnchor, constant: margin).isActive = true
        self.messageLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.messageLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        self.signatureLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight).isActive = true
        self.signatureLabel.topAnchor.constraint(equalTo: self.messageLabel.bottomAnchor, constant: margin).isActive = true
        self.signatureLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: margin).isActive = true
        self.signatureLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -margin).isActive = true

        print("Private key generated: \(self.etherealCereal.privateKey)")
        print("Public key generated: \(self.etherealCereal.publicKey)")
        print("Address: \(self.etherealCereal.address)")
        
        let message: String = "Hello all!"
        let signature: String = self.etherealCereal.sign(message: message)
        
        print("Message: \(message)")
        print("Signature: \(signature)")
 
        let derived : String = self.etherealCereal.recoverPublicKey(from: message, signature: signature)
        
        let privateKeyString = NSMutableAttributedString(string: "Private key: \(self.etherealCereal.privateKey)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        privateKeyString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (privateKeyString.string as NSString).range(of: "Private key:"))

        let publicKeyString = NSMutableAttributedString(string: "Public key: \(self.etherealCereal.publicKey)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        publicKeyString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (publicKeyString.string as NSString).range(of: "Public key:"))

        let addressString = NSMutableAttributedString(string: "Address: \(self.etherealCereal.address)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        addressString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (addressString.string as NSString).range(of: "Address:"))

        let derivedKeyString = NSMutableAttributedString(string: "Derived key: \(derived)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        derivedKeyString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (derivedKeyString.string as NSString).range(of: "Derived key:"))

        let messageString = NSMutableAttributedString(string: "Message: \(message)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        messageString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (messageString.string as NSString).range(of: "Message:"))

        let signatureString = NSMutableAttributedString(string: "Signature: \(signature)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        signatureString.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 16), range: (signatureString.string as NSString).range(of: "Signature:"))

        self.privateKeyLabel.attributedText = privateKeyString
        self.publicKeyLabel.attributedText = publicKeyString
        self.addressLabel.attributedText = addressString
        self.derivedKeyLabel.attributedText = derivedKeyString
        self.messageLabel.attributedText = messageString
        self.signatureLabel.attributedText = signatureString
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

