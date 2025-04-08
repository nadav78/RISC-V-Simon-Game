# RISC-V Simon Game

A Simon-style memory game implemented in RISC-V assembly language. This project 
demonstrates low-level programming with hardware interaction, controlling LEDs 
and reading input from a D-pad.

## Features
- Classic Simon gameplay with random sequence generation
- Progressive difficulty - sequences get longer as you succeed
- Visual feedback through LED colors
- Interactive input via D-pad controls

## Implementation Details

### Game Architecture
The Simon game is implemented in RISC-V assembly with a focus on efficient memory usage and hardware interaction. The core components include:

- **Memory Management**: Uses a combination of static data segment for constants and heap memory for dynamically growing sequences.
- **I/O Handling**: Direct hardware interaction with the LED matrix (output) and D-pad controller (input).
- **Game Logic**: Implements the classic Simon gameplay with sequence generation, display, and validation.

### Color and Direction Mapping
The game uses a 2x2 LED matrix with the following mapping:
- **RED (0x0FF0000)** at position (0,0) - corresponds to UP on D-pad
- **BLUE (0x0000FF)** at position (1,1) - corresponds to DOWN on D-pad
- **YELLOW (0xFFFF00)** at position (0,1) - corresponds to LEFT on D-pad
- **GREEN (0x00FF00)** at position (1,0) - corresponds to RIGHT on D-pad

### Key Components

#### 1. Random Sequence Generation
- Implements an enhanced Linear Congruential Generator (LCG) algorithm for better randomness
- Formula: `x₁ = (a·x₀ + b) mod m` where:
  - a = 1103515245
  - b = 12345
  - m = 1073741824
- System time is used as the initial seed for unpredictability

#### 2. Memory Management
- Dynamic sequence storage using the heap
- Sequence length tracking for difficulty progression
- Efficient memory allocation for growing sequences

#### 3. LED Control
- Direct hardware access to LED matrix through memory-mapped I/O
- Visual feedback for player actions and game states (success/failure)
- Timed LED patterns with configurable delays

#### 4. Input Handling
- D-pad polling with debouncing for reliable input capture
- Mapping of physical inputs to game actions
- Wait-for-release mechanism to prevent multiple triggers

#### 5. Game Flow
- Initial sequence display phase
- User input and validation phase
- Feedback phase (success/failure)
- Difficulty progression (sequence length increases with each success)

The program demonstrates efficient low-level programming techniques while delivering an engaging gameplay experience through direct hardware interaction.

## How to Run
Please refer to documentation.pdf

## Development Process
This project was developed incrementally, with several enhancements:
1. Basic sequence generation and display
2. User input validation
3. Improved randomization algorithm
4. Progressive difficulty levels