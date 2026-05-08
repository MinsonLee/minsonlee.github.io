譬如：`https://www.youtube.com/playlist?list=PLqMIoUyLRyD8qEqImRlh-mUqd8n9jjYu1` 结合 `y2mate.com` 下载

```js
var all = document.querySelectorAll('a[id^="video-title"]');
for (var i = 0; i < all.length; i++) {
    console.log("- [" + all[i].getAttribute('title') + "](https://www.youtubepp.com" + all[i].getAttribute('href') + ")");
}
```

```sh
ls y2* | sed -e "s/y2mate.com - \(.*[0-9]\+.*\)_1080p.mp4/ mv '\0' '0\1.mp4'/g" | bash
```




