# Reddit Reader

This is a Reddit Top posts Reader app. 

![Version](https://img.shields.io/badge/Version-5.0-informational?logo=swift) ![Version](https://img.shields.io/badge/Deployment%20Target-12.4-informational)
![](https://img.shields.io/badge/Tests%20Coverage-81.1%25-brightgreen)

## Objective

The intention of the exercise is to show the architecture of a very simple app.
It has a API call that will return the 50 top posts (`https://www.reddit.com/top/.json?count=50`) and will have a read indicator showing if it was opened or not.

It will also save the last status of the data, allowing the user to delete posts with a swipe gesture.

New data will be merged with existing data.

From the detail screen it will allow the user to save the image to the photo library.

It is not using any kind of library and is made 100% in Swift.

## Architecture


It has the following folder structure:

Folder | Description
--- | ---
*BusinessLogic* | It holds the files that will have the logic of the app. How to handle data:`PostsHandler`, the data for the app: `ApplicationData`, how to save data to the local file system: `Storable`, and how to show messages to the user: `Alertable`.
*Models* | The only two models are the `Post` and `LocalDatabase` structs that describe the entity that the application is handling and the database of the app.
*Services* | The `PostsService` class is responsible to use the `HTTPClient` class to get data from reddit's http service.
*Views* | There is the layout of the `PostTableViewCell` that is configured with a `Post` model.
*ViewControllers* | It uses the default implementation of a master detail app, compatible with iPhone and iPad layout. The `MasterViewController` handles the operations of the user with the posts and the `DetailViewController` shows the selected post and allows the user to save the image to the photo library.


## Unit tests

The objective of the unit tests is to assure that the business logic that each element has are documented and will allow to check wether the new changes have impacted them or not.

The tests assure that:
* `HTTPClient` class handles requests and errors properly.
* `PostsService` class gets Posts from the http client and handles errors properly.
* `PostsHandler` protocol provides an API to the implementer to do actions with the Post and notifies when those operations are completed properly. It also tests the different scenarios that the database would have after doing operations with the posts.
* `ApplicationData` is initialized properly and handles different scenarios with the posts.
* `PostTableViewCell` shows the data according to the Post read situation.
* Both view controllers `MasterViewController` and `DetailViewController` shows data properly.

## Author

[Javier Loucim](mailto:javier.loucim@gmail.com)

You can find my applications portfolio at [https://loucim.com](http://loucim.com)

## License

This project is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
