import router from '@ohos.router';

@Entry
@Component
struct View {
  @State message: string = 'Hello World';

  build() {
    Row(){
    Image($r('app.media.return'))
      .width(45)
      .margin({ left: 10 })
      .onClick(() => {
        router.back()
      })
    }

  }
}