# Batch replace the audio of video files in the current folder
function video-replace-audio($video_extension = "mp4", $audio_extension = "mp3") {
    # This uses ffmpeg https://www.ffmpeg.org/
    # modify the video and audio extensions if needed

    mkdir -p output_videos/

    foreach ($video in (ls *.$video_extension)) {
        $video_name = ($video).Name;
        $audio_name = $video_name.replace($video_extension, $audio_extension);
    
        ffmpeg -i $video_name -i $audio_name -c copy -map 0:v:0 -map 1:a:0 -shortest "output_videos/$video_name"
        # the above is based on https://superuser.com/a/1137613/1006010
        # If the audio is longer than the video, you will want to add -shortest before the output file name.

        # Using -c:v copy instead of -c copy means to copy the video only, and re-encoding the audio. -c copy will copy both the video and audio without re-encoding.
        # -map 0:v:0 maps the first (index 0) video stream from the input to the first (index 0) video stream in the output.
        # -map 1:a:0 maps the second (index 1) audio stream from the input to the first (index 0) audio stream in the output.
        # Not specifying an audio codec, will automatically select a working one. You can specify one by for example adding -c:a libvorbis after -c:v copy. You can also use -c copy to avoid re-encoding the audio, but this has lead to compatibility and synchronization problems in my past.
    }
}

# Batch extract the audio of video files in the current folder
function video-extract-audio($video_extension = "mp4", $audio_extension = "mp3") {
    # This uses ffmpeg https://www.ffmpeg.org/
    # modify the video and audio extensions if needed

    mkdir -p output_audios/

    foreach ($video in (ls *.$video_extension)) {
        $video_name = ($video).Name;
        $audio_name = $video_name.replace($video_extension, $audio_extension);
    
        ffmpeg -i $video_name -vn -acodec copy "output_audios/$audio_name"
        # https://stackoverflow.com/a/27413824/7910299
        # -vn is no video.
        # -acodec copy says use the same audio stream that's already in there.
    }
}