# BGSession

Just sample app that demonstrates usage of background `URLSession` to download large files while iOS app is not in foreground.

Contains two URLs to files of different size - one has approx. 400 MB, the other approx. 1 GB, feel free to experiment, but with **Network link conditioner** it shouldn't be a problem to simulate any download length.

When app is launched a download task is created to fetch file from given URL. Also local notification is sent, so app asks for permission - you should enable it to see something happening. When download task is scheduled, local notifications is sent with text _Download start!_, when download ends, another nofications is sent with _Download complete!_ text. This way you can track how long the download took.

This just demonstrates a happy scenario when everything goes well, just to check that background sessions work as expected, so no network changes or system settings are handled. 

## Expected scenario

- make sure you don't have any displayed notifications from previous run (for simplicity we use static notification identifier)
- run the app
- if this is first run of the app, you will be asked for notifications permission, allow it
- you should receive notification that download started
- minimize the app, do not kill it in app switcher
- based on your connection, download will take certain amount of time 
    - I suggest using network link conditioner to simulate various download lengths
    - for 5 Mbps connection the download of smaller file takes approx. 11 minutes
- when download completes, you receive another notification
- I suggest deleting those notifications

## Known issues

- has disabled `isDiscretionary` property of `URLSessionConfiguration` as for testing/debug purposes it is useful to start download immediately regardless of battery, connection and other influences
- background session is not running if user explicitly closes app from app switcher, that's just standard behavior that cannot be altered
