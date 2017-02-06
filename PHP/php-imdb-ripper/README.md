# IMDb Ripper v.0.1 #

Extracts movie information from IMDb website. It's very simple and easy to extend.
Also provides links to fullsize images of the poster and cast.

## Requires ##

PHP5

## Usage ##

```php
require_once('imdb-ripper.php');

$imdbRipper = new IMDBRipper();

// Print The Matrix main details
print_r($imdbRipper->main(133093));

```

The above will return an array like this one:

```
Array
(
    [title] => Matrix
    [image] => http://ia.media-imdb.com/images/M/MV5BMjEzNjg1NTg2NV5BMl5BanBnXkFtZTYwNjY3MzQ5._V1jpg
    [original_title] => The Matrix
    [year] => 1999
    [duration] => 136 min
    [score] => 8.7
    [content_rating] => 18
    [director] => Array
        (
            [0] => Array
                (
                    [name] => Andy Wachowski
                    [href] => /name/nm0905152/
                )

            [1] => Array
                (
                    [name] => Lana Wachowski
                    [href] => /name/nm0905154/
                )

        )

    [writers] => Array
        (
            [0] => Array
                (
                    [name] => Andy Wachowski
                    [href] => /name/nm0905152/
                )

            [1] => Array
                (
                    [name] => Lana Wachowski
                    [href] => /name/nm0905154/
                )

        )

    [stars] => Array
        (
            [0] => Array
                (
                    [name] => Keanu Reeves
                    [href] => /name/nm0000206/
                )

            [1] => Array
                (
                    [name] => Laurence Fishburne
                    [href] => /name/nm0000401/
                )

            [2] => Array
                (
                    [name] => Carrie-Anne Moss
                    [href] => /name/nm0005251/
                )

        )

    [genres] => Array
        (
            [0] => Action
            [1] => Adventure
            [2] => Sci-Fi
        )

    [cast] => Array
        (
            [0] => Array
                (
                    [name] => Keanu Reeves
                    [href] => /name/nm0000206/
                    [image] => http://ia.media-imdb.com/images/M/MV5BNjUxNDcwMTg4Ml5BMl5BanBnXkFtZTcwMjU4NDYyOA@@._V1jpg
                )

            [1] => Array
                (
                    [name] => Laurence Fishburne
                    [href] => /name/nm0000401/
                    [image] => http://ia.media-imdb.com/images/M/MV5BMTc0NjczNDc1MV5BMl5BanBnXkFtZTYwMDU0Mjg1._V1jpg
                )

            [2] => Array
                (
                    [name] => Carrie-Anne Moss
                    [href] => /name/nm0005251/
                    [image] => http://ia.media-imdb.com/images/M/MV5BMTYxMjgwNzEwOF5BMl5BanBnXkFtZTcwNTQ0NzI5Ng@@._V1jpg
                )

            [3] => Array
                (
                    [name] => Hugo Weaving
                    [href] => /name/nm0915989/
                    [image] => http://ia.media-imdb.com/images/M/MV5BMjAxMzAyNDQyMF5BMl5BanBnXkFtZTcwOTM4ODcxMw@@._V1jpg
                )

            ...

        )

)

```

## Public methods: ##

```php
getCode($str); // imdb.com/title/tt0133093/ => 133093

main($code);

keywords($code);

fullCredits($code);
```

It's a work in progress, if you need a new feature, just send an issue.

## To do ##

  * series (chapters)
  * extract movie images
  * more...

Enjoy.
