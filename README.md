https://github.com/KrisJulioDev/RickAndMortyAppFeed/assets/8087709/2e2be72b-b228-4f0f-a508-dad7f98005b1  
# Rick & Morty Character lists feed written in Swift | UIKit
## This sample project practices the implementations of the following:
### Composite Root architectural pattern
  > Main module composes all dependencies in root or entry point of the app w/c is the UISceneDelegate
### Tests driven development
  > Unit Tests | Integration Tests | Snapshot Tests | End to End Tests
### Modular design
  > The main module is agnostic of iOS specific frameworks
### S.O.L.I.D principle applied
> [!TIP] 
> 1. You will see how **S**ingle responsibility is implemented
> 2. **O**pen/Closed principle is used using abstraction
> 3. **L**iskov substition applied specially on Feed module
> 4. Implementation of protocols is strictly following the **I**nterface segration principle
> 5. High level modules are not depending on low level modules such as Core frameworks (CoreData, URLSession)
### Using DiffableSource applied to UITableViewController 
> prevent reloading of items unnecessarily (if theres no changes to data)
### Seamless continous pagination 
> Using loadMorePublisher to determine if theres more data to load 
### Design patterns such as
> [!TIP]
> 1. Delegation
> 2. Composition root
> 3. Adapter pattern
> 4. Command Query Separation (CQS) pattern
> 5. Factory pattern
> 6. Proxy pattern
> 7. MVVM + Presenter
> 8. Singleton and more...
### Caching using CoreData and fallback methods
> Fetching data remotely then cache. Added fallback if error is encountered
