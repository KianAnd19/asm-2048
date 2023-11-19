#include <SDL2/SDL.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define GRID_SIZE 4

// Function declarations
void initializeBoard(int board[GRID_SIZE][GRID_SIZE]);
void printBoard(int board[GRID_SIZE][GRID_SIZE]);
void drawGrid(SDL_Renderer* renderer, int board[GRID_SIZE][GRID_SIZE]);
void drawRect(SDL_Renderer* renderer, int x, int y, Uint32 color);
int move(int board[GRID_SIZE][GRID_SIZE], int sx, int sy, int ex, int ey);

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 800;
const int CELL_SIZE = 200;  // Size of each cell in the grid
const int GRID_LINES_WIDTH = 5; // Width of the grid lines
const int BOARD_SIZE = 4;   // 2048 is a 4x4 grid
const Uint32 colours[11] = {0xFFFFFF, 0x80ffdb, 0x72efdd, 0x64dfdf, 0x56cfe1, 0x48bfe3, 0x4ea8de, 0x5390d9, 0x5e60ce, 0x6930c3, 0x7400b8};


int main(int argc, char* argv[]) {
    SDL_Window* window = NULL;
    SDL_Renderer* renderer = NULL;

    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        printf("SDL could not initialize! SDL_Error: %s\n", SDL_GetError());
        return 1;
    }

    window = SDL_CreateWindow("2048 Game", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WINDOW_WIDTH, WINDOW_HEIGHT, SDL_WINDOW_SHOWN);
    if (window == NULL) {
        printf("Window could not be created! SDL_Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    if (renderer == NULL) {
        SDL_DestroyWindow(window);
        printf("Renderer could not be created! SDL_Error: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    // Main loop flag
    int quit = 0;

    // Event handler
    SDL_Event e;

    int board[GRID_SIZE][GRID_SIZE];
    initializeBoard(board);
    printBoard(board);

    // Main loop
    while (!quit) {
        int sx, sy;
        int ex, ey;

        while (SDL_PollEvent(&e) != 0) {
            if (e.type == SDL_QUIT) {
                quit = 1;
            }
            else if (e.type == SDL_MOUSEBUTTONDOWN) {
                int x, y;
                SDL_GetMouseState(&x, &y);
                sx = x / CELL_SIZE;
                sy = y / CELL_SIZE;

                printf("Mouse click at start (%d, %d)\n", sx, sy);

            }
            else if (e.type == SDL_MOUSEBUTTONUP) {
                int x, y;
                SDL_GetMouseState(&x, &y);
                ex = x / CELL_SIZE;
                ey = y / CELL_SIZE;

                printf("Mouse click at end (%d, %d)\n", ex, ey);

                int new_board = move(board, sx, sy, ex, ey);
                printBoard(board);
            }
        }

        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255); // White color for background
        SDL_RenderClear(renderer);

        drawGrid(renderer, board);

        SDL_RenderPresent(renderer);
        // printBoard(board);
    }

    // Destroy window
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}

int move(int board[GRID_SIZE][GRID_SIZE], int sx, int sy, int ex, int ey) {
    board[ex][ey] = board[sx][sy];
    board[sx][sy] = 0;
    return 1;
}

void drawRect(SDL_Renderer* renderer, int x, int y, Uint32 color) {
    SDL_SetRenderDrawColor(renderer, color >> 16, (color >> 8) & 0xFF, color & 0xFF, 255);
    SDL_Rect rect = {x, y, CELL_SIZE, CELL_SIZE};
    SDL_RenderFillRect(renderer, &rect);
}

void drawGrid(SDL_Renderer* renderer, int board[GRID_SIZE][GRID_SIZE]) {
    // Drawing the cells
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++){
            drawRect(renderer, i * CELL_SIZE, j * CELL_SIZE, colours[board[i][j]]);
        }
    }

    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255); // Black color for grid lines
    // Drawing vertical lines
    for (int i = 0; i <= BOARD_SIZE; i++) {
        SDL_RenderDrawLine(renderer, 
                           i * CELL_SIZE, 
                           0, 
                           i * CELL_SIZE, 
                           BOARD_SIZE * CELL_SIZE);
    }

    // Drawing horizontal lines
    for (int j = 0; j <= BOARD_SIZE; j++) {
        SDL_RenderDrawLine(renderer, 
                           0, 
                           j * CELL_SIZE, 
                           BOARD_SIZE * CELL_SIZE, 
                           j * CELL_SIZE);
    }


}


void initializeBoard(int board[GRID_SIZE][GRID_SIZE]) {
    // Initialize all cells to 0
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            board[i][j] = 0;
        }
    }

    // Add two '2's to random positions
    srand(time(NULL));
    for (int i = 0; i < 2; i++) {
        int r = rand() % GRID_SIZE;
        int c = rand() % GRID_SIZE;
        board[r][c] = 2;
    }
}

void printBoard(int board[GRID_SIZE][GRID_SIZE]) {
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            printf("%4d", board[i][j]);
        }
        printf("\n");
    }
}
