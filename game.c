#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define GRID_SIZE 4

extern int move(int board[][GRID_SIZE], int sx, int sy, int ex, int ey);


// Function declarations
void initializeBoard(int board[GRID_SIZE][GRID_SIZE]);
void printBoard(int board[GRID_SIZE][GRID_SIZE]);
void drawGrid(SDL_Renderer* renderer, int board[GRID_SIZE][GRID_SIZE]);
void drawRect(SDL_Renderer* renderer, int x, int y, Uint32 color);
// int move(int board[GRID_SIZE][GRID_SIZE], int sx, int sy, int ex, int ey);
void drawNumbers(SDL_Renderer* renderer, int board[GRID_SIZE][GRID_SIZE]);

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
        drawNumbers(renderer, board);
        // Inside your main loop
        // drawNumbers(board, renderer, font);


        SDL_RenderPresent(renderer);
        // printBoard(board);
    }

    // Destroy window
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}

void drawRect(SDL_Renderer* renderer, int x, int y, Uint32 color) {
    SDL_SetRenderDrawColor(renderer, color >> 16, (color >> 8) & 0xFF, color & 0xFF, 255);
    SDL_Rect rect = {x, y, CELL_SIZE, CELL_SIZE};
    SDL_RenderFillRect(renderer, &rect);
}

void drawNumbers(SDL_Renderer* renderer, int board[GRID_SIZE][GRID_SIZE]) {
    if (TTF_Init() != 0) {
        printf("TTF_Init: %s\n", TTF_GetError());
    }
    TTF_Font* Sans = TTF_OpenFont("Arialn.ttf", 600);

    SDL_Color Black = {0, 0, 0};


    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++){
            if (board[i][j] == 0) continue;
            char str[5];
            int num = board[i][j];
            sprintf(str, "%d", num);

            SDL_Surface* surfaceMessage = TTF_RenderText_Solid(Sans, str, Black); 
            SDL_Texture* Message = SDL_CreateTextureFromSurface(renderer, surfaceMessage);
            SDL_Rect Message_rect;
            Message_rect.x = i * CELL_SIZE + CELL_SIZE/2 - CELL_SIZE/8;
            Message_rect.y = j * CELL_SIZE + CELL_SIZE/2 - CELL_SIZE/8;
            Message_rect.w = CELL_SIZE/4;
            Message_rect.h = CELL_SIZE/4;

            SDL_RenderCopy(renderer, Message, NULL, &Message_rect);
            SDL_FreeSurface(surfaceMessage);
            SDL_DestroyTexture(Message);
        }
    }
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


//This should be in nasm
//This should also check if the move is valid
// int move(int board[GRID_SIZE][GRID_SIZE], int sx, int sy, int ex, int ey) {
//     // Check if the start and end points are the same
//     if (ex == sx && ey == sy) return 0;

//     // Move in a straight line (row or column)
//     if (ex - sx != 0 && ey - sy != 0) return 0;

//     // Check if path is clear
//     int stepX = (ex - sx) != 0 ? (ex - sx) / abs(ex - sx) : 0; // 1, -1 or 0
//     int stepY = (ey - sy) != 0 ? (ey - sy) / abs(ey - sy) : 0; // 1, -1 or 0

//     int x, y;
//     for (x = sx + stepX, y = sy + stepY; x != ex || y != ey; x += stepX, y += stepY) {
//         if (board[x][y] != 0) return 0; // Path is not clear
//     }

//     // Check the end cell
//     if (board[ex][ey] != 0 && board[ex][ey] != board[sx][sy]) return 0;

//     // Move or combine
//     if (board[ex][ey] == 0) {
//         board[ex][ey] = board[sx][sy];
//     } else if (board[ex][ey] == board[sx][sy]) {
//         board[ex][ey] *= 2;
//     }

//     board[sx][sy] = 0;

//     // Add a new tile
//     srand(time(NULL)); // Note: Ideally, srand should be called only once at the start of the main function
//     while (1) {
//         int r = rand() % GRID_SIZE;
//         int c = rand() % GRID_SIZE;
//         if (board[r][c] == 0) {
//             board[r][c] = 2;
//             break;
//         }
//     }

//     return 1; // Indicate a successful move
// }


//This should be in nasm
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

//Dont need this
void printBoard(int board[GRID_SIZE][GRID_SIZE]) {
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            printf("%4d", board[i][j]);
        }
        printf("\n");
    }
}
