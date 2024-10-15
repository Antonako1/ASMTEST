import tkinter as tk
import math

def draw_circle_with_line():
    root = tk.Tk()
    root.title("Clock face with hour hand")

    canvas = tk.Canvas(root, width=400, height=400, background="white")
    canvas.pack()

    canvas.create_oval(100, 100, 300, 300, outline="black", width=2, fill="white")

    center_x = (100 + 300) / 2
    center_y = (100 + 300) / 2
    max_value = 12
    max_value2= 60
    radius = 100  # Main circle radius
    handle_length = 0.9 * radius  # Handle length is 30% of the radius

    # Calculate the angle for the hour hand (in radians)
    # print("THETA LIKE:", theta)

    # # Calculate the end point for the line (hour hand) using the handle length
    CENTERPAD_M = 60
    for i in range (0, 60):
        value = i
        theta = (value * 360 / max_value2) * (math.pi / 180)
        to_x = center_x + handle_length * math.sin(theta)
        to_y = center_y - handle_length * math.cos(theta)
        canvas.create_line(center_x, center_y, to_x, to_y, fill="red", width=1)
    for i in range(0,12):
        value = i
        theta = (value * 360 / max_value) * (math.pi / 180)
        to_x = center_x + handle_length * math.sin(theta)
        to_y = center_y - handle_length * math.cos(theta)
        canvas.create_line(center_x, center_y, to_x, to_y, fill="red", width=3)
    canvas.create_oval(
        center_x - CENTERPAD_M, 
        center_y - CENTERPAD_M, 
        center_x + CENTERPAD_M, 
        center_y + CENTERPAD_M, 
        outline="white", width=2, fill="white")

    root.mainloop()

draw_circle_with_line()
