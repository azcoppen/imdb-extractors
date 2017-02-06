<?php
/*
IMDbRipper v.0.1

Copyright 2013 Peter Morgan <petermrg@ymail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

class IMDbRipper {

    private $cache = false;
    private $cacheType = 'file';
    private $cacheDir = '/tmp/';
    private $imdbURL = 'http://www.imdb.com';
    const   version = '1';

    public function __construct($options = []) {

        $this->cache = isset($options['cache']) && ($options['cache'] == true);

        if ($this->cache && ($this->cacheType == 'file')) {
            if (isset($options['cache_dir'])) $this->cacheDir = $options['cache_dir'];
            if (substr($this->cacheDir, -1) != DIRECTORY_SEPARATOR) {
                $this->cacheDir.= DIRECTORY_SEPARATOR;
            }
            if (!is_writable ($this->cacheDir)) {
                $this->cache = false;
                trigger_error("Cache disabled. ".
                    "Directory '{$this->cacheDir}' doesn't exists or isn't writable");
            }
        }
        else {
            $this->cache == false;
        }

    }

    private function loadHTML($url) {
        if ($this->cache == true) {
            $fn = $this->cacheDir.'imdbripper-'.md5($url);
            if (file_exists($fn)) $html = file_get_contents($fn);
            else {
                $html = file_get_contents($url);
                if ($html) file_put_contents($fn, $html);
            }
        }
        else  {
            $html = file_get_contents($url);
        }
        if (!$html) return false;
        $doc = new DOMDocument();
        @$doc->loadHTML($html);
        $xpath = new DOMXpath($doc);
        return $xpath;
    }

    private function getAttr($item, $name) {
        $attributes = $item->attributes;
        foreach ($attributes as $attr) {
            if ($attr->name == $name) {
                $value = trim($attr->nodeValue);
                if ($name == 'href') $value = preg_replace('/\?.*/', '', $value);
                return $value;
            }
        }
        return '';
    }

    private function getLinks($items) {
        $data = array();
        foreach ($items as $item) {
            $data[] = array(
                'name' => trim($item->nodeValue),
                'code' => $this->getCode($this->getAttr($item, 'href'))
            );
        }
        return $data;
    }

    private function getValues($items) {
        $data = [];
        foreach ($items as $item) {
            $data[] = trim($item->nodeValue);
        }
        return $data;
    }

    private function getValue($item) {
        return trim($item->item(0)->nodeValue);
    }

    private function getTable($xpath, $tr, $fields) {
        $items = $xpath->query($tr);
        $rows = [];
        foreach ($items as $i => $item) {
            $row = array();
            foreach ($fields as $name => $func) {
                $row[$name] = $func($xpath, $tr, $i+1);
                if ($row[$name] === false) continue(2);
            }
            $rows[] = $row;
        }
        return $rows;
    }

    private function fullImage($url) {
        return preg_replace('/_S.*_\./', '', $url);
    }

    public function main($code) {
        $url = $this->imdbURL.'/title/tt'.$code.'/';
        $xpath = $this->loadHTML($url);
        if (!$xpath) return false;
        $data = array();

        $data['title'] = $this->getValue($xpath->query('//*[@id="overview-top"]/h1/span[@itemprop="name"]'));
        $data['image'] = $this->fullImage($this->getAttr(
            $xpath->query('//*[@id="img_primary"]/div/a/img')->item(0), 'src'));
        $data['content_rating'] = $this->getValue($xpath->query('//*[@id="titleStoryLine"]/div/span[@itemprop="contentRating"]'));
        $data['original_title'] = $this->getValue($xpath->query('//*[@id="overview-top"]/h1/span[@class="title-extra"]/text()'));
        $data['country'] = $this->getValues($xpath->query('//*[@id="titleDetails"]//h4[starts-with(text(), "Country")]/../a'));
        $data['year'] = $this->getValue($xpath->query('//*[@id="overview-top"]/h1/span[2]/a'));
        $data['description'] = $this->getValue($xpath->query('//*[@id="overview-top"]/p[@itemprop="description"]'));
        $data['duration'] = $this->getValue($xpath->query('//*[@id="overview-top"]//*[@itemprop="duration"]'));
        $data['score'] = $this->getValue($xpath->query('//*[@id="overview-top"]//*[@itemprop="ratingValue"]'));
        $data['directors'] = $this->getLinks($xpath->query('//*[@id="overview-top"]//*[@itemprop="director"]/a'));
        $data['writers'] = $this->getLinks($xpath->query('//*[@id="overview-top"]//h4[starts-with(text(), "Writer")]/../a'));
        $data['stars'] = $this->getLinks($xpath->query('//*[@id="overview-top"]//*[@itemprop="actors"]/a'));
        $data['genres'] = $this->getValues($xpath->query('//*[@id="titleStoryLine"]//h4[starts-with(text(), "Genre")]/../a'));
        $data['cast'] = $this->getTable($xpath, '//*[@id="titleCast"]/table/tr', array(
            'name' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[2]/a');
                return ($item->length == 0) ? false : $this->getValue($item);
            },
            'code' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[2]/a');
                return $this->getCode($this->getAttr($item->item(0), 'href'));
            },
            'image' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[1]/a/img');
                return ($item->length == 0) ? false : $this->fullImage(
                    $this->getAttr($item->item(0), 'loadlate')
                );
            }
        ));

        return $data;
    }

    public function keywords($code) {
        $url = $this->imdbURL.'/title/tt'.$code.'/keywords';
        $xpath = $this->loadHTML($url);
        if (!$xpath) return false;
        $data = [];
        // $data['keywords'] = $this->getValues($xpath->query('//*[@id="tn15content"]/ul/li/b/a'));
        return $data;
    }

    public function getCode($str) {
        preg_match('/.*(name\/nm|title\/tt)(0*)(\d+).*/', $str, $code);
        return isset($code[3]) ? $code[3]|0 : false;
    }

    public function fullCredits($code) {
        $url = $this->imdbURL.'/title/tt'.$code.'/fullcredits';
        $xpath = $this->loadHTML($url);
        if (!$xpath) return false;
        $data = [];

        $data['cast'] = $this->getTable($xpath, '//div/table[@class="cast"]/tr', array(
            'name' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[2]/a');
                return ($item->length == 0) ? false : $this->getValue($item);
            },
            'code' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[2]/a');
                return $this->getCode($this->getAttr($item->item(0), 'href'));
            },
            'character' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[4]');
                return $this->getValue($item);
            },
            'image' => function($xpath, $tr, $n) {
                $item = $xpath->query($tr.'['.$n.']/td[1]/a/img');
                return ($item->length == 0) ? false : $this->fullImage(
                    $this->getAttr($item->item(0), 'src')
                );
            }
        ));

        $h5s = $xpath->query('//table/tr/td//h5/a');
        foreach ($h5s as $h5) {
            $name = $this->getAttr($h5, 'name');
            $data[$name] = $this->getTable($xpath, '//h5/a[@name="'.$name.'"]/ancestor::table[1]//tr', array(
                'name' => function($xpath, $tr, $n) {
                    $item = $xpath->query("{$tr}[$n]/td[1]/a");
                    return ($item->length == 0) ? false : $this->getValue($item);
                },
                'code' => function($xpath, $tr, $n) {
                    $item = $xpath->query("{$tr}[$n]/td[1]/a");
                    return $this->getCode($this->getAttr($item->item(0), 'href'));
                },
                'desc' => function($xpath, $tr, $n) {
                    $item = $xpath->query("{$tr}[$n]/td[3]");
                    return ($item->length == 0) ? false : $this->getValue($item);
                }
            ));
        }
        return $data;
    }

}

