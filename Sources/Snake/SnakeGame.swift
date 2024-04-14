//
//  SnakeGame.swift
//  Snake
//
//  Created by Shaunak Jagtap on 14/04/24.
//

import SwiftUI
// Constants for game settings
let gridSize: CGFloat = 20

// Enum representing directions
enum Direction {
    case up, down, left, right
}

// Main view representing the game
@available(macOS 10.15, *)
struct SnakeGameView: View {
    @StateObject var viewModel = SnakeGameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            let calculatedGameWidth = geometry.size.width - 40
            let calculatedGameHeight = geometry.size.height - 200
            
            VStack {
                Text("Score: \(viewModel.score)")
                    .foregroundColor(.white)
                    .padding()
                
                ZStack {
                    // Game board
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: viewModel.gameWidth, height: viewModel.gameHeight)
                        .border(Color.white, width: 2)
                    
                    // Snake
                    ForEach(viewModel.snake, id: \.self) { segment in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: gridSize, height: gridSize)
                            .position(segment.position)
                    }
                    
                    // Food (replaced with rat emoji)
                    Text("🐀")
                        .font(.system(size: 25)) // Increase the font size to make the food emoji bigger
                        .position(viewModel.food.position)
                    
                }
                .gesture(
                    DragGesture()
                        .onEnded(viewModel.handleSwipe)
                )
                
                Button(action: viewModel.restartGame) {
                    Text("Restart")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.startGame(width: calculatedGameWidth, height: calculatedGameHeight)
            }
            .onDisappear(perform: viewModel.stopGame)
        }
    }
}
