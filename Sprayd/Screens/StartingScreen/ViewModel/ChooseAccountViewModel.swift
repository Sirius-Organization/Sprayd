import Foundation

@MainActor
final class ChooseAccountViewModel {
    private let onSignInTapped: () -> Void
    private let onCreateAccountTapped: () -> Void
    private let onProceedWithoutAccountTapped: () -> Void

    init(
        onSignInTapped: @escaping () -> Void,
        onCreateAccountTapped: @escaping () -> Void,
        onProceedWithoutAccountTapped: @escaping () -> Void
    ) {
        self.onSignInTapped = onSignInTapped
        self.onCreateAccountTapped = onCreateAccountTapped
        self.onProceedWithoutAccountTapped = onProceedWithoutAccountTapped
    }

    func didTapSignIn() {
        onSignInTapped()
    }

    func didTapCreateAccount() {
        onCreateAccountTapped()
    }

    func didTapProceedWithoutAccount() {
        onProceedWithoutAccountTapped()
    }
}
