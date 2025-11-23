import UIKit
import SwiftUI

public final class ApplicationScreenViewController<
    ROUTE: ApplicationScreenRoute,
    STATE: ApplicationScreenState,
    ACTION_INTERCEPTOR: ApplicationScreenActionInterceptor,
    VIEW_MODEL: ApplicationScreenViewModelBase<ROUTE, STATE, ACTION_INTERCEPTOR>,
    CONTENT_VIEW: View
>: UIHostingController<AnyView> {
    private let screenTitle: String?
    private let navigationBarDisplayMode: ApplicationScreenNavigationBarDisplayMode
    private let backgroundColor: UIColor
    
    public init(
        navigationBarDisplayMode: ApplicationScreenNavigationBarDisplayMode,
        backgroundColor: UIColor,
        viewModel: VIEW_MODEL,
        content: (VIEW_MODEL) -> CONTENT_VIEW
    ) {
        screenTitle = viewModel.screenTitle
        self.navigationBarDisplayMode = navigationBarDisplayMode
        self.backgroundColor = backgroundColor
        
        let content = content(viewModel)
            .onAppear(perform: viewModel.onAppear)
            .onDisappear(perform: viewModel.onDisappear)
        
        super.init(rootView: AnyView(content))
    }
    
    @MainActor
    @preconcurrency
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = screenTitle
        navigationItem.largeTitleDisplayMode = largeTitleDisplayMode()
        view.backgroundColor = backgroundColor
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isNavigationBarHidden(), animated: true)
    }
    
    private func largeTitleDisplayMode() -> UINavigationItem.LargeTitleDisplayMode {
        navigationBarDisplayMode == .large ? .automatic : .never
    }
    
    private func isNavigationBarHidden() -> Bool {
        navigationBarDisplayMode == .never
    }
}
