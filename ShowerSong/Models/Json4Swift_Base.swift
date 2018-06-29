/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Json4Swift_Base {
	public var collaborative : Bool?
	public var description : String?
	public var external_urls : External_urls?
	public var followers : Followers?
	public var href : String?
	public var id : String?
	public var images : Array<Images>?
	public var name : String?
	public var owner : Owner?
	public var primary_color : String?
	//public var public : Bool?
	public var snapshot_id : String?
	public var tracks : Tracks?
	public var type : String?
	public var uri : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Json4Swift_Base]
    {
        var models:[Json4Swift_Base] = []
        for item in array
        {
            models.append(Json4Swift_Base(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		collaborative = dictionary["collaborative"] as? Bool
		description = dictionary["description"] as? String
		if (dictionary["external_urls"] != nil) { external_urls = External_urls(dictionary: dictionary["external_urls"] as! NSDictionary) }
		if (dictionary["followers"] != nil) { followers = Followers(dictionary: dictionary["followers"] as! NSDictionary) }
		href = dictionary["href"] as? String
		id = dictionary["id"] as? String
        if (dictionary["images"] != nil) { images = Images.modelsFromDictionaryArray(array: dictionary["images"] as! NSArray) }
		name = dictionary["name"] as? String
		if (dictionary["owner"] != nil) { owner = Owner(dictionary: dictionary["owner"] as! NSDictionary) }
		primary_color = dictionary["primary_color"] as? String
		//public = dictionary["public"] as? Bool
		snapshot_id = dictionary["snapshot_id"] as? String
		if (dictionary["tracks"] != nil) { tracks = Tracks(dictionary: dictionary["tracks"] as! NSDictionary) }
		type = dictionary["type"] as? String
		uri = dictionary["uri"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.collaborative, forKey: "collaborative")
		dictionary.setValue(self.description, forKey: "description")
		dictionary.setValue(self.external_urls?.dictionaryRepresentation(), forKey: "external_urls")
		dictionary.setValue(self.followers?.dictionaryRepresentation(), forKey: "followers")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.name, forKey: "name")
		dictionary.setValue(self.owner?.dictionaryRepresentation(), forKey: "owner")
		dictionary.setValue(self.primary_color, forKey: "primary_color")
		//dictionary.setValue(self.public, forKey: "public")
		dictionary.setValue(self.snapshot_id, forKey: "snapshot_id")
		dictionary.setValue(self.tracks?.dictionaryRepresentation(), forKey: "tracks")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(self.uri, forKey: "uri")

		return dictionary
	}

}
