<?php
namespace CutIntro;
use Technodelight\ShellExec\Command;
use Technodelight\ShellExec\Exec;

class VideoFile {

    private string $path;
    private string $cache_path;
    private array  $frames;
    public function __construct($path)
    {
        $this->path = $path;
 
        $this->cache_path =CACHE_DIR.'/'. md5($path);
        if(!is_dir($this->cache_path)) {
            mkdir($this->cache_path);
        } else {
            $this->getFramesFromFolder();
        }

    }

    public function getCachePath() {
        return $this->cache_path;
    }

    public function getFrames()  {
        return $this->frames;
    }

    private function getFramesFromFolder() {
        $files = scandir($this->cache_path);
        foreach ($files as $file) {
            $filesplit = explode('.',$file);
       
            $extension = $filesplit[count($filesplit)-1];
            if($extension !== 'jpg') {
                continue;
            }
    
            $this->frames[] = new VideoFrame($this,$filesplit[0]);
       
        }
    }
    private function getImageRegexPaths() {
        return $this->cache_path ."/%06d.jpg";
    }

    public function setOffsets($arr) {
        $this->offsets = $arr;
    }

    public function extractToFrames() {
        echo "Extract Frames from: ".$this->path.PHP_EOL;
        $shell = new Exec('ffmpeg');
        
        $output = $shell->exec(
            Command::create()
                ->withArgument('-i "'.$this->path.'" "'.$this->getImageRegexPaths().'" -hide_banner')
                ->withStdErrToStdOut()
                ->withStdOutTo('/dev/null') // command will be assembled as 'which php 2>'
        );
        // ffmpeg -i video.webm thumb%04d.jpg 
        $this->getFramesFromFolder();
    }
}

