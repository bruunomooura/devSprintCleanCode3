import UIKit

class CeuResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet private weak var recoverPasswordButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var helpButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!

    @IBOutlet private weak var verifyEmailLabel: UILabel!
    @IBOutlet private weak var recoveryPasswordSuccessView: UIView!
    @IBOutlet private weak var emailErrorLabel: UILabel!

    private var email = ""
    private var isEmailRecovered = false
    private let ceuResetPasswordViewModel: CeuResetPasswordViewModelProtocol
    private let ceuResetPasswordCoordinator: CeuResetPasswordCoordinatorProtocol

    init?(coder: NSCoder, ceuResetPasswordViewModel: CeuResetPasswordViewModelProtocol, ceuResetPasswordCoordinator: CeuResetPasswordCoordinatorProtocol) {
        self.ceuResetPasswordViewModel = ceuResetPasswordViewModel
        self.ceuResetPasswordCoordinator = ceuResetPasswordCoordinator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError(CeuResetPasswordStrings.initFatalErrorMessage.localized())
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - Comportamentos de layout
private extension CeuResetPasswordViewController {
    // MARK: - IBAction functions
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func recoverPasswordButton(_ sender: Any) {
        Task { @MainActor in
            if isEmailRecovered {
                dismiss(animated: true)
            } else {
                await ceuResetPasswordViewModel.startRecoverPasswordWith(email: emailTextfield?.text)
            }
        }
    }

    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        ceuResetPasswordCoordinator.showContactUsViewController()
    }

    @IBAction func createAccountButton(_ sender: Any) {
        ceuResetPasswordCoordinator.showCreateAccountViewController()
    }

    // MARK: - Setup Views
    func setupView() {
        setupRecoverPasswordButton()
        setupLoginButton()
        setupHelpButton()
        setupCreateAccountButton()
        setupEmailTextfield()

        changeEmailTextfieldState()
    }

    private func setupRecoverPasswordButton() {
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
    }

    private func setupLoginButton() {
        loginButton.layer.cornerRadius = createAccountButton.frame.height / 2
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.blue.cgColor
        loginButton.setTitleColor(.blue, for: .normal)
        loginButton.backgroundColor = .white
    }

    private func setupHelpButton() {
        helpButton.layer.cornerRadius = createAccountButton.frame.height / 2
        helpButton.layer.borderWidth = 1
        helpButton.layer.borderColor = UIColor.blue.cgColor
        helpButton.setTitleColor(.blue, for: .normal)
        helpButton.backgroundColor = .white
    }

    private func setupCreateAccountButton() {
        createAccountButton.layer.cornerRadius = createAccountButton.frame.height / 2
        createAccountButton.layer.borderWidth = 1
        createAccountButton.layer.borderColor = UIColor.blue.cgColor
        createAccountButton.setTitleColor(.blue, for: .normal)
        createAccountButton.backgroundColor = .white
    }

    private func setupEmailTextfield() {
        emailTextfield.setDefaultColor()

        let emailTextExists = !email.isEmpty
        if emailTextExists {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
    }

    // MARK: - Email TextField Editing Functions
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        changeEmailTextfieldState()
    }

    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }

    func changeEmailTextfieldState() {
        let emailTextfieldHasValue = !emailTextfield.text!.isEmpty
        return updateRecoverPasswordButtonState(toEnabled: emailTextfieldHasValue)
    }

    func updateRecoverPasswordButtonState(toEnabled: Bool) {
        recoverPasswordButton.backgroundColor = toEnabled ? .blue : .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = toEnabled
    }
}

extension CeuResetPasswordViewController: CeuResetPasswordViewModelDelegate {
    // MARK: - Reset Password Request functions
    func handleResetPasswordRequestSuccess() {
        self.isEmailRecovered = true
        self.emailTextfield.isHidden = true
        self.verifyEmailLabel.isHidden = true
        self.recoveryPasswordSuccessView.isHidden = false
        self.emailErrorLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        self.recoverPasswordButton.setTitle(CeuResetPasswordStrings.goBack.localized(), for: .normal)
    }

    func handleResetPasswordRequestError() {
        ceuResetPasswordCoordinator.showAlert()
    }

    func validateForm() throws {
        self.view.endEditing(true)

        guard let isEmailValid = emailTextfield.text?.isEmailValid(), isEmailValid else {
            emailTextfield.setErrorColor()
            verifyEmailLabel.textColor = .red
            verifyEmailLabel.text = CeuResetPasswordStrings.verifyEmailErrorMessage.localized()
            throw CeuCommonsErrors.invalidEmail
        }

    }

    func showAlertWith(message: String) {
        ceuResetPasswordCoordinator.showAlertWith(message: message)
    }

    func showNoInternetConnectionAlert() {
        ceuResetPasswordCoordinator.showNoInternetConnectionAlert()
    }
}

enum CeuCommonsErrors: Error {
    case invalidData
    case invalidEmail
    case networkError
}
