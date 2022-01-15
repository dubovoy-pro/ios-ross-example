//
//  MakeServicesOp.swift
//  bcoin
//
//  Created by Yury Dubovoy on 10.01.2022.
//

import Foundation

struct ServiceContainer {
    let infoPlistProvider: InfoPlistProvider
    let network: Network
    let storage: Storage
}

protocol MakeServicesOpInterface: AnyObject {
}

protocol MakeServicesOpDelegate: AnyObject {
}

protocol MakeServicesOp:
    Operation,
    MakeServicesOpInterface,
    MakeServicesOpDelegate {
    var onFinish: Func<ServiceContainer>? { get set }
}

final class MakeServicesOpImpl: BaseOperation, MakeServicesOp {

    
    // MARK: MakeServicesOp

    override func launch(holder: OperationHolder) {

        super.launch(holder: holder)

        let infoPlistProvider = InfoPlistProviderImpl()

        let storage = StorageImpl()

        let networkProvider: NetworkProvider
        // use devstand due to problems with the official API
        if infoPlistProvider.apiBaseURL.absoluteString.contains("devstand") {
            networkProvider = NetworkProviderDev()
        } else {
            let networkProviderDelegate = NetworkProviderDelegateImpl(plistInfoProvider: infoPlistProvider)
            networkProvider = NetworkProviderImpl(delegate: networkProviderDelegate)
        }

        let network = NetworkImpl(storage: storage, provider: networkProvider)

        let services = ServiceContainer(
            infoPlistProvider: infoPlistProvider,
            network: network,
            storage: storage
        )

        
        finish(services)
    }

    var onFinish: Func<ServiceContainer>?

    
    // MARK: MakeServicesOpInterface

    
    // MARK: MakeServicesOpdelegate

    
    // MARK: MakeServicesOpImpl

    private func finish(_ services: ServiceContainer) {
        super.finish()
        onFinish?(services)
    }

}
