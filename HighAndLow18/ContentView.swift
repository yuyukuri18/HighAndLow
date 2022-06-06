//
//  ContentView.swift
//  HighAndLow18
//
//  Created by cmStudent on 2021/11/08.
//

import SwiftUI

struct ContentView: View{
    @ObservedObject var contentViewModel = ContentViewModel()
    @State var navigation = 0
    var body: some View {
        ZStack{
            Color.init("BackColor")
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    VStack{
                        Image(contentViewModel.leftCard)
                            .resizable()
                            .frame(width: 200.0, height: 280.0)
                        
                        Text("あいて")
                    }
                    VStack{
                        Image(contentViewModel.rightCard)
                            .resizable()
                            .frame(width: 200.0, height: 280.0)
                        
                        Text("あなた")
                    }
                }
            }
            .padding(.bottom, 500.0)
            if navigation == 0{
                
                VStack{
                    Spacer()
                    Button(action:{
                        contentViewModel.setup()
                        navigation = 1
                    }){
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 120.0, height: 120.0)
                            .foregroundColor(Color.gray)
                        Text("ゲームスタート")
                            .font(.largeTitle)
                            .foregroundColor(Color.gray)
                    }
                    .frame(width: 375.0, height: 120.0, alignment: .center)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .stroke(Color.gray, lineWidth: 10)
                    )
                    Button(action:{
                        navigation = 3
                    }){
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 120.0, height: 120.0)
                            .foregroundColor(Color.gray)
                        Text("ランキング")
                            .font(.largeTitle)
                            .foregroundColor(Color.gray)
                    }
                    .frame(width: 375.0, height: 120.0, alignment: .center)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 90)
                            .stroke(Color.gray, lineWidth: 10)
                    )
                }
            }
            if navigation == 1{
                VStack{
                    Spacer()
                    if(contentViewModel.winCount >= 1){
                        Text("\(contentViewModel.winCount)連勝中")
                            .font(.largeTitle)
                    }
                    Button(action: {
                        contentViewModel.selectedHigh()
                        navigation = 2
                    }){
                        Text("High")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .frame(width: 340.0, height: 140.0)
                            .background(Color("HighColor"))
                            .cornerRadius(35.0)
                    }
                    .padding(.bottom, 60.0)
                    Button(action: {
                        contentViewModel.selectedLow()
                        navigation = 2
                    }){
                        Text("Low")
                            .font(.largeTitle)
                            .foregroundColor(Color.white)
                            .frame(width: 340.0, height: 140.0)
                            .background(Color("LowColor"))
                            .cornerRadius(35.0)
                    }
                }
            }
            if navigation == 2{
                VStack{
                    Spacer()
                    Text("\(contentViewModel.isText)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("HighColor"))
                        .frame(width: 340.0, height: 140.0)
                    Text("\(contentViewModel.isText2)")
                        .font(.title2)
                    
                    if(contentViewModel.isResult == true){
                        Text("\(contentViewModel.winCount)連勝中")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top, 20.0)
                        
                        Button(action: {
                            contentViewModel.nextGame()
                            navigation = 1
                        }){
                            Text("次のゲームへ")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .frame(width: 340.0, height: 140.0)
                                .background(Color("HighColor"))
                                .cornerRadius(35.0)
                        }
                        .padding(.top, 120.0)
                    }
                    else {
                        HStack{
                            Text("連勝記録")
                            Text("\(contentViewModel.winCount)")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        .padding(.top, 20.0)
                        
                        Button(action: {
                            contentViewModel.reset()
                            navigation = 0
                            contentViewModel.winCount = 0
                        }){
                            Text("タイトル画面へ")
                                .font(.largeTitle)
                                .foregroundColor(Color.white)
                                .frame(width: 340.0, height: 140.0)
                                .background(Color("LowColor"))
                                .cornerRadius(35.0)
                        }
                        .padding(.top, 120.0)
                    }
                }
                
            }
            if navigation == 3{
                HStack{
                    Text("1st....")
                    Text("\(contentViewModel.score1)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                    
                }
                HStack{}
                HStack{}
                Button(action: {
                    navigation = 0
                }){
                    Text("ホームに戻る")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .frame(width: 340.0, height: 140.0)
                        .background(Color("HighColor"))
                        .cornerRadius(35.0)
                }
            }
        }
    }
}

class ContentViewModel: ObservableObject {
    // 左側のカード画像
    // BKは背面
    @Published var leftCard = "BK"
    // 右側のカード画像
    @Published var rightCard = "BK"
    
    // 連勝記録
    @Published var winCount = 0
    @Published var vol = 0
    @Published var isText = ""
    @Published var isText2 = ""
    @Published var isResult = false
    @Published var score1 = 0
    @Published var score2 = 0
    @Published var score3 = 0
    
    
    // 左側のカード番号
    private var leftCardNumber = 0
    // 右側のカード番号
    private var rightCardNumber = 0
    
