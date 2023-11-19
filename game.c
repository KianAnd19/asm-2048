#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define GRID_SIZE 4

// Function declarations
void initializeBoard(int board[GRID_SIZE][GRID_SIZE]);
void printBoard(int board[GRID_SIZE][GRID_SIZE]);

int main() {
    int board[GRID_SIZE][GRID_SIZE];

    initializeBoard(board);
    printBoard(board);

    // Game loop goes here

    return 0;
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
