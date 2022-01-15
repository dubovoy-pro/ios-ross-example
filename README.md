# ROSS Architecture example project (iOS version)

## App description
The application/project is intended to demonstrate key features of the ROSS architecture. The project includes a local storage, networking, UI routing, error handling and other typical iOS app components. The architecture has a high level of testability (including integration tests), it easy to understand and provides bidirectional data bindings with no any external depencencies such as RxSwift.
## Architecture
The app is based on the ROSS architecture. ROSS means Router, Operation, Scenario and Service.

Scenario is the main application class. The scenario encapsulates entire business logic of the application. You can study only this class and understand in general how the application works and what functionality it provides. Of course, if all the code were in the same class, it would be a nightmare god-object (or devil-object if you wish =) ). So scenario codebase is divided between operations. The scenario is responsible only for the operations life cycle and the data exchange between them. Thus, when we read the scenario code, we actually see the sequence of operations calls. The scenario code is easy to present in the form of a flowchart and thus it simplifies a new developer onboarding into the project.

Operation is a scenario component. An operation has its own life cycle, i.e. it can be started and terminated both synchronously (for short-lived "inline" operations) and asynchronously (for long-lived operations). As a rule, each screen of the application is associated with its operation dedicated to it. Such an operation is long-lived, i.e. its lifetime is not less than the lifetime of the screen. However, the operation may well not be associated with any screen at all. For example, an operation for complex data processing or an operation for instantiating of services is not tied to the UI at all. Moreover, even a "screen" operation may well exist without binding in the UI layer. All the operation needs to work is the service interfaces it receives in the initializer.

Service is the most independent module of an application. An example of a service is the local storage or network layer. UI is also essentially a service, but it is so closely tied to frameworks from the  Apple's ecosystem (such as UIKit) that it needs to be considered separately.

Router is a service that is responsible for the UI. The UI is placed in a separate group because it is a very significant part of the application and is strongly associated with UIKit. This affects its structure and testing methods. Router is completely independent of theapplication  business logic: it is only responsible for instantiating UIViewController, UINavigationController, UITabBarController and storing their state, but it does it well. A scenarion or operation can ask router "show this screen please" without worrying about the current context. The router will take care of navigation, switching tabs, and also even decide whether to show the requested screen in the navigation stack or modally. The clear consequence of this is the ability to run the application in "headless" mode, passing a mock object intead of the router. This is very handy for writing integration tests.

The ability to make true integration tests is a coolest feature of the ROSS architecture. A high dependency injection level allows you to cover with test even cases of interaction between long-lived operations. For example, we can test if a new item is displayed in the favorites tab when clicking "add to favorites" in the search tab. Typically, integration tests are the scenario class tests. That is why the scenarion is the main class of the application.

## Build process
Use CocoaPods to install dependencies.

The project contains separate Build Schemes for staging and production 
environments. It's allows to install test (staging) and production app both 
into the same device.

Each scheme has two Build Configuration: Debug and Release. It prevents sending analytical events during development/debugging process. 

SwiftGen is used to generate type-safe resource references.

## Development process
UIDevStand target is intended to develop and test the UI components like ViewControllers in an isolated environment.

Use NetworkProviderDev in case of troubles with Coincap API (set 'devstand' as API URL in staging.xconfig). 

