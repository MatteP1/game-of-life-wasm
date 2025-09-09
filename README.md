# Game of Life Implemented in WebAssembly

Game of Life implemented by hand in the WebAssembly Text Format (WAT).
The board "wraps around" both horizontally and vertically.
The size of the board can be adjusted by changing the global WebAssembly variables: `universe_length` and `universe_height`.

The core functionality of the game is implemented in WebAssembly.
The host, JavaScript, invokes the WebAssembly functions to setup the board, advance the universe, and get the state of the cells for drawing purposes.

![Recording 2025-09-09 133631](https://github.com/user-attachments/assets/0346bcb8-e04d-4c8c-9f9c-2a5979f982f6)
