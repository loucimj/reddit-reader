//
//  PostsMother.swift
//  RedditReaderTests
//
//  Created by Javier Loucim on 24/08/2019.
//  Copyright © 2019 Javier Loucim. All rights reserved.
//

import Foundation

@testable import RedditReader

class PostsMother {
    class func defaultPost() throws -> Post {
        return try JSONDecoder().decode(Post.self, from: Data("""
            {
                "id": "2hqlxp",
                "title": "title",
                "author" : "author",
                "num_comments": 4,
                "created_utc": 1411946514,
                "thumbnail": "http://something"
            }
        """.utf8))
    }
    class func secondPost() throws -> Post {
        return try JSONDecoder().decode(Post.self, from: Data("""
            {
                "id": "2hozly",
                "title": "title",
                "author" : "author",
                "num_comments": 4,
                "created_utc": 1411946514,
                "thumbnail": "http://something"
            }
        """.utf8))
    }
    class func responseMockedData() -> Data {
        return Data("""
            {
                "kind": "Listing",
                "data": {
                    "modhash": "uo8ez9e1lf807810187b428b01e59cd38a9303245aa595d992",
                    "children": [
                        {
                            "kind": "t3",
                            "data": {
                                "domain": "i.imgur.com",
                                "banned_by": null,
                                "media_embed": {},
                                "subreddit": "funny",
                                "selftext_html": null,
                                "selftext": "",
                                "likes": null,
                                "user_reports": [],
                                "secure_media": null,
                                "link_flair_text": null,
                                "id": "2hqlxp",
                                "gilded": 0,
                                "secure_media_embed": {},
                                "clicked": false,
                                "report_reasons": null,
                                "author": "washedupwornout",
                                "media": null,
                                "score": 4841,
                                "approved_by": null,
                                "over_18": false,
                                "hidden": false,
                                "thumbnail": "http://b.thumbs.redditmedia.com/9N1f7UGKM5fPZydrsgbb4_SUyyLW7A27um1VOygY3LM.jpg",
                                "subreddit_id": "t5_2qh33",
                                "edited": false,
                                "link_flair_css_class": null,
                                "author_flair_css_class": null,
                                "downs": 0,
                                "mod_reports": [],
                                "saved": false,
                                "is_self": false,
                                "name": "t3_2hqlxp",
                                "permalink": "/r/funny/comments/2hqlxp/man_trying_to_return_a_dogs_toy_gets_tricked_into/",
                                "stickied": false,
                                "created": 1411975314,
                                "url": "http://i.imgur.com/4CHXnj2.gif",
                                "author_flair_text": null,
                                "title": "Man trying to return a dog's toy gets tricked into playing fetch",
                                "created_utc": 1411946514,
                                "ups": 4841,
                                "num_comments": 958,
                                "visited": false,
                                "num_reports": null,
                                "distinguished": null
                            }
                        },
                        {
                            "kind": "t3",
                            "data": {
                                "domain": "alphagalileo.org",
                                "banned_by": null,
                                "media_embed": {},
                                "subreddit": "science",
                                "selftext_html": null,
                                "selftext": "",
                                "likes": null,
                                "user_reports": [],
                                "secure_media": null,
                                "link_flair_text": "Social Sciences",
                                "id": "2hozly",
                                "gilded": 0,
                                "secure_media_embed": {},
                                "clicked": false,
                                "report_reasons": null,
                                "author": "mubukugrappa",
                                "media": null,
                                "score": 4498,
                                "approved_by": null,
                                "over_18": false,
                                "hidden": false,
                                "thumbnail": "",
                                "subreddit_id": "t5_mouw",
                                "edited": false,
                                "link_flair_css_class": "soc",
                                "author_flair_css_class": null,
                                "downs": 0,
                                "mod_reports": [],
                                "saved": false,
                                "is_self": false,
                                "name": "t3_2hozly",
                                "permalink": "/r/science/comments/2hozly/the_secret_to_raising_well_behaved_teens_maximise/",
                                "stickied": false,
                                "created": 1411937584,
                                "url": "http://www.alphagalileo.org/ViewItem.aspx?ItemId=145707&amp;CultureCode=en",
                                "author_flair_text": null,
                                "title": "The secret to raising well behaved teens? Maximise their sleep: While paediatricians warn sleep deprivation can stack the deck against teenagers, a new study reveals youth’s irritability and laziness aren’t down to attitude problems but lack of sleep",
                                "created_utc": 1411908784,
                                "ups": 4498,
                                "num_comments": 3740,
                                "visited": false,
                                "num_reports": null,
                                "distinguished": null
                            }
                        }
                    ],
                    "after": "t3_2hpw7k",
                    "before": null
                }
            }
        """.utf8)
    }
}
