/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Items {
	public var added_at : String?
	public var added_by : Added_by?
	public var is_local : Bool?
	public var primary_color : String?
	public var track : Track?
	public var video_thumbnail : Video_thumbnail?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let items_list = Items.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Items Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Items]
    {
        var models:[Items] = []
        for item in array
        {
            models.append(Items(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let items = Items(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Items Instance.
*/
	required public init?(dictionary: NSDictionary) {

		added_at = dictionary["added_at"] as? String
		if (dictionary["added_by"] != nil) { added_by = Added_by(dictionary: dictionary["added_by"] as! NSDictionary) }
		is_local = dictionary["is_local"] as? Bool
		primary_color = dictionary["primary_color"] as? String
		if (dictionary["track"] != nil) { track = Track(dictionary: dictionary["track"] as! NSDictionary) }
		if (dictionary["video_thumbnail"] != nil) { video_thumbnail = Video_thumbnail(dictionary: dictionary["video_thumbnail"] as! NSDictionary) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.added_at, forKey: "added_at")
		dictionary.setValue(self.added_by?.dictionaryRepresentation(), forKey: "added_by")
		dictionary.setValue(self.is_local, forKey: "is_local")
		dictionary.setValue(self.primary_color, forKey: "primary_color")
		dictionary.setValue(self.track?.dictionaryRepresentation(), forKey: "track")
		dictionary.setValue(self.video_thumbnail?.dictionaryRepresentation(), forKey: "video_thumbnail")

		return dictionary
	}

}