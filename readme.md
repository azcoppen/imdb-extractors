# IMDB Extractors

* Author: **Alex Coppen** (azcoppen@protonmail.com)

## Overview

IMDB is the most-cited source of movie information on the net, but is a constant source of frustration for developers because of it's archaic attitude to API access. This repo is a collection of third-party libraries for extracting public data from IMDB for use in applications.

## IMDB Licensing

IMDB provides this notice on their site:


> **Can I use IMDb data in my software?**
>
> Limited non-commercial use of IMDb data is allowed, provided the following conditions are met:
>
>You agree to all the terms of our copyright/conditions of use statement.
Please also note that IMDb reserves the right to withdraw permission to use the data at any time at our discretion.
>
> The data must be taken only from the plain text data made available from our FTP sites (see alternative interfaces for more details and for links to our FTP servers). You may not use data mining, robots, screen scraping, or similar online data gathering and extraction tools on our website. If the information/data you want is not present in the data files available from our FTP sites, it means it's not available for non-commercial usage.
>
>The data can only be used for personal and non-commercial use and must not be altered/republished/resold/repurposed to create any kind of online/offline database of movie information (except for individual personal use). Please refer to the copyright/license information enclosed in each file for further instructions and limitations on allowed usage.
>
>You must acknowledge the source of the data by including the following statement:
>
>Information courtesy of
>IMDb (http://www.imdb.com).
>Used with permission.


## Official Data & API

IMDB provides a reasonably-sized dump of its data as raw text files ("interfaces"), accessible via FTP. These aren't amazingly helpful, as they require parsing.

IMDB also has a private REST API for powering its mobile apps, which uses JSON. However, the warning is quite harsh:

From: http://app.imdb.com/hello?appid=unauth
```json
{
  "@meta": {
    "serverTimeMs": 109,
    "requestId": "0J23XR02DZ3G3RRV71NR"
  },
  "data": {
    "time": 1486342820,
    "status": "ok",
    "api_key": "mbzi7QR0Z+vF8oo0WxIPEA"
  },
  "copyright": "For use only by clients authorized in writing by IMDb.  Authors and users of unauthorized clients accept full legal exposure/liability for their actions."
}
```


#### Official IMDB data dumps

* http://www.imdb.com/interfaces

```bash
wget ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/actresses.list.gz
wget ftp://ftp.funet.fi/pub/mirrors/ftp.imdb.com/pub/actors.list.gz
```

#### Official JSON app API

* http://app.imdb.com/


#### Official Web JS API (JSONP)

Suggestions API:

* http://sg.media-imdb.com/suggests/a/aa.json
* http://sg.media-imdb.com/suggests/h/hello.json
* http://www.imdb.com/xml/find?json=1&nr=1&nm=on&q=jeniffer+garner
* http://www.imdb.com/xml/find?xml=1&nr=1&tt=on&q=lost


## OMDB API

Quite simply the best hack of the IMDB is OMDB, a site providing an open REST API to the data. It is well-maintained, but always suffers from abuse.

> The OMDb API is a free web service to obtain movie information, all content and images on the site are contributed and maintained by our users.

* https://www.omdbapi.com/

Requests are in the format:

```http
http://www.omdbapi.com/?t=V+For+Vendetta&y=2005&plot=short&r=json
```

Example response:

```json
{
   "Title":"The Hangover Part II",
   "Year":"2011",
   "Rated":"R",
   "Released":"26 May 2011",
   "Genre":"Comedy",
   "Director":"Todd Phillips",
   "Writer":"Craig Mazin, Scot Armstrong",
   "Actors":"Bradley Cooper, Zach Galifianakis, Ed Helms, Justin Bartha",
   "Plot":"Right after the bachelor party in Las Vegas, Phil, Stu, Alan, and Doug jet to Thailand for Stu's wedding. Stu's plan for a subdued pre-wedding brunch, however, goes seriously awry.",
   "Poster":"http://ia.media-imdb.com/images/M/MV5BMTM2MTM4MzY2OV5BMl5BanBnXkFtZTcwNjQ3NzI4NA@@._V1_SX320.jpg","
Runtime":"1 hr 42 mins",
   "Rating":"7.1",
   "Votes":"13547",
   "ID":"tt1411697",
   "Response":"True"
}
```

## Screen-Scraping HTML structure

The IMDB is relatively consistent with its HTML presentation, making a DOM search relatively simple. Example HTML from a movie title:

We are looking for `.info h5` and its child div `info-content`.

```html
<div class="info">
    <h5>Contact:</h5>
    <div class="info-content">
        View <a href="/r/contact/rg/title-overview/company-contact/title/tt0434409/companycredits">company</a> contact information for V for Vendetta on
        <a href="/r/contact/rg/title-overview/pro-contact/">IMDbPro</a>.
    </div>
</div>

<div class="info">
    <h5>Release Date:</h5>
    <div class="info-content">
        17 March 2006 (USA)
    </div>
</div>

<div class="info">
    <h5>Genre:</h5>
    <div class="info-content">
        <a href="/Sections/Genres/Action/">Action</a> | <a href="/Sections/Genres/Drama/">Drama</a> | <a href="/Sections/Genres/Thriller/">Thriller</a>
    </div>
</div>

<div class="info">
    <h5>Tagline:</h5>
    <div class="info-content">
        Remember, remember the 5th of November, the gun powder treason and plot. I know of no reason why the gun powder treason should ever be forgot.
    </div>
</div>
```



## Example SQL Schema

Google Code has a project detailing an example structure for IMDB film data:

* https://code.google.com/archive/p/imdbdumpimport/downloads


## ProgrammableWeb/Mashup

There are currently 14 API interfaces available:

* https://www.programmableweb.com/category/all/apis?keyword=imdb

## Node

NPM, as always, is plentiful. 53 packages are currently available:

* https://www.npmjs.com/search?q=imdb
* https://www.npmjs.com/package/imdb-api
