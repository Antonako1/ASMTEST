#include <windows.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

// Global variables
HINSTANCE hInst;
LPCSTR szWindowClass = "MyWindowClass";
LPCSTR szTitle = "Timer-Based Drawing Example";

// Function declarations
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
SYSTEMTIME stS;

// Entry point of the Windows application
int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    WNDCLASSEX wcex;
    HWND hWnd;
    MSG msg;

    // Window class setup
    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = WndProc;
    wcex.cbClsExtra = 0;
    wcex.cbWndExtra = 0;
    wcex.hInstance = hInstance;
    wcex.hIcon = LoadIcon(NULL, IDI_APPLICATION);
    wcex.hCursor = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wcex.lpszMenuName = NULL;
    wcex.lpszClassName = szWindowClass;
    wcex.hIconSm = LoadIcon(NULL, IDI_APPLICATION);

    RegisterClassEx(&wcex);

    // Create the window
    hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
                        CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

    if (!hWnd) {
        return FALSE;
    }

    ShowWindow(hWnd, nCmdShow);
    UpdateWindow(hWnd);

    // Set a timer to trigger every 1000 milliseconds (1 second)
    SetTimer(hWnd, 1, 1000, NULL);
    GetLocalTime(&stS);
    // Main message loop
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return (int)msg.wParam;
}
// Window procedure function
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    static int counter = 0;
    PAINTSTRUCT ps;
    HDC hdc;
    char buffer[256];

    switch (message) {
        case WM_TIMER:
            // On each timer tick, invalidate the window to trigger a repaint
            GetLocalTime(&stS);
            InvalidateRect(hWnd, NULL, TRUE);
            break;

        case WM_PAINT:
            hdc = BeginPaint(hWnd, &ps);
            SetBkMode(hdc, TRANSPARENT);
            sprintf(buffer, "%d:%d:%d.%d", stS.wHour, stS.wMinute, stS.wSecond, stS.wMilliseconds);
            TextOutA(hdc, 50, 50, buffer, strlen(buffer)); 
            EndPaint(hWnd, &ps);

            HBRUSH hBrush = CreateSolidBrush(RGB(0, 0, 255));  // Blue color
            DeleteObject(hBrush);
            break;

        case WM_DESTROY:
            KillTimer(hWnd, 1);  // Stop the timer when the window is destroyed
            PostQuitMessage(0);
            break;

        default:
            return DefWindowProc(hWnd, message, wParam, lParam);
    }

    return 0;
}
