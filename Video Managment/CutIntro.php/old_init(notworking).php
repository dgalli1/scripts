<?php

function how_long($file1,$file2, $offset1,$offset2) {
    for ($i=$offset1; $i < count($file1); $i++) {
        $file2_postion = $i - $offset1 + $offset2;
        if($file1[$i] !== $file2[$file2_postion]) {
            return ['from' => $offset1, 'till' => $i, 'distance' => $i - $offset1];
            break;
        }
    }
}

$directory = $argv[1];



if(!is_dir($directory)) {
    die("Path has to be a directory");
}
$min_same_frames = 10 * 30; // 10 seconds all 30 fps
$valid_extensions = ['mp4', 'mkv', 'ts'];
$bad_words = ['ending', 'opening'];
$dh = opendir($directory);
if(!$dh) {
    die("directory, could not be opend check permissions");
}
$md5maps = [];
//generate md5hashes for every file & frame
$cache_filename = md5($directory).'.cache';
if(!file_exists($cache_filename)) {
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
        $output = shell_exec('ffmpeg -i "'.$path.'" -f framemd5 - 2>/dev/null| grep "^[^#;]" | awk \'{ print $6 }\'');
        $md5s = explode("\n",$output);
        $md5maps[$file] = $md5s;
    }
    $tosave = serialize($md5maps);
    file_put_contents($cache_filename,$tosave);
} else {
    $file_content = file_get_contents($cache_filename);
    $md5maps = unserialize($file_content);
}

$cut_hashes = [];
//now we search for the same md5 hashes in multiple files (please work ffs)
foreach ($md5maps as $file1_key => $file1_md5s) {
    foreach ($md5maps as $file2_key => $file2_md5s) {
        if($file1_key === $file2_key) {
            continue;
        }
        foreach ($file1_md5s as $frame1 => $frame1_md5) {
            foreach ($file2_md5s as $frame2 => $frame2_md5) {
                if($frame1_md5 === $frame2_md5) {
                    //not sure if we found something yet it could still be a fail (ex black frame)
                    var_dump($frame1);
                    var_dump($frame2);
                    $stats = how_long($file1_md5s,$file2_md5s,$frame1,$frame2);
                    if($stats['distance'] > $min_same_frames) {
                        var_dump($stats);
                        echo "found";
                        die();
                    }
                }
            }
            
        }
        echo "nothing found";
        die();
        
    }
    
}

