/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Album {
	public var album_type : String?
	public var artists : Array<Artists>?
	public var available_markets : Array<String>?
	public var external_urls : External_urls?
	public var href : String?
	public var id : String?
	public var images : Array<Images>?
	public var name : String?
	public var release_date : String?
	public var release_date_precision : String?
	public var type : String?
	public var uri : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let album_list = Album.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Album Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Album]
    {
        var models:[Album] = []
        for item in array
        {
            models.append(Album(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let album = Album(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Album Instance.
*/
	required public init?(dictionary: NSDictionary) {

		album_type = dictionary["album_type"] as? String
        if (dictionary["artists"] != nil) { artists = Artists.modelsFromDictionaryArray(array: dictionary["artists"] as! NSArray) }
       // if (dictionary["available_markets"] != nil) { available_markets = available_markets.modelsFromDictionaryArray(dictionary["available_markets"] as! NSArray) }
		if (dictionary["external_urls"] != nil) { external_urls = External_urls(dictionary: dictionary["external_urls"] as! NSDictionary) }
		href = dictionary["href"] as? String
		id = dictionary["id"] as? String
        if (dictionary["images"] != nil) { images = Images.modelsFromDictionaryArray(array: dictionary["images"] as! NSArray) }
		name = dictionary["name"] as? String
		release_date = dictionary["release_date"] as? String
		release_date_precision = dictionary["release_date_precision"] as? String
		type = dictionary["type"] as? String
		uri = dictionary["uri"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.album_type, forKey: "album_type")
		dictionary.setValue(self.external_urls?.dictionaryRepresentation(), forKey: "external_urls")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.release_date, forKey: "release_date")
		dictionary.setValue(self.release_date_precision, forKey: "release_date_precision")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.uri, forKey: "uri")

		return dictionary
	}

}
