# Game of Life Implemented in WebAssembly

Game of Life implemented by hand in the WebAssembly Text Format (WAT).
The board "wraps around" both horizontally and vertically.
The size of the board can be adjusted by changing the global WebAssembly variables: `universe_length` and `universe_height`.

The core functionality of the game is implemented in WebAssembly.
The host, JavaScript, invokes the WebAssembly functions to setup the board, advance the universe, and get the state of the cells for drawing purposes.

<img width="541" height="497" alt="image" src="https://github.com/user-attachments/assets/d6f934c4-1f16-4754-a9d9-323bd147e6e0" />
