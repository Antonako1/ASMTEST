import tkinter as tk
import math

def draw_circle_with_line():
    root = tk.Tk()
    root.title("Clock face with hour hand")

    canvas = tk.Canvas(root, width=400, height=400)
    canvas.pack()

    canvas.create_oval(100, 100, 300, 300, outline="black", width=2)

    center_x = (100 + 300) / 2
    center_y = (100 + 300) / 2
    hours = 555
    radius = 100

    # Calculate the angle for the hour hand (in radians)
    # We convert hours to an angle by multiplying by (360/12) to get degrees, and then convert to radians.
    theta = (hours * 360 / 1000) * (math.pi / 180)
    print("THETA LIKE:", theta)
    # Calculate the end point for the line (hour hand)
    to_x = center_x + radius * math.sin(theta)
    # to_y = center_y - radius * math.cos(theta)
    to_y = 0
    print("Line end point: (", to_x, ",", to_y, ")")

    canvas.create_line(center_x, center_y, to_x, to_y, fill="red", width=2)

    root.mainloop()

draw_circle_with_line()
