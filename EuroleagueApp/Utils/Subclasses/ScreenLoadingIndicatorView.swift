import UIKit

class ScreenLoadingIndicatorView: UIActivityIndicatorView {
        
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
            
        configure()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
        self.color = .black
        self.hidesWhenStopped = true
    }
}
