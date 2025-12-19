# Google Plasmoid Suite

A collection of widgets for KDE Plasma 6 that integrate Google services directly into your panel. This suite provides a seamless, native-feeling experience for Calendar, Gmail, Messages, and YouTube Music.

## Features

* **Unified Session:** You only need to sign in once. Your session is persisted and shared across all installed widgets in the suite.
* **Robust Notifications:** Gmail, Google Messages, and Google Calendar are fully integrated with the KDE Plasma notification system. You will receive native desktop notifications for incoming emails, messages, and events.
* **Flexible Installation:** Install only the widgets you need, or use them all together.
* **Integrated Design:** Google Calendar doubles as a customizable digital clock for your panel. The rest show up as round, "Pixel" style icons.

## Included Plasmoids

* **Google Calendar Clock** (`web.com.google.calendar`)
* **Gmail** (`web.com.google.mail`)
* **Google Messages** (`web.com.google.messages`)
* **YouTube Music** (`web.com.youtube.music`)

## Installation

### Prerequisites
* KDE Plasma 6.0 or higher

### Steps

1.  Clone this repo and `cd` into it:
    ```
    git clone https://github.com/areyoufeelingitnowmrkrebs/googleplasmoidsuite.git && cd googleplasmoidsuite
    ```

2.  Make sure your user has a `plasmoids` directory:
    ```
    mkdir -p ~/.local/share/plasma/plasmoids
    ```

3.  **⚠️ IMPORTANT:** You **must** install `web.com.google.account`, regardless of which widgets you want. This is because it is not an actual plasmoid itself, it is the singleton that allows the rest of them to share session cookies. You do not need to use more than one widget if you don't want to, but none of them will work without `web.com.google.account`.
    ```
    cp -r web.com.google.account ~/.local/share/plasma/plasmoids
    ```

4.  If you haven't already, copy or move the plasmoids you want to `~/.local/share/plasma/plasmoids` with the singleton package.
    Example:
    ```
    cp -r web.com.google.messages ~/.local/share/plasma/plasmoids
    ```

5. Restart the plasmashell to make sure they're detected:
   ```
   systemctl --user restart plasma-plasmashell
   ```

## Usage

1.  Right-click on your panel and select "Add or Manage Widgets".
2.  Search for the Google service you installed (e.g., "Gmail", "Google Calendar Clock").
3.  Drag the widget to your panel.
4.  Log in via the widget's web interface. You should now *already* be logged in when you add more widgets from this suite.

## License

This project is licensed under the GPL-2.0+ License.
