```sh
[limingshuang@erc-hk-20 ~]$ /usr/bin/curl http://dev.askonyourtrip.com/wp-json/erc-routes/api/task/init_url_code?limit=5555&ac=landmark

<pre>array (
  'limit' => '5555',
)

[limingshuang@erc-hk-20 ~]$ /usr/bin/curl http://dev.askonyourtrip.com/wp-json/erc-routes/api/task/init_url_code?act=landmark\&limit=10000

<pre>array (
  'act' => 'landmark',
  'limit' => '10000',
)
```

- curl网站开发指南：http://www.ruanyifeng.com/blog/2011/09/curl.html


## 待考察点：
- wget 是否也会存在这问题呢？