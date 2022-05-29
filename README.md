
### 개발 내용

- MVVM 디자인 패턴 적용
- Unit Test 코드 작성
- URLSession을 사용하여 JSON데이터를 가져옴
- 즐겨찾기 버튼을 눌렀을 때 다른 화면과 동기화
- 무한 스크롤 구현
- CoreData를 사용하여 즐겨찾기한 사진을 저장


<br/>

## 고민 & 구현 방법

### MVVM 패턴

- View가 ViewModel을 바인딩하기 위해서 Observer 패턴을 적용했습니다.

```swift
import Foundation

final class Observable<T> {
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
```
        
- 의존성의 방향이 단방향이 되도록 했습니다.
- 의존성 주입을 통해 객체간 의존성을 낮추고 테스트가 용이하도록 만들었습니다.
    - 초기화를 통해 의존성 주입 구현
    ```swift
    var service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    ```
    
### Unit Test

테스트를 쉽게 하기 위해서 protocol을 사용하여 추상화를 했습니다.
이로 인해서 테스트를 위한 가짜 객체를 만들 수 있게 됐고, 인터넷이 없는 환경에서도 URLSession을 테스트할 수 있게 됐습니다.

```swift
protocol ServiceProtocol {
    func search(query: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void)
}

class MockPhotoService: ServiceProtocol {
    var mockResult: Result<PhotoSearchResponse, Error>?
    
    func search(query: String, page: Int, completion: @escaping (Result<PhotoSearchResponse, Error>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
```

### UIViewController 혹은 UIView는 UITest로 해야하나?

- 뷰컨트롤러가 UI와 관련 되어 있어서 UITest로 해야하나 생각 했지만, UITest는 앱 시작점부터 테스트를 하고 원하는 테스트 영역까지 들어가야 하기 때문에 테스트를 하기 위한 준비가 유닛 테스트보다 많이 필요하고 시간이 더 걸린다고 생각 했습니다. 그리고 뷰모델에서 뷰에 보여지는 데이터를 관리하기 때문에 뷰에서는 버튼이 클릭이 되었는지와 같은 상태 변화같은 것만 테스트 하면 된다고 생각 했습니다.

```swift
func test_서치바의_서치버튼을_눌렀을때_잘_동작하는지() {
        // given
        let searchBar = vc.searchController.searchBar
        
        // when
        searchBar.text = "hello swift"
        searchBar.delegate?.searchBarSearchButtonClicked?(
            searchBar
        )
        
        // then
        XCTAssertEqual(mockViewModel.inputText, "hello swift")
}
```

### private 함수는 어떻게 테스트 하는가?

- private 함수는 public 함수에서 호출이 되기 때문에 public 함수를 테스트 하면 private 함수도 테스트가 된다고 생각 됩니다.


<br/>

## 느낀 점

### MVVM

- 의존성 방향이 단방향이 되어야 합니다. 이렇게 되면 ViewModel은 View에 대해 전혀 알지 못해서 View가 스스로 ViewModel을 관찰하고 있다가 업데이트 해야합니다.
- 간단한 UI의 프로젝트에서는 몇개 안되는 UI를 위해서 데이터 바인딩을 위한 기능도 만들어야 되고, ViewModel도 만들어야 되서 과하다고 느꼈습니다.

### 유닛 테스트 하면서 느낀 점

- 매번 전체 프로그램을 빌드하는 대신 함수 단위로 빌드해서 빠르게 문제 파악이 가능하고 시간 절약을 할 수 있다고 느꼈습니다.
- 의존성이 높은 객체는 다른 객체로 부터 영향을 받기 쉬워 테스트 하기 어렵고, 유지보수 할 때도 힘들다는 것을 느꼈습니다.
- 테스트 코드를 작성할 때 어떻게 작성해야 하는지 감이 안잡혔는데, 어떤 값을 검증하고 싶은지 먼저 작성을 하면 테스트 코드 작성하기가 좀 더 수월해지는 것을 경험했습니다(then 부분).

<br/>

## 구현 영상

### 즐겨찾기 화면간 연동


https://user-images.githubusercontent.com/78908490/170871685-f6332a83-c00c-4257-a38d-376bf85ed7f0.mp4


<br/>

### 무한 스크롤


https://user-images.githubusercontent.com/78908490/170872111-b529a40f-1461-4825-9f31-886b1048f735.mp4


<br/>

### 앱 종료 후 재실행 했을 때 즐겨찾기한 사진들 저장 되어있는지


https://user-images.githubusercontent.com/78908490/170872185-d2cf7183-4675-41bb-9999-fd596a92d4c3.mp4

