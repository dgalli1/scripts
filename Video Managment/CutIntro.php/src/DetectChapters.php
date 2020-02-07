<?php
namespace CutIntro;
use CutIntro\VideoFile;

class DetectChapters {
    private VideoFile $videofile1;
    private VideoFile $videofile2;
    private int $maxFrameDiffernce = 30*60*5;
    private int $minsmilirtyLength = 30*10; 
    public function __construct($videofile1, $videofile2)
    {
        $this->videofile1 = $videofile1;
        $this->videofile2 = $videofile2;
    }

    public function DetectChapters() {
        // $this->videofile1->extractToFrames();
        // $this->videofile2->extractToFrames();
        //rewrite so we skip already compared sections after a match
        foreach ( $this->videofile1->getFrames() as $frame1) {

            /** @var VideoFrame $frame1 */
            echo $frame1->getFrameNumber() .PHP_EOL;
            foreach ($this->videofile2->getFrames() as $key => $frame2) {
                /** @var VideoFrame $frame2 */
                $response = $frame1->compare($frame2);
                if($response) {
                   //possible match check for following frames
                    if($this->isSimilartyLongEnough($frame1,$frame2)) {
                        echo "it freaking works";
                        die();
                    }
                    continue 2;
                }
            }
        }
    }

    public function isSimilartyLongEnough(VideoFrame $frame1, VideoFrame $frame2) {
        $is_smiliar = true;
        for ($i=0; $i < $this->minsmilirtyLength; $i++) { 
            $frame_comp1 = $this->videofile1->getFrames()[$i +$frame1->getFrameNumber()];
            /** @var VideoFrame $frame_comp1 */
            $frame_comp2 = $this->videofile2->getFrames()[$i + $frame2->getFrameNumber()];
            /** @var VideoFrame $frame_comp2 */
            if(!$frame_comp1->compare($frame_comp2)) {
                $is_smiliar = false;
                break;
            }
        }
        return $is_smiliar;
    } 


}

