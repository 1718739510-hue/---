import { edgeColors, router } from '@kit.ArkUI'
class Flight {
  id: string
  company: string
  from: string
  to: string
  date: string
  seats: number
  price: number

  constructor(id: string, company: string, from: string, to: string, date: string, seats: number, price: number) {
    this.id = id   //this 关键字表示类的实例（即你正在创建的对象）。this.id = id 表示将传入的 id 参数值赋值给该类实例的 id 属性
    this.company = company
    this.from = from
    this.to = to
    this.date = date
    this.seats = seats
    this.price = price
  }
}

class Booking {
  flightId: string
  passengerName: string

  constructor(flightId: string, passengerName: string) {
    this.flightId = flightId
    this.passengerName = passengerName
  }
}
@Entry
@Component
struct EnhancedFlightBookingSystem {
  @State flights: Flight[] = []  //这是一个数组状态，表示所有航班的数据，类型是 Flight[]（航班对象数组）。初始值为空数组。
  @State bookings: Booking[] = []
  @State selectedFlight: Flight | null = null
  @State name: string = ''
  @State currentView: 'menu' | 'import' | 'search' | 'refund' = 'menu'
  @State importFlightId: string = ''
  @State importCompany: string = ''
  @State importFrom: string = ''
  @State importTo: string = ''
  @State importDate: string = ''
  @State importSeats: string = ''
  @State importPrice: string = ''
  @State searchTerm: string = ''
  @State searchType: 'id' | 'company' | 'from' | 'to' | 'price' = 'id'
  @State minPrice: number = 0
  @State maxPrice: number = Infinity
  @State showSearchResults: boolean = false
  myScroll: Scroller = new Scroller()
  @State selectedIndex: number = 0

  @Builder
  myBuilder(itemIndex: number, title: string, img: ResourceStr, selImg: ResourceStr) {
    //这是函数的名字，意味着这是一个构建（builder）相关的函数。
    Column() {
      Image(itemIndex == this.selectedIndex ? selImg : img)
        .width(30)
      Text(title)
        .fontColor(itemIndex == this.selectedIndex ? Color.Orange : Color.Black)
    }
  }

