#!/usr/bin/env python

from pynput import keyboard
#from pynput.keyboard import Controller

def on_press(key):
        try:
                if key == keyboard.KeyCode.from_char('enter'):
                        pass
                elif key == keyboard.Key.left:
                        print("1")
                elif key == keyboard.Key.right:
                        print("2")
                elif key == keyboard.Key.up:
                        print("3")
                elif key == keyboard.Key.down:
                        print("3")
                elif key == keyboard.KeyCode.from_char('q'):
                        exit(-1)

        except AttributeError:
                print('special key {0} pressed'.format(key))

def on_release(key):
        print('{0} released'.format(key))
        if key == keyboard.Key.esc:
                # Stop listener
                return False
        
if __name__ == '__main__':
        with keyboard.Listener(
                on_press=on_press,
                on_release=on_release) as listener:
                listener.join()
