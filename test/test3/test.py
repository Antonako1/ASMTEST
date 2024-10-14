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
    hours = 4
    radius = 100  # Main circle radius
    handle_length = 0.5 * radius  # Handle length is 30% of the radius

    # Calculate the angle for the hour hand (in radians)
    theta = (hours * 360 / 12) * (math.pi / 180)  # Convert hour to angle
    print("THETA LIKE:", theta)

    # Calculate the end point for the line (hour hand) using the handle length
    to_x = center_x + handle_length * math.sin(theta)
    to_y = center_y - handle_length * math.cos(theta)
    print("Line end point: (", to_x, ",", to_y, ")")

    # Draw the hour hand with the calculated handle length
    canvas.create_line(center_x, center_y, to_x, to_y, fill="red", width=2)

    root.mainloop()

draw_circle_with_line()
