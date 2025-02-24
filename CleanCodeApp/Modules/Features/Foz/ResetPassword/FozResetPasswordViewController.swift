import UIKit

class FozResetPasswordViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!

    @IBOutlet weak var verifyUserEmailLabel: UILabel!
    @IBOutlet weak var passwordRecoveredSuccessView: UIView!
    @IBOutlet weak var emailDisplayLabel: UILabel!

    // MARK: - Variáveis
    private var didUserPutEmail: String = ""
    private var didUserPressRecoverPasswordButton: Bool = false

    var viewModel: FozResetPasswordManaging
    weak var coordinator: FozResetPasswordCoordinating?

    // MARK: - Init para Storyboard
    init?(coder: NSCoder,
          viewModel: FozResetPasswordManaging,
          coordinator: FozResetPasswordCoordinating) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecoverPasswordView()
    }

    private func checkPasswordReset() {
        Task {
            do {
                let email = try await viewModel.performPasswordReset(
                    from: self,
                    withEmail: emailTextfield.text
                )
                handlePasswordResetSuccess(withEmail: email)
            } catch let error as ResetPasswordError {
                switch error {
                case .noInternet:
                    Globals.showNoInternetCOnnection(controller: self)
                case .custom(let message):
                    Globals.alertMessage(title: "Ops…", message: message, targetVC: self)
                }
            } catch {
                handlePasswordResetFailure()
            }
        }
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: Recover Password
    @IBAction func recoverPasswordButton(_ sender: Any) {
        view.endEditing(true)
        checkPasswordReset()
    }


    private func handlePasswordResetSuccess(withEmail email: String) {
        didUserPressRecoverPasswordButton = true
        emailTextfield.isHidden = true
        verifyUserEmailLabel.isHidden = true
        passwordRecoveredSuccessView.isHidden = false
        emailDisplayLabel.text = email
        recoverPasswordButton.setTitle("Voltar", for: .normal)
    }

    private func handlePasswordResetFailure() {
        let alertController = UIAlertController(
            title: "Ops…",
            message: "Algo de errado aconteceu. Tente novamente mais tarde.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }


    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func helpButton(_ sender: Any) {
        coordinator?.showContactUs()
    }

    @IBAction func createAccountButton(_ sender: Any) {
        coordinator?.showCreateAccount()
    }

    private func isFormValid() -> Bool {
        if viewModel.isEmailValid(didUserPutEmail){
            return true
        }
        else {
            displayErrorMessage()
            return false
        }
    }

    private func displayErrorMessage(){
        emailTextfield.setErrorColor()
        verifyUserEmailLabel.textColor = .red
        verifyUserEmailLabel.text = "Verifique o e-mail informado"
    }
}


// MARK: - Comportamentos de layout
extension FozResetPasswordViewController {

    func configureRecoverPasswordView() {
        recoverPasswordButton.applyPrimaryButtonStyle()

        loginButton.applySecondaryButtonStyle()

        helpButton.applySecondaryButtonStyle()

        createAccountButton.applySecondaryButtonStyle()

        emailTextfield.setDefaultColor()

        if !didUserPutEmail.isEmpty {
            emailTextfield.text = didUserPutEmail
            emailTextfield.isEnabled = false
        }
        updateRecoverPasswordButtonState()
    }

    @IBAction func emailEditingDidBegin(_ sender: Any) {
        emailTextfield.setEditingColor()
    }

    @IBAction func emailEditingChanged(_ sender: Any) {
        emailTextfield.setEditingColor()
        updateRecoverPasswordButtonState()
    }

    @IBAction func emailEditingDidEnd(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }


    func updateRecoverPasswordButtonState() {
        if !emailTextfield.text!.isEmpty {
            enableRecoverPasswordButton()
        }
        else {
            disableRecoverPasswordButton()
        }
    }

    func disableRecoverPasswordButton() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }

    func enableRecoverPasswordButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }

}
