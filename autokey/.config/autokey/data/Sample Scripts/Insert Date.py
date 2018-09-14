import time
t = time.strftime("%Y-%m-%d %I:%M%p")
clipboard.fill_clipboard(t)
time.sleep(0.2)
keyboard.send_keys('<ctrl>+v')