    private var gameManager = GameManager()
    
    
    // スタートボタン押下時等、ゲーム開始時に使う
    func setup(){
        // 左側のカードをめくる
        /*switch cardImage{
         case 1:
         ("C01")
         return
         case 2:
         ("C09")
         return
         case 3:
         ("C09")
         return
         case 4:
         ("C09")
         return
         case 5:
         ("C09")
         return
         case 6:
         ("C09")
         return
         case 7:
         ("C09")
         return
         case 8:
         ("C09")
         return
         case 9:
         ("C09")
         return
         case 10:
         ("C13")
         return
         case 11:
         ("C13")
         return
         case 12:
         ("C13")
         return
         case 13:
         ("C13")
         return
         default:
         break
         }*/
        //カードの画像と、カードの番号を作成する
        
        leftCardNumber = gameManager.card().number// 左側のカードの番号を保持しておく
        leftCard = "\(gameManager.card().card)\(leftCardNumber)"// 左側のカードの画像を変更して表示する
        
        // 右側のカードはなにもしない（初期状態に戻す）
        rightCardNumber = 0
        rightCard = "BK"
        
        return
    }
    
    // カードを選択した時に呼ばれる。引数は適宜変更してOK
    func selectedHigh() {
        rightCardNumber = gameManager.card().number
        rightCard = "\(gameManager.card().card)\(rightCardNumber)"
        
        vol = gameManager.compare(left: leftCardNumber, right: rightCardNumber)
        
        if(vol == -1){
            isResult = gameManager.isWin(selected: true, isHigh: true)
        } else if (vol == 1){
            isResult = gameManager.isWin(selected: true, isHigh: false)
        } else {
            isResult = gameManager.isWin(selected: true, isHigh: true)
        }
        
        if(isResult == false){
            isText = "LOSE!"
            isText2 = "あなたの負け"
            
        } else {
            isText = "WIN"
            isText2 = "あなたの勝ち"
            winCount += 1
        }
    }
    func selectedLow() {
        rightCardNumber = gameManager.card().number
        rightCard = "\(gameManager.card().card)\(rightCardNumber)"
        
        vol = gameManager.compare(left: leftCardNumber, right: rightCardNumber)
    
        if(vol == 1){
            isResult = gameManager.isWin(selected: false, isHigh: false)
        } else if (vol == -1){
            isResult = gameManager.isWin(selected: false, isHigh: true)
        } else {
            isResult = gameManager.isWin(selected: false, isHigh: true)
        }
        
        if(isResult == false){
            isText = "LOSE!"
            isText2 = "あなたの負け"
            
        } else {
            isText = "WIN"
            isText2 = "あなたの勝ち"
            winCount += 1
        }
    }
    
    //全て最初の状態にする
    func reset() {
        rightCardNumber = 0
        rightCard = "BK"
        leftCardNumber = 0
        leftCard = "BK"
        leftCardNumber = 0
        rightCardNumber = 0
        
        if ((winCount > score1 || winCount == score1)){
            score3 = score2
            score2 = score1
            score1 = winCount
        } else if ((winCount < score1 && winCount > score2) || winCount == score2){
            score3 = score2
            score2 = winCount
        } else if ((winCount < score2 && winCount > score3) || winCount == score3){
            score3 = winCount
        }
    }
    
    func nextGame(){
        leftCard = rightCard
        leftCardNumber = rightCardNumber
        rightCardNumber = 0
        rightCard = "BK"
    }
}


// Model
struct GameManager {
    // カードを取得する処理
    // タプルを使えば便利なのだけれど、まだやっていないからね…
    var cardType = ""
    var cardNumber = 0
    
    mutating func card() -> (card: String, number: Int) {
        let random = Int.random(in: 1...54)
        switch random{
        case 1...13: cardType = "C"
        case 14...26: cardType = "S"
        case 27...39: cardType = "H"
        case 40...52: cardType = "D"
        default: break
        }
        //let cardType: String = String(cardty)
        // カードの種類
        // 1: ♥
        // 2: ♦
        // 3: ♠
        // 4: ♣
        cardNumber = Int.random(in: 1...13)
        
        // カードの番号
        // 1〜13
        // ジョーカーは現状考慮していないが追加してもOK
        // 戻り値はカードの種類、スペース、カードの番号
        return ("\(cardType)",cardNumber)
    }
    
    /// 第一引数が大きいならば1
    /// 第二引数が多いいならば-1
    /// 等しい場合は0
    /// ただし、1は他の数字よりも大きい
    func compare(left: Int, right: Int) ->  Int{
        if(left == 1){
            return 1
        } else if(right == 1){
            return -1
        } else if(left > right){
            return 1
        } else if(left <= right){
            return -1
        } else {
            return 0
        }
    }
    
    // 勝敗を決める
    // Highならばtrue、Lowならfalseとかにしておくと良い
    // 勝ちならばtrue、負けならばfalse
    func isWin(selected: Bool, isHigh: Bool) -> Bool {
        if(selected == true){
            if(isHigh == true){
                return true
            }else{
                return false
            }
        } else if(selected == false){
            if(isHigh == true){
                return false
            }else{
                return true
            }
        } else {
            return true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