  build() {
    Column() {
      if (this.currentView === 'import') {
        this.buildImportForm()
      } else if (this.currentView === 'search') {
        this.buildSearchView()
      }
      Tabs({ barPosition: BarPosition.End }) { //end表示在底部
        TabContent() {
          Column() {
            Row() {
              Text('      ')
              Image($r('app.media.view'))
                .width(45)
                .onClick(() => {
                  this.currentView = 'import'
                })
              Text('录入航班            ')
                .fontColor('#2d58f7')
                .onClick(() => {
                  this.currentView = 'import'
                })
              Image($r('app.media.search'))

                .width(45)
                .onClick(() => {
                  this.currentView = 'search'
                  this.showSearchResults = false
                  this.selectedFlight = null
                })
              Text('查询航班')
                .fontColor('#2d58f7')
                .onClick(() => {
                  this.currentView = 'search'
                  this.showSearchResults = false
                  this.selectedFlight = null
                })
            }
            .width('100%')
            .padding(10)

            Stack({ alignContent: Alignment.BottomEnd }) {
              Scroll(this.myScroll) {  //2.使用自身构建的myscroll
                Column() {
                  Image($r('app.media.fly1'))
                  Image($r('app.media.fly2'))
                  Image($r('app.media.fly3'))
                  Image($r('app.media.fly4'))
                  Image($r('app.media.fly5'))
                }
                .width('100%')
              }
              .width('100%')
              .height('100%')
              .scrollBar(BarState.Auto) //只有滑动时显示
              .scrollBarColor(Color.Blue) //滑动颜色
              .scrollBarWidth(5) //滑动宽度
              .edgeEffect(EdgeEffect.Spring) //滑动效果，弹动

              Image($r('app.media.arrow_up_circle'))
                .width(40)
                .height(40)
                .backgroundColor(Color.White)
                .borderRadius(20)
                .margin({ bottom: 20, right: 20 })
                .onClick(() => {
                  this.myScroll.scrollEdge(Edge.Top)
                })
            }
            .width('100%')
            .layoutWeight(1)
          }
          .width('100%')
          .height('100%')
        }
        .tabBar(this.myBuilder(0, '航班信息', $r('app.media.airplane'), $r("app.media.airplane_1")))

        TabContent() {

          Column() {
            Text('已订票航班:')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })

            List({ space: 10, initialIndex: 0 }) {
              ForEach(this.bookings, (booking: Booking) => {
                ListItem() {
                  Row() {
                    Text(`${booking.flightId}: ${booking.passengerName}`)
                    Button('退票')
                      .onClick(() => {
                        const flightIndex = this.flights.findIndex(f => f.id === booking.flightId)
                        if (flightIndex !== -1) {
                          this.flights[flightIndex].seats++
                          this.bookings = this.bookings.filter(b => b !== booking)
                          AlertDialog.show({
                            title: '退票成功',
                            message: `已成功退订航班${booking.flightId}的一个座位`,
                            confirm: {
                              value: '确定',
                              action: () => {
                                this.currentView = 'menu'
                              }
                            }
                          })
                        }
                      })
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.SpaceBetween)
                }
              }, (booking: Booking) => `${booking.flightId}-${booking.passengerName}`)
            }
            .width('100%')
          }

          // .border({
          //   width:1,
          //   color:'#3274f6',
          //   style: BorderStyle.Solid
          // })


        }
        .tabBar(this.myBuilder(1, '我的', $r("app.media.person"), $r("app.media.person_1")))
      }
      .onChange((Index: number) => {
        this.selectedIndex = Index
      })
      .animationDuration(0)
      .scrollable(false)
    }
  }

  @Builder
  buildImportForm() {
    Column() {
      Row(){
      Image($r('app.media.return'))
        .width(45)
        .height(45)
        .onClick(() => {
          this.currentView = 'menu'
          this.showSearchResults = false
          this.selectedFlight = null
        })
        .margin({ bottom: 0 })
      Text('                                                               ')

          }

      Column() {
        Text('航班导入界面')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 30, bottom: 30 })
        TextInput({ placeholder: '航班ID' })
          .onChange((value: string) => {
            this.importFlightId = value
          })
          .margin(10)
        TextInput({ placeholder: '航空公司' })
          .onChange((value: string) => {
            this.importCompany = value
          })
          .margin(10)
        TextInput({ placeholder: '出发地' })
          .onChange((value: string) => {
            this.importFrom = value
          })
          .margin(10)
        TextInput({ placeholder: '目的地' })
          .onChange((value: string) => {
            this.importTo = value
          })
          .margin(10)
        TextInput({ placeholder: '日期 (YYYY-MM-DD)' })
          .onChange((value: string) => {
            this.importDate = value
          })
          .margin(10)
        TextInput({ placeholder: '座位数' })
          .onChange((value: string) => {
            this.importSeats = value
          })
          .margin(10)
        TextInput({ placeholder: '价格' })
          .onChange((value: string) => {
            this.importPrice = value
          })
          .margin(10)
        Button('确认导入')
          .margin({
            top: 20,
            bottom:200
          })
      Image($r('app.media.blue'))
        .width(2000)
        .height(70)
        .position({top:670})

      }

      // .border({
      //   width:1,
      //   color:'#3274f6',
      //   style: BorderStyle.Solid
      // })

      .onClick(() => {
        this.flights.push(new Flight(
          this.importFlightId,
          this.importCompany,
          this.importFrom,
          this.importTo,
          this.importDate,
          parseInt(this.importSeats),
          parseFloat(this.importPrice)
        ))
        AlertDialog.show({
          title: '导入成功',
          message: '航班信息已成功导入',
          confirm: {
            value: '确定',
            action: () => {
              this.currentView = 'menu'
            }
          }
        })
      })
    }
    .width('100%')
    .margin({ bottom: 20 })
  }

  @Builder
  buildSearchView() {
    Column() {
      Row(){
      Image($r('app.media.return'))
        .width(45)
        .height(45)
        .onClick(() => {
          this.currentView = 'menu'
          this.showSearchResults = false
          this.selectedFlight = null
        })
        .margin({ bottom: 10 })
        Text('                                                                ')
          }
      Column() {
        Row() {
          TextInput({ placeholder: '搜索航班' })
            .width('70%')
            .margin({ top: 30 })
            .onChange((value: string) => {
              this.searchTerm = value
            })
          Select([
            { value: 'ID' },
            { value: '航空公司' },
            { value: '出发地' },
            { value: '目的地' },
            { value: '价格' }
          ])
            .width('30%')
            .margin({ top: 30 })
            .selected(0)
            .onSelect((index: number) => {
              this.searchType =
                ['id', 'company', 'from', 'to', 'price'][index] as 'id' | 'company' | 'from' | 'to' | 'price'
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 10 })

        if (this.searchType === 'price') {
          Row() {
            TextInput({ placeholder: '最低价格' })
              .width('45%')
              .onChange((value: string) => {
                this.minPrice = parseFloat(value) || 0
              })
            TextInput({ placeholder: '最高价格' })
              .width('45%')
              .onChange((value: string) => {
                this.maxPrice = parseFloat(value) || Infinity
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 10 })
        }

        Button('搜索')
          .width('100%')
          .onClick(() => {
            this.showSearchResults = true
            this.selectedFlight = null
          })
          .margin({ bottom: 10 })

        if (this.showSearchResults) {
          Text('搜索结果:')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 10 })

          List({ space: 10, initialIndex: 0 }) {
            ForEach(this.flights.filter(flight =>
            this.searchTerm === '' ||
              (this.searchType === 'id' && flight.id.includes(this.searchTerm)) ||
              (this.searchType === 'company' && flight.company.includes(this.searchTerm)) ||
              (this.searchType === 'from' && flight.from.includes(this.searchTerm)) ||
              (this.searchType === 'to' && flight.to.includes(this.searchTerm)) ||
              (this.searchType === 'price' && flight.price >= this.minPrice && flight.price <= this.maxPrice)
            ), (flight: Flight) => {
              ListItem() {
                Column() {
                  Text(`${flight.id}: ${flight.company}, ${flight.from} 到 ${flight.to}, ${flight.date}, 座位: ${flight.seats}, 价格: ${flight.price}`)
                    .width('100%')
                    .textAlign(TextAlign.Start)
                  Button('订票')
                    .width('100%')
                    .onClick(() => {
                      this.selectedFlight = flight
                    })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
              }
            }, (flight: Flight) => flight.id)
          }
          .width('100%')
          .height(300)
        }

        if (this.selectedFlight) {
          Column() {
            Text(`已选择航班: ${this.selectedFlight.id}`)
              .margin({ top: 20, bottom: 10 })
            TextInput({ placeholder: '乘客姓名' })
              .width('100%')
              .onChange((value: string) => {
                this.name = value
              })
            Button('确认订票')
              .width('100%')
              .onClick(() => {
                if (this.selectedFlight && this.selectedFlight.seats > 0) {
                  this.selectedFlight.seats--
                  this.bookings.push(new Booking(this.selectedFlight.id, this.name))
                  AlertDialog.show({
                    title: '订票成功',
                    message: `${this.name}已成功预订航班${this.selectedFlight.id}`,
                    confirm: {
                      value: '确定',
                      action: () => {
                        this.selectedFlight = null
                        this.name = ''
                        this.showSearchResults = false
                      }
                    }
                  })
                } else {
                  AlertDialog.show({
                    title: '订票失败',
                    message: '该航班已无可用座位',
                    confirm: {
                      value: '确定',
                      action: () => {
                        this.selectedFlight = null
                      }
                    }
                  })
                }
              })
              .margin({ top: 10 })
          }
          .width('100%')
        }
      }
      .width('100%')
      .padding(20)
      //   .border({
      //     width: 1,
      //     color: '#3274f6',
      //     style: BorderStyle.Solid
      //   })
      // }
      .width('100%')
      .height('100%')
    }
    Image($r('app.media.blue'))
      .width(2000)
      .height(100)
  }

}