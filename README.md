Blitz
=====

# Development setup

- [Install git](http://git-scm.com/downloads)
- Clone the repo: `git clone git@github.com:schmich/blitz`
- [Install Ruby](https://www.ruby-lang.org/en/downloads/)
 - On Windows, use [RubyInstaller](http://rubyinstaller.org/)
 - Install version 1.9.3
 - Sencha tools do not work with Ruby 2.0.0 yet
- [Install Ruby DevKit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) for building native extensions
 - The version should match your Ruby version

## Server setup

- Install bundler: `gem install bundler`
- Install rake: `gem install rake`
- Install Postgres
- Under `/web`:
 - Copy `application.yml` from Project Blitz folder in Google Drive to `config/` folder
 - Install dependencies: `bundle install`
 - Create the database: `rake db:create`
 - Ensure the database is up-to-date: `rake db:migrate`

### Running the server

- Under `/web`:
 - Start the server: `rails s`

## App setup

- [Install the latest JDK](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
- Set `JAVA_HOME` to point to your JDK installation path
 - e.g. `C:\Program Files\Java\jdk1.7.0_45`
 - e.g. `/Library/Java/JavaVirtualMachines/jdk1.7.0_45.jdk/Contents/Home`
- [Install Sencha Cmd](http://www.sencha.com/products/sencha-cmd/download)
- Add Sencha tools to your `PATH`
 - e.g. `C:\dev\Sencha\Cmd\4.0.0.203`
 - e.g. `/Users/foo/dev/Sencha/Cmd/4.0.0.203`
- [Install NodeJS](http://nodejs.org/)
- Install Cordova: `npm install -g cordova`
- Install PhoneGap: `npm install -g phonegap`
- [Install Ant](http://ant.apache.org/manual/install.html)
 - On Windows, download the [binary distribution zip archive](http://ant.apache.org/bindownload.cgi#Current%20Release%20of%20Ant)
 - Extract the contents to some folder (e.g. `C:\dev\Ant`)
- Add Ant binaries to your `PATH`
 - e.g. `C:\dev\Ant\bin`
 - e.g. `/Users/foo/dev/ant/bin`

### Running the app in a browser

- Under `/app`:
  - Run the app server: `sencha fs web -port 8000 start`
  - Browse to [http://127.0.0.1:8000](http://127.0.0.1:8000)
- We need to disable same origin policy for this to work (sencha app is acessing Rails server, both of which are on localhost)
  - OSX: open -a Google\ Chrome --args --disable-web-security
  - Windows: chrome.exe --disable-web-security
  - FireFox: use the 'Force CORS' add-on

### Doing CSS changes in the app
- to add new file:
  - cd to `/app/resources/sass/include`
  - create new file beginning '_' in the name
  - modify `/app/resources/sass/app.scss` and add `@import 'include/<filename>';`
- to compile changes:
  - cd to `/app/resources/sass`
  - run `sencha compass compile`
- to have compass watch for changes:
  - cd to `/app/resources/sass`
  - run `sencha compass watch` 

### Running the app on Android

- [Install the Android SDK](http://developer.android.com/sdk/index.html)
- Add Android base tools and platform tools to your `PATH`
 - e.g. `C:\dev\Android\sdk\tools` and `C:\dev\Android\sdk\platform-tools`
 - e.g. `/Users/foo/dev/Android/sdk/tools` and `/Users/foo/dev/Android/sdk/platform-tools`
- Set `ANDROID_HOME` to point to your Android SDK installation path
 - e.g. `C:\dev\Android\sdk`
 - e.g. `/Users/foo/dev/Android/sdk`
- Run the Android SDK manager and install the Android API 17/18 tools
- Download any drivers needed to recognize your device (e.g. [Samsung Kies](http://www.samsung.com/us/kies/))
- [Enable USB debugging on your device](http://www.groovypost.com/howto/mobile/how-to-enable-usb-debugging-android-phone/)
- Under `/app`, run `sencha app build -run native` to build the app and install it on your device

### Debugging the app

- Method 1: Run the app locally in the browser
- Method 2: Logcat debugging
    - `console.*` messages in Sencha will flow through to Android's logcat
    - Run `adb logcat | grep -i "Web Console"`
- Method 3: Use [WebKit Inspector Remote (weinre)](http://people.apache.org/~pmuellr/weinre/docs/latest/Home.html)
    - [Install weinre](http://people.apache.org/~pmuellr/weinre/docs/latest/Installing.html): `npm install -g weinre`
    - Determine your dev machine's LAN IP address
        - e.g. `ipconfig /all | findstr 192`
        - e.g. `ifconfig | grep 192`
    - Add the following to `/app/app.json` under the `"js"` node: `{ "path": "http://192.168.xxx.xxx:8080/target/target-script.js", "remote": true }`
    - Add the following to `/app/config.xml`: `<access origin="*" />`
    - Run the debug server on your dev machine: `weinre --boundHost -all-`
    - Rebuild and run the app
    - On your dev machine, navigate to [http://127.0.0.1:8080/client/#anonymous](http://127.0.0.1:8080/client/#anonymous)
        - When the app starts, you should see it appear under `Targets`
        - Click on the app target, it should turn green; start debugging

# Folder structure

- `sencha` - contains Sencha + Phonegap app
- `web` - Rails server code
- `prototype` - Intel XDK based version of the app
- `xdk` - contains Intel XDK + Phonegap app
