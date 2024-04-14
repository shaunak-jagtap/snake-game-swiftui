//
//  SnakeTests.swift
//  SnakeTests
//
//  Created by Shaunak Jagtap on 14/04/24.
//

import XCTest
@testable import Snake

final class SnakeTests: XCTestCase {

    var viewModel: SnakeGameViewModel!
    let gameWidth: CGFloat = 300
    let gameHeight: CGFloat = 400
    
    override func setUpWithError() throws {
        // Initialize the view model with mock data
        viewModel = SnakeGameViewModel()
        viewModel.startGame(width: gameWidth, height: gameHeight)
    }

    override func tearDownWithError() throws {
        // Clean up resources
        viewModel = nil
    }

    func testSnakeMovesCorrectly() throws {
        // Move the snake in a specific direction
        viewModel.changeDirection(.right)
        viewModel.moveSnake()
        
        // Assert that the snake's head moved one grid unit to the right
        XCTAssertEqual(viewModel.snake.first?.position.x, gameWidth / 2 + gridSize)
        XCTAssertEqual(viewModel.snake.first?.position.y, gameHeight / 2)
    }

    func testFoodGeneration() throws {
        // Generate food
        viewModel.generateFood()
        
        // Assert that the food is within the game boundaries
        XCTAssertTrue(viewModel.food.position.x >= 0 && viewModel.food.position.x < gameWidth)
        XCTAssertTrue(viewModel.food.position.y >= 0 && viewModel.food.position.y < gameHeight)
    }

    func testGameRestart() throws {
        // Restart the game
        viewModel.restartGame()
        
        // Assert that the snake is at its initial position and the game is not over
        XCTAssertEqual(viewModel.snake.count, 1)
        XCTAssertEqual(viewModel.snake.first?.position, CGPoint(x: gameWidth / 2, y: gameHeight / 2))
        XCTAssertFalse(viewModel.gameover)
        XCTAssertEqual(viewModel.score, 0)
    }
    
    func testSnakeCollisionDetection() throws {
        // Move the snake to collide with itself
        viewModel.snake = [SnakeSegment(position: CGPoint(x: gameWidth / 2, y: gameHeight / 2)),
                           SnakeSegment(position: CGPoint(x: gameWidth / 2 + gridSize, y: gameHeight / 2))]
        viewModel.changeDirection(.right)
        viewModel.moveSnake()
        
        // Assert that the game is over
        XCTAssertTrue(viewModel.gameover)
    }
}
