#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

// Function declarations
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);

// Entry point for the application
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Step 1: Register the window class
    static TCHAR CLASS_NAME[] = _T("SampleWindowClass");
    
    WNDCLASS wc = { 0 };

    wc.lpfnWndProc = WindowProc;    // Set the window procedure
    wc.hInstance = hInstance;       // Handle to the current instance
    wc.lpszClassName = CLASS_NAME;  // Window class name

    RegisterClass(&wc);

    // Step 2: Create the window
    HWND hwnd = CreateWindowEx(
        0,                             // Optional window styles
        CLASS_NAME,                    // Window class
        _T("Hello, World!"),               // Window title
        WS_OVERLAPPEDWINDOW,           // Window style

        // Position and size
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,

        NULL,                          // Parent window (not used)
        NULL,                          // Menu (not used)
        hInstance,                     // Instance handle
        NULL                           // Additional application data (not used)
    );

    if (hwnd == NULL) {
        return 0;
    }

    ShowWindow(hwnd, nCmdShow);

    // Step 3: Run the message loop
    MSG msg = { 0 };
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}

// Step 4: Implement the window procedure
LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;

        case WM_CREATE:
            // MessageBox(hwnd, _T("Hello, World!"), _T("Welcome"), MB_OK | MB_ICONINFORMATION);
            return 0;
    }

    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}
