/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Tracks {
	public var href : String?
	public var items : Array<Items>?
	public var limit : Int?
	public var next : String?
	public var offset : Int?
	public var previous : String?
	public var total : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let tracks_list = Tracks.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Tracks Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Tracks]
    {
        var models:[Tracks] = []
        for item in array
        {
            models.append(Tracks(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let tracks = Tracks(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Tracks Instance.
*/
	required public init?(dictionary: NSDictionary) {

		href = dictionary["href"] as? String
        if (dictionary["items"] != nil) { items = Items.modelsFromDictionaryArray(array: dictionary["items"] as! NSArray) }
		limit = dictionary["limit"] as? Int
		next = dictionary["next"] as? String
		offset = dictionary["offset"] as? Int
		previous = dictionary["previous"] as? String
		total = dictionary["total"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.limit, forKey: "limit")
		dictionary.setValue(self.next, forKey: "next")
		dictionary.setValue(self.offset, forKey: "offset")
		dictionary.setValue(self.previous, forKey: "previous")
		dictionary.setValue(self.total, forKey: "total")

		return dictionary
	}

}
