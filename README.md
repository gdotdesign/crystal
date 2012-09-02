# Crystal [![Build Status](https://secure.travis-ci.org/gdotdesign/crystal.png?branch=master)](http://travis-ci.org/gdotdesign/crystal)

Crystal is a JavaScript library (written in CoffeeScript) which extends native prototypes, and adds utility classes.

The basic principle is to not to try to fix old browsers, but to add utility to modern browsers, with that in mind
Crystal expects the following:
 *  ES5 compilance
 *  querySelector and querySelectorAll
 *  addEventListener
 *  Object.definePropert(y|ies)

## Hacking
### Dependencies
 * Ruby 1.9.2+
 * NodeJS
 * Phantomjs for running specs in terminal / console

### Setup
 * Clone the repository
 * bundle install

### Running specs
There are two ways to run specs:

Terminal (requires phantomjs):
 *  ```rake specs```

Browser:
 *  ```rake specserver```
 *  Open **http://localhost:5000** in your browser

### Building
Simple compile to **crystal.js**       
```rake build > crystal.js```

Compile and uglify to **crystal.js**          
```rake build ugly=true > crystal.js```

##Known Bugs

 *  querySelectorAll not returning proper NodeList in Opera     
 		http://my.opera.com/community/forums/topic.dml?id=1377232