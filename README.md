# SwiftUI-TCA-Camera-Demo
SwiftUI Camera App Using Composable Architecture, AVFoundation (SwiftUI와 Swift-Composable-Architecture, AVFoundation을 사용한 카메라 데모 앱 입니다.)

<br/>
<div align = 'center'>
  
  ![SwiftUI-tca-camera-demo-play](https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/1a80c961-9961-43c6-b115-570d49a13125)  
  
</div>


### 기능
- 전면 & 후면 카메라
- 전면 <-> 후면 전환 시 애니메이션
- 촬영 결과 확인 View

<br/>

## 뷰 플로우

![Frame 44](https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/0250018a-2074-45a4-91fb-1246250be421)


1. 카메라 버튼 클릭  
   dismiss 애니메이션을 on으로 초기화 함.
2. 이동   
   `@PresentationState`와 `fullScreenCover`를 사용해 `Content View` -> `Camera View` 로 이동
3. 촬영    
    `AVCaptureSession()`을 사용해 preview를 보여주고 촬영함. 화면 전환 시 전면 <-> 후면 카메라 전환.  
4. 이동  
   `@PresentationState`와 `fullScreenCover`를 사용해 `Camera View` -> `Camera Result View` 로 이동
5. 이미지 전달   
   Save 버튼 클릭시 `delegate`를 사용해 부모 뷰인 `Camera View`로 이미지 전달. OR, Cancel 버튼 클릭시 `Camera View`로 다시 이동.
6. 이미지 전달   
    `delegate`를 사용해 부모 뷰인 `Content View`로 이미지 전달. 이 때 `Camera View` dismiss 애니메이션을 on 함.
   `Camera Result View` -> `Content View`로 한 번에 dismiss 하는 효과를 냄   

<br/>

## 기능 플로우

- Camera
  - `AVFoundation`의 `AVCaptureSession`를 사용해 카메라, 비디오 preview 기능 사용.
  - `AVCapturePhotoCaptureDelegate`와 `AVCaptureVideoDataOutputSampleBufferDelegate`를 채택함. `withCheckedContinuation`를 사용해 delegate -> async로 값을 리턴함.
  - 프로젝트와 독립적
- Camera Service
  - `Camera` <-> ComposableArchitecture 연결을 위한 브릿지. `DependencyKey`를 채택함.
- CameraSetting
  - 카메라 비율, 줌 비율, 드롭 프레임 설정
  - 줌 비율(zoom Factor)의 시스템 기본 값은 1.0이다. 비율이 1.0 = 카메라의 0.5배율(광각) 이다. preview를 기본 배율(1.0배율)로 보여주기 위해 2배 설정해주었다.

### 카메라 시작

![swiftUI-tca-camera-diagram-init](https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/d13e4cdc-d704-4f12-8a9a-7c10205e7b24)  

### 카메라 촬영

![swiftUI-tca-camera-diagram-takeaphoto](https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/2a84c1c2-f57a-449a-9d75-d69576c78b71)
  

### 전면 <-> 후면 전환

![swiftUI-tca-camera-diagram-switch](https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/a0465c7d-422f-4ad1-81da-1d074d224140)
  

<br/>

## 코드
### 구현 시 특별 사항
- preview 오류 해결을 위해 첫 6프레임을 드랍합니다. (오류는 아래 영상 참고).
  - 카메라 preview 시작시 0.5초 정도 preview가 90도 회전되서 나옵니다. 완전한 해결법은 아닌데 preview가 회전되서 오는 걸 인식하는 방법은 못 찾아 차선책으로 프레임을 드랍 중 입니다.
- 화면 전환시 뒤집기(flip) 애니메이션을 위한 로직입니다. (조금 복잡해서 이해를 돕기위해 작성합니다)
  - `switchButtonTapped` action 전달
  - 애니메이션과 함께 `flipDegreeUpdate` action 전달 -> degree가 linear 하게 증가
  - `flipImage`를 현재 `viewFinderImage` 로 업데이트 & blur 처리
  - `viewFinderImage` 초기화
  - `cameraService`의 `switchCaptureDevice() async` 실행
  - `camera`에서 `switchCaptureDevice() async` 실행 -> 이 때 `dropFrame = 0`으로 초기화
  - `AVCaptureVideoDataOutputSampleBufferDelegate`의 `captureOutput`메소드를 통해 preview를 받아옴. dropFrame이 목표(현재 6)에 달성되면 `switchCaptureDevice()`함수 종료 비동기 전달.
  - `cameraFeature`에서 `switchCaptureDevice()` 비동기 종료 확인. `send(.flipImageRemove)` 실행
  - `flipImage = nil`로 초기화 -> `flipImage`가 없어지므로 화면에 preview가 보여짐.

### 오류
- preview 회전 오류 상황     
  <img width = 150 src = 'https://github.com/never-better/SwiftUI-TCA-Camera-Demo/assets/71776532/3c112638-f80f-4533-8858-074243e22c5a' />  


## 레퍼런스
- Swift UI Tutorial : https://developer.apple.com/tutorials/sample-apps/capturingphotos-camerapreview
- Swift Composable Architecture : https://github.com/pointfreeco/swift-composable-architecture

  
