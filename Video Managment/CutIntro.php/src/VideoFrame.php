<?php
declare(strict_types = 1);

namespace CutIntro;

use Exception;
use Technodelight\ShellExec\Command;
use Technodelight\ShellExec\Exec;

class VideoFrame {

    private VideoFile $video;
    private string $framenumber;
    public function __construct($video,$framenumber)
    {
        $this->video = $video;
        $this->framenumber = $framenumber;
    }

    public function getFrameNumber() {
        return $this->framenumber;
    }

    public function getPath() {
        return $this->video->getCachePath() ."/". $this->framenumber .".jpg";
    }
    public function compare(VideoFrame $otherFrame) {
        // compare -metric AE -fuzz 5% $path1 $path2 NULL:
        // output (diff pixels): 2.0736e+06
        $shell = new Exec('compare');
        $output = $shell->exec(
            Command::create()
                ->withArgument('-metric AE')
                ->withArgument('-fuzz 5%')
                ->withArgument('"'.$this->getPath().'"')
                ->withArgument('"'.$otherFrame->getPath().'"')
                ->withArgument('NULL:')
                ->withStdErrToStdOut()
                ->withStdOutTo('/dev/null') // command will be assembled as 'which php 2>'
        );
        $response = 0;
        if(count($output) == 0) {
            $response = 0;
        } else {
            if(is_int($output[0])) {
                $response = $output[0];
            } else {
                $response = PHP_INT_MAX;
            }
        }
        if($response < 100) {
            return true;
        }
        return false;
    }
}

