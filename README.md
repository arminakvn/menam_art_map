## setup
> You need Nodejs and [npm](https://www.npmjs.com/) for package management.    
You can install npm using [Homebrew](http://brew.sh/) by running in your terminal:

```brew install npm```.   
### fork

> First, fork the repository to your Github account. You can do this by clicking on __Fork__ on the project's Github page.       



### clone
> Clone the repository in your local machine.   

``` git clone <your-github-repository>```


> Point into the project folder in terminal.   



```cd menam_art_map```


> Install the project dependencies with npm.   


```
npm install
```   
> Install bower for front-end packages.   



```
npm install -g bower
bower install
```   
> Install [GRUNT](http://gruntjs.com/) for running tasks.   

```
npm install -g grunt grunt-cli
```   

### develop
> For development run   

```
grunt
```   

> Build with   

```
grunt build
```   

## note
this project is built with [Yeoman Generator Marrionette-Coffee](https://www.npmjs.com/package/generator-marionette-coffee). 
for development set up the project and work on app/assets/coffee folder. if prefer to develop with JS instead of Coffee edit the Grunt file, remove the task: coffee from default/dev and work on app/assets/js folder.
