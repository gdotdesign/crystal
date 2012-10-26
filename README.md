# Crystal [![Build Status](https://secure.travis-ci.org/gdotdesign/crystal.png?branch=master)](http://travis-ci.org/gdotdesign/crystal)

Crystal is a JavaScript library (written in CoffeeScript) which extends native prototypes, and adds utility classes.

### What Crystal gives you?
 *  Basic utilities that you expect from a library (DOM, Request, type extensions)
 *  Things that are not part of other libraries (Color, Unit, i18n, Keyboard, etc...)
 *  [Node-Webkit](https://github.com/rogerwang/node-webkit) utilities (File Dialogs,Tray, etc...)
 *  Properties on Classes / Types (array.first, 1.hours, date.ago, etc...)
 *  Event / PubSub system
 *  MVC / UI
 *  Custom builds*

### What Crystal doesn't give you?
 *  Classes (you should use CoffeeScript for this)
 *  IE support

### Dependencies
 *  ES5 compilant browser
 *  querySelector and querySelectorAll
 *  addEventListener / removeEventListener
 *  Object.definePropert(y|ies)
 *  FormData

## Status
Crystal is current in development and without a release date.     
It's in the phase of accumulating code, and specs.          
The current status can be found in the spreadsheet (implementation, specs, documentation):            
https://docs.google.com/spreadsheet/ccc?key=0ArrerAsh1HlfdGh2Ni1TTGg0LUtZQWZ5YVhxcDkwLVE

## Hacking
### Dependencies
 * Ruby 1.9.2+
 * NodeJS
 * Phantomjs for running specs in terminal / console

### Setup
 * Clone the repository
 * ```bundle install```

### Running specs
There are two ways to run specs:

Terminal (requires phantomjs):

 *  ```rake specs```

Browser:

 *  ```rake specserver```
 *  Open **http://localhost:5000** in your browser

### Examples
 
 *  ```rake specserver```
 *  Open **http://localhost:5000/{example}** in your browser

### Building
Simple compile to **crystal.js**

```rake build > crystal.js```

Compile and uglify to **crystal.js**

```rake build ugly=true > crystal.js```

##Known Bugs

 *  querySelectorAll not returning proper NodeList in Opera
 		http://my.opera.com/community/forums/topic.dml?id=1377232