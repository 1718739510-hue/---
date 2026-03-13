import { router } from '@kit.ArkUI'

@Entry
@Component
struct start {  //建立start 页面
  build() {
    Column(){
      Image($r('app.media.start1'))
        .width(500)
        .height(600)
      Text('         ')
      Text('         ')
      Text('         ')
      Text('         ')

      Row(){
        Image($r('app.media.start2'))
          .width(75)
          .height(75)
        Column(){
          Text('企鹅航空')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
          Text('安 心 购  轻 松 行')
            .fontColor(Color.Gray)
        }
        Text('         ') //空文本用于隔离文字与按钮的距离 用于美观
        Button('跳过').onClick(()=>{  //添加按钮
          router.replaceUrl({   // replaceUrl 进入下一个界面后不在返回的意思
            url:'pages/start'    //按 跳过 后进入Index界面
          })
        })
          .fontSize(20)
          .backgroundColor(Color.Gray)

      }

    }
  }
}