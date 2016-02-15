module plut.plut;

import plut.console;
import plut.window;

class Plut {
    private static Console console_;
    private static Window mainWindow_;

    public static @property Console console() {
        if (console_ is null) {
            console_ = new Console();
        }

        return console_;
    }

    public static @property Window mainWindow() {
        if (mainWindow_ is null) {
            mainWindow_ = new Window(console.size, 999);
        }

        return mainWindow_;
    }

};
