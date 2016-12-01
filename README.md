# GESolution
Solution to test: https://github.com/goeuro/iOS-test

This is an application that represents solution to GoEuro test. App consist one screen, containing 3 travel modes:Train, Buses and Flights. 
The view has 3 tabs, each representing one of the three travel options. The cells are maintained inside the Storyboard with autolayout. The list is clear and readable for the user and display the following:

logo
departure time
arrival time
number of changes
price
duration


To get the lists, I'm using the 3 handy APIs provided by GoEuro.

If there is no data available in the returned json file, or if there is no internet connection, then I show the last online information, loaded from DB. 

Not used third party libraries.

Swift is the main language.

I think this is a clean, well-animated, and beautiful UI. You can download it and see how it works!
