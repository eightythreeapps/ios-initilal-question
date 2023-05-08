//
//  iOS Initial Question
//
//  Created by Ben Reed on 08/05/2023.
//

//Original
class API {
    func fetchItems(completion: (Result<[Item], Error>) -> Void) {
        // Gets items from some hosted API
    }
}

class ClassToTest {
    private(set) var stateList = [String]()

    func functionToTest() {
        stateList.append("Loading")

        API().fetchItems { result in
            switch result {
            case .success(_):
                stateList.append("Success")
            case .failure(_):
                stateList.append("Failed")
            }
        }
    }
}

/**
 The changes I would make to make this code testable are below with some examples, but in short
 
 - Create a new Protocol called DataProvider and refactor API to implement it
 - Add a new property to ClassToTest of type DataProvider so we can use dependency injection to inject a dataProvider instance
 - Update functionToTest to use the class property rather than instantiate a new instance of API directly
 - Create a few new Mock classes that implement the DataProvider protocol so we can hard code various responses and use them in Unit Tests to cover various
 
  */

protocol DataProvider {
    func fetchItems(completion: (Result<[Item], Error>) -> Void) 
}

class API:DataProvider {
    func fetchItems(completion: (Result<[Item], Error>) -> Void) {
        // Gets items from some hosted API
    }
}

//Mock instance that always provides 'success'
class MockDataProvideSuccessr:DataProvider {
    
    let states = ["Success", "Failed"]

    func fetchItems(completion: (Result<[Item], Error>) -> Void) {

        completion(.success(states[0]))

    }
}

//Mock instance that always provides 'Failed'
class MockDataProviderFailed:DataProvider {
    
    let states = ["Success", "Failed"]

    func fetchItems(completion: (Result<[Item], Error>) -> Void) {

        completion(.failure(states[1]))

    }
}


class ClassToTest {
    
    //Add a new property to the class to hold an instance of the DataProvider protocol
    private var dataProvider:DataProvider
    private(set) var stateList = [String]()

    //Add a new init method to inject the DataProvider instance and assign it
    public init(dataProvider:DataProvider) {
        self.dataProvider = dataProvider
    }

    func functionToTest() {
        stateList.append("Loading")
        
        //Remove reliance on a directly instantiated instance of API and use the DataProvider property instead
        dataProvider.fetchItems { result in
            switch result {
            case .success(_):
                stateList.append("Success")
            case .failure(_):
                stateList.append("Failed")
            }
        }
    }
}
