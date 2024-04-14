//
//  SnakeGameViewModel.swift
//  Snake
//
//  Created by Shaunak Jagtap on 14/04/24.
//

import SwiftUI
import Combine

// ViewModel to manage game logic
@available(macOS 10.15, *)
class SnakeGameViewModel: ObservableObject {
    @Published var snake: [SnakeSegment] = []
    @Published var food: SnakeSegment = SnakeSegment(position: .zero)
    @Published var score: Int = 0
    @Published var gameover: Bool = false
    @Published var gameWidth: CGFloat = 0
    @Published var gameHeight: CGFloat = 0
    @Published var direction: Direction = .right
    @Published var foodEaten: Bool = false // Track whether food was eaten
    
    private var timer: Timer?
    
    func startGame(width: CGFloat, height: CGFloat) {
        gameWidth = width
        gameHeight = height
        snake = [SnakeSegment(position: CGPoint(x: gameWidth / 2, y: gameHeight / 2))]
        generateFood()
        startTimer()
    }
    
    func restartGame() {
        stopGame()
        gameover = false
        score = 0
        snake.removeAll()
        startGame(width: gameWidth, height: gameHeight)
    }
    
    func stopGame() {
        timer?.invalidate()
    }
    
    func handleSwipe(value: DragGesture.Value) {
        let horizontalMovement = value.translation.width
        let verticalMovement = value.translation.height
        
        if horizontalMovement > 0 && abs(horizontalMovement) > abs(verticalMovement) && direction != .left {
            changeDirection(.right)
        } else if horizontalMovement < 0 && abs(horizontalMovement) > abs(verticalMovement) && direction != .right {
            changeDirection(.left)
        } else if verticalMovement > 0 && abs(verticalMovement) > abs(horizontalMovement) && direction != .up {
            changeDirection(.down)
        } else if verticalMovement < 0 && abs(verticalMovement) > abs(horizontalMovement) && direction != .down {
            changeDirection(.up)
        }
    }
    
    func changeDirection(_ direction: Direction) {
        self.direction = direction
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if !self.gameover {
                self.moveSnake()
            }
        }
    }
    
    public func moveSnake() {
        guard !snake.isEmpty else {
            return
        }
        
        var head = snake.first!
        let _ = snake.last!
        
        switch direction {
        case .up:
            head.position.y -= gridSize
        case .down:
            head.position.y += gridSize
        case .left:
            head.position.x -= gridSize
        case .right:
            head.position.x += gridSize
        }
        
        if head.position.x < 0 || head.position.x >= gameWidth ||
           head.position.y < 0 || head.position.y >= gameHeight ||
           snake.dropFirst().contains(where: { $0.position == head.position }) {
            endGame()
            return
        }
        
        let dx = head.position.x - food.position.x
        let dy = head.position.y - food.position.y
        let distance = sqrt(dx * dx + dy * dy)
        if distance < gridSize / 2 {
            score += 1
            foodEaten = true // Set foodEaten to true when the snake eats the food
            generateFood()
            snake.insert(head, at: 0)
        } else {
            snake.insert(head, at: 0)
            snake.removeLast()
        }
    }
    
    public func generateFood() {
      var availablePositions = [(CGFloat, CGFloat)]()
      for x in stride(from: gridSize, through: gameWidth - gridSize, by: gridSize) { // Start from gridSize to avoid border
        for y in stride(from: gridSize, through: gameHeight - gridSize, by: gridSize) { // Start from gridSize to avoid border
          let position = CGPoint(x: x, y: y)
            if !snake.contains(where: { $0.position == position }) && position.x > gridSize && position.y > 100 {
            availablePositions.append((x, y))
          }
        }
      }
      
      if let randomPosition = availablePositions.randomElement() {
        food.position = CGPoint(x: randomPosition.0, y: randomPosition.1)
      } else {
        // Handle the case where no free positions are available (snake might fill most of the board)
        print("No available positions for food!")
      }
    }

    private func endGame() {
        timer?.invalidate()
        gameover = true
    }
}
