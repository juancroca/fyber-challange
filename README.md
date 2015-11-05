The app was built central to the info from __fyber api__.

The library built to access the api can be found in `lib\fyber\client` it contains two methods :

* __initialize__: which is the method to create a new instance of __Fyber::Client__ it expects a valid __api_key__. This method would raise and error when an invalid key is entered.
* __get_offers__: will return an array of offers. If non is found would return and empty array. If there is any errors due to missing attributes it would return __nil__ and the errors would be accessible in the __Fyber::Client__ instance with the __errors__ attribute.
ej:
```ruby
Fyber::Client.new("api_key")
client.errors
```

To display the information returned by the library a rails app was built. The app consist of the offers controller which only implements the index action. A __GET__ to index would load the form to input the different params for the query. By submitting the form an ajax __POST__ request would be triggered. This would call the __get_offers__ method from the library.
* If empty results are returned a no offers found text would be displayed
* If the a missing uid attribute or any other error would display and error text.
* If offers are found then they would be displayed.
