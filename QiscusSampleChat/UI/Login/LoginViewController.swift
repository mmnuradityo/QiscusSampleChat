//
//  ViewController.swift
//  QiscusSampleChat
//
//  Created by Admin on 21/04/24.
//
import UIKit

class LoginViewController: BaseViewController {
  
  static func instantiate() -> UINavigationController {
    let viewController = LoginViewController()
    viewController.view.accessibilityIdentifier = "loginViewController"
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.navigationBar.isHidden = true
    return navigationController
  }
  
  let logoImageView = UIImageView()
  let userIdTextField = UITextField()
  let userKeyTextField = UITextField()
  let userNameTextField = UITextField()
  let loginButton = UIButton()
  
  var presenter: LoginPresenterProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    style()
    layout()
  }
  
  deinit {
    removeDismissGesture()
  }
  
}

// MARK: - setup and layouting
extension LoginViewController {
  
  func setup() {
    addDismissGesture()
    
    if presenter == nil {
      presenter = LoginPresenter(
        repository: AppComponent.shared.getRepository(),
        delegate: self
      )
    }
  }
  
  func style() {
    logoImageView.translatesAutoresizingMaskIntoConstraints = false
    logoImageView.image = UIImage(named: Images.qiscusLogo)
    logoImageView.contentMode = .scaleAspectFit
    logoImageView.accessibilityIdentifier = "logoImageView"
    
    userIdTextField.translatesAutoresizingMaskIntoConstraints = false
    userIdTextField.makeFormStyle(
      identifier: "userIdTextField", placeholder: "Enter your userId"
    )
    userIdTextField.keyboardType = .emailAddress
    userIdTextField.delegate = self
    
    userKeyTextField.translatesAutoresizingMaskIntoConstraints = false
    userKeyTextField.makeFormStyle(
      identifier: "userKeyTextField", placeholder: "Enter your userKey"
    )
    userKeyTextField.delegate = self

    userNameTextField.translatesAutoresizingMaskIntoConstraints = false
    userNameTextField.makeFormStyle(
      identifier: "userNameTextField", placeholder: "Enter your user name"
    )
    userNameTextField.delegate = self
    
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.makeButtonStyle(
      identifier: "loginButton", title: "Login"
    )
    loginButton.isEnabled = false
    loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
  }
  
  func layout() {
    addToView(
      logoImageView, userIdTextField, userKeyTextField, userNameTextField, loginButton
    )
    
    activatedWithConstraint([
      logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Dimens.large * 4),
      logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      userIdTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Dimens.large * 2),
      userIdTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimens.medium),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: userIdTextField.trailingAnchor, constant: Dimens.medium),
      userIdTextField.heightAnchor.constraint(equalToConstant: Dimens.formHeight),
      
      userKeyTextField.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: Dimens.medium),
      userKeyTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimens.medium),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: userKeyTextField.trailingAnchor, constant: Dimens.medium),
      userKeyTextField.heightAnchor.constraint(equalToConstant: Dimens.formHeight),
      
      userNameTextField.topAnchor.constraint(equalTo: userKeyTextField.bottomAnchor, constant: Dimens.medium),
      userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimens.medium),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: userNameTextField.trailingAnchor, constant: Dimens.medium),
      userNameTextField.heightAnchor.constraint(equalToConstant: Dimens.formHeight),
      
      loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Dimens.medium),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: loginButton.trailingAnchor, constant: Dimens.medium),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Dimens.medium),
      loginButton.heightAnchor.constraint(equalToConstant: Dimens.buttonHeight),
    ])
  }
}

// MARK: - view logic
extension LoginViewController: LoginPresenter.LoginDelegate {
  
  private func setLoginButtonToEnable(isEnable: Bool) {
    loginButton.isEnabled = isEnable
    loginButton.setBackgroundColor(
      color: isEnable ? Colors.primaryColor : Colors.strokeColor,
      forState: .normal
    )
  }
  
  func onSuccess(userActive: UserActive) {
    let alert = AlertUtils.alertDialog(
      title: "Success", message: "Login successfull", identifier: AlertUtils.identifierSuccess
    ) { _ in
      self.navigationController?.viewControllers.removeAll()
      self.present(RoomListViewController.instantiate(), animated: true)
    }
    present(alert, animated: true, completion: nil)
  }
  
  func onError(error: UserError) {
    let alert = AlertUtils.alertDialog(
      title: "Error", message: "Login failed cause \(error.localizedDescription)", identifier: AlertUtils.identifierError
    ) { _ in
      self.dismiss(animated: true, completion: nil)
    }
    present(alert, animated: true, completion: nil)
  }
  
}


//MARK: ~ handle TextField
extension LoginViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    
    func validateEmtpy(_ target: UITextField) -> Bool {
      return target.text != nil ? !target.text!.isEmpty : false
    }
    let isNotEmpty = validateEmtpy(textField)
    
    if textField.accessibilityIdentifier == userIdTextField.accessibilityIdentifier {
      setLoginButtonToEnable(
        isEnable: validateEmtpy(userNameTextField) && isNotEmpty
      )
    } else if textField.accessibilityIdentifier == userNameTextField.accessibilityIdentifier {
      setLoginButtonToEnable(
        isEnable: validateEmtpy(userIdTextField) && isNotEmpty
      )
    }
  }
  
}

// MARK: ~ action handler
extension LoginViewController {
  
  @objc func loginButtonTapped(_ sender: UIButton) {
    let userId = userIdTextField.text ?? ""
    let userKey = userKeyTextField.text ?? ""
    let userName = userNameTextField.text ?? ""
    presenter?.login(userId: userId, userkey: userKey, userName: userName)
  }
  
}
