/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Track {
	public var album : Album?
	public var artists : Array<Artists>?
	public var available_markets : Array<String>?
	public var disc_number : Int?
	public var duration_ms : Int?
	public var episode : Bool?
	public var explicit : Bool?
	public var external_ids : External_ids?
	public var external_urls : External_urls?
	public var href : String?
	public var id : String?
	public var is_local : Bool?
	public var name : String?
	public var popularity : Int?
	public var preview_url : String?
	public var track : Bool?
	public var track_number : Int?
	public var type : String?
	public var uri : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let track_list = Track.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Track Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Track]
    {
        var models:[Track] = []
        for item in array
        {
            models.append(Track(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let track = Track(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Track Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["album"] != nil) { album = Album(dictionary: dictionary["album"] as! NSDictionary) }
        if (dictionary["artists"] != nil) { artists = Artists.modelsFromDictionaryArray(array: dictionary["artists"] as! NSArray) }
        //if (dictionary["available_markets"] != nil) { available_markets = available_markets.modelsFromDictionaryArray(dictionary["available_markets"] as! NSArray) }
		disc_number = dictionary["disc_number"] as? Int
		duration_ms = dictionary["duration_ms"] as? Int
		episode = dictionary["episode"] as? Bool
		explicit = dictionary["explicit"] as? Bool
		if (dictionary["external_ids"] != nil) { external_ids = External_ids(dictionary: dictionary["external_ids"] as! NSDictionary) }
		if (dictionary["external_urls"] != nil) { external_urls = External_urls(dictionary: dictionary["external_urls"] as! NSDictionary) }
		href = dictionary["href"] as? String
		id = dictionary["id"] as? String
		is_local = dictionary["is_local"] as? Bool
		name = dictionary["name"] as? String
		popularity = dictionary["popularity"] as? Int
		preview_url = dictionary["preview_url"] as? String
		track = dictionary["track"] as? Bool
		track_number = dictionary["track_number"] as? Int
		type = dictionary["type"] as? String
		uri = dictionary["uri"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.album?.dictionaryRepresentation(), forKey: "album")
		dictionary.setValue(self.disc_number, forKey: "disc_number")
		dictionary.setValue(self.duration_ms, forKey: "duration_ms")
		dictionary.setValue(self.episode, forKey: "episode")
		dictionary.setValue(self.explicit, forKey: "explicit")
		dictionary.setValue(self.external_ids?.dictionaryRepresentation(), forKey: "external_ids")
		dictionary.setValue(self.external_urls?.dictionaryRepresentation(), forKey: "external_urls")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.is_local, forKey: "is_local")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.popularity, forKey: "popularity")
		dictionary.setValue(self.preview_url, forKey: "preview_url")
		dictionary.setValue(self.track, forKey: "track")
		dictionary.setValue(self.track_number, forKey: "track_number")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.uri, forKey: "uri")

		return dictionary
	}

}
