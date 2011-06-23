Ikraigslist iOS application :
=================


This application was first released on the iphone app store on 25 September 2009. 

It was designed for iOS 2/3 and has NOT been updated since as it didn't bring me much revenue. 

I decided to open-source the code of it so that it can be used as an example by others to learn :) 

Please if you fork it or ameliorate it, I ask you not to submit it on the appstore. It's here for learning purpose only. If you ameliorate it, please let me have the changes so that I can push them back on the app store and we might finally have the best (free) craigslist app out there :)

###Update :

Finally I decided to put it free on the app store and I bugfixed it and made it compatible with 4.2. 

Here you can see it on the [app store](http://itunes.apple.com/us/app/ikraigslist/id329671828?mt=8&ls=1).

Anyway it's a nice and complete example to learn, here are some details.

The best way to see the code in order is to open the *ikraigslist.xcodeproj* file.

###Explanations

####First the structure :

+ **Classes** > Contains all the classes (the code!) (more virtual subfolder when you open the project in Xcode)

+ **db** > Contains the bases SQLite files (user data + craigslist categories and countries)

+ **help** > Contains the help of the application (not the help for devs)

+ **pictures** > you guessed it, contains all the pictures

+ **xib** > all the xibs for the user interface

#### Interesting Classes to learn from

+ **Manager** > it's interesting, because it's using a singleton pattern and classes messages to ease the rest of the developpement by centralizing access to the all the viewcontrollers, so you can access any VC from anywhere through the manager

+ **RegionParser** and **SectionParser** and **CraigDetailXMLReader** and **CraigSectionXMLReader** > Realllly interesting if you want to see some hardcore libxml2 usage that I wrote to scrap the craigslist website in any ways.

+ **DataManager** and **AppParams** are usefull if you want to see some SQLite code and a generic way of handling app params, like retaining last values and last view the user was (yes at that time CoreData didn't exist on the iphone so we were to use sqlite..)

+ **ImageGalleryController** if you want to see how to redo an image gallery "à la iphone" by yourself.

Voilà

I have to warn everybody that this was MY FIRST project on the iphone, and my first experience with Objective-C more than 2 years ago, so **IT IS NOT CLEAN**, but it's a complete project that's working

As I said on the top you can reuse some parts of the code if you wish so BUT please don't just resubmit the whole project on the appstore after some minor modification, if you'd like to ameliorate it, please integrate your changes in here and we can resubmit it on the appstore, I WILL mention your name on the app page !! So maybe one day we will have the best (free) craigslist iphone app  :)



