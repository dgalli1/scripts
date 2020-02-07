<?php
require_once 'vendor/autoload.php';
use CutIntro\DetectChapters;
use CutIntro\VideoFile;

$cutintrocommands = new Commando\Command();

$cutintrocommands->option()
    ->aka('path')
    ->require()
    ->must(function($path) {
        return is_dir($path);
    })
    ->describedAs('Path to directory');

$cache_dir = __DIR__ .'/cache';

define('CACHE_DIR',$cache_dir);
if(!is_dir($cache_dir)) {
    mkdir($cache_dir);
}
//get all files in directory;
$directory = $cutintrocommands['path'];
$dh = opendir($directory);
$valid_extensions = ['mp4', 'mkv', 'ts'];
$bad_words = ['ending', 'opening'];
$files = [];
while(($file = readdir($dh)) !== false) {
    $path = $directory . $file;
    if(filetype($path) !== 'file') {
        continue;
    }
    foreach ($bad_words as $key => $value) {
        if(stripos($file, $value) !== FALSE) {
            echo "Skipped $file BAD WORD\n";
            continue 2;
        }
    }
    $filesplit = explode('.',$file);
    $extension = $filesplit[count($filesplit)-1];
    if(!in_array($extension,$valid_extensions)) {
        echo "Skipped $file Extension is not whitelisted\n";
        continue;
    }
    $files[] = new VideoFile($path);
    // $output = shell_exec('ffmpeg -i "'.$path.'" -f framemd5 - 2>/dev/null| grep "^[^#;]" | awk \'{ print $6 }\'');
}

//lets find the intro we compare the first with the 3 episode to prevent previews and similar stuff hitting

$detect_chapters = new DetectChapters($files[0], $files[2]);
$detect_chapters->DetectChapters();
