<?php

require_once('imdb-ripper.php');

$options = [
    'cache' => true,
    'cache_type' => 'file',
    'cache_dir' => '/tmp/'
];

$imdbRipper = new IMDBRipper($options);

// Get info from The Matrix
print_r($imdbRipper->main(133093));

