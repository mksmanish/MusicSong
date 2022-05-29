# MusicSong

This App is using the developer.spotify API to fetch data and customise into playlist,audio tracks and recommendations of songs.<br> 
1. Consume the spotify APIs feed (converted to JSON) from the following URL:
   https://api.spotify.com/v1 + "required urls"<br> 
2. The playlist contains a series of songs, with titles, subtitles, timestamps, etc, and many extraneous fields. Show these playlists summaries in a list as          depicted in the design.<br>
   a. Each Songs has an image to be shown in the list item.<br>
   b. For playlist , show the thumbnail from the items/thumbnail path. For the large
      top article, show the items/enclosure/link image.<br>
   c. The image should be loaded asynchronously.<br>
   d. Show the title from the items/title field.<br>
   e. Show the date from the items/, formatted as depicted in the design.<br>
3. All the reference of the project with all the APIs are prsent https://developer.spotify.com/documentation/web-api/reference/.<br>
4. Used the SDWebImages the image cache and asyn ways laoding of the images.<br>
5. There is a functionality for search for the particular Artists,Songs etc.<br>   
<br>   
<img src = "https://github.com/mksmanish/MusicSong/blob/master/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20Max%20-%202022-05-29%20at%2015.05.59.png" width="200" height="400" ><br>
<img src = "https://github.com/mksmanish/MusicSong/blob/master/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20Max%20-%202022-05-29%20at%2015.06.19.png" width="200" height="400" ><br>
<br>
