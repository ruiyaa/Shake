//
//  GameView.swift
//  Shake
//
//  Created by tanaka niko on 2025/07/12.
//
import AVFoundation
import SwiftUI

struct GameView: View {
    @StateObject private var shakeDetector = ShakeDetector()
    
    @State private var bubbleAudioPlayer:AVAudioPlayer!
    @State private var boomAudioPlayer:AVAudioPlayer!
    
    @State var limit = Int.random(in: 90...150)
    @State var yScale:CGFloat = 1
    @State var xScale:CGFloat = 1
    
    @State var isGameOver = false
    
    var body: some View {
        Group{
            if !isGameOver{
                Image("bottle")
                    .resizable()
                    .frame(width:150,height:450)
                    .scaleEffect(x:xScale,y:yScale)
            }else{
                VStack(spacing:40){
                    Image("gameover")
                        .resizable()
                        .scaledToFit()
                    Text("Game Over!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                    Button("もう一度"){
                     restartGame()
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(width: 250,height: 70)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal,20)
            }
          
        }
        .navigationBarBackButtonHidden()
        .onAppear{
            bubbleAudioPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "bubble")!.data)
            bubbleAudioPlayer.prepareToPlay()
            boomAudioPlayer = try! AVAudioPlayer(data: NSDataAsset(name: "boom")!.data)
            boomAudioPlayer.prepareToPlay()
        }
        .onChange(of:shakeDetector.shakeCount){
            if shakeDetector.shakeCount < limit && !isGameOver {
                playSoundandHaptic()
                let scale = CGFloat(shakeDetector.shakeCount) / CGFloat(limit)
                xScale = 1 + scale * 1.5
                yScale = 1 + scale
            } else{
                gameover()
            }
            
        }
    }
    
    func playSoundandHaptic(){
        bubbleAudioPlayer.currentTime = 0
        bubbleAudioPlayer.play()
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
    func gameover(){
        if !isGameOver{
            isGameOver = true
            boomAudioPlayer.currentTime = 0
            boomAudioPlayer.play()
            
            for i in 0..<6{
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                }
            }
        }
        
    }
    
    func restartGame() {
        isGameOver = false
        shakeDetector.shakeCount = 0
        limit = Int.random(in: 90...150)
        xScale = 1
        yScale = 1
    }
}

#Preview {
    GameView()
}
