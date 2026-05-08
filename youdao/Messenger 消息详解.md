关注-点击 Get Started：
```json
{
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568726705112,
      "messaging": [
        {
          "postback": {
            "payload": "WELCOME_MESSAGE",
            "title": "Get Started"
          },
          "sender": {
            "id": "2358598834233528"
          },
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568726704757
        }
      ]
    }
  ],
  "object": "page"
}
```

系统快捷回复：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568726767880,
      "messaging": [
        {
          "sender": {
            "id": "2358598834233528"
          },
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568726767560,
          "message": {
            "mid": "OMfyNroP6-vztE7kMow2NuCsiamKQfe6u6PafrkNoImD69HWU0EHMpJL3wv2igVDUfQ667Q5QZDDa2hJhWXWqw",
            "text": "🚙 Latest discount",
            "quick_reply": {
              "payload": "latest-discount-app-coupon"
            }
          }
        }
      ]
    }
  ]
}
```

系统直接回复消息：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568726604816,
      "messaging": [
        {
          "sender": {
            "id": "2358598834233528"
          },
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568726604462,
          "message": {
            "mid": "BNWQ6yG4zGWGwxppQ2PBKeCsiamKQfe6u6PafrkNoIkA94rG_zvkzAB6XIfcDof0jbPVBNiiixo4u9KC5cuI1g",
            "text": "hi"
          }
        }
      ]
    }
  ]
}
```

m.me 短链：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568726824296,
      "messaging": [
        {
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568726824296,
          "sender": {
            "id": "2358598834233528"
          },
          "referral": {
            "ref": "m-loggedin-6off",
            "source": "SHORTLINK",
            "type": "OPEN_THREAD"
          }
        }
      ]
    }
  ]
}
```


复选框：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568727003055,
      "messaging": [
        {
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568727003055,
          "optin": {
            "ref": "ref=m-airasia/user_ref=user-k0nvj5lf34/user_encode=f1a8a2eb06af69d696805d60b46924d2",
            "user_ref": "user-k0nvj5lf34"
          }
        }
      ]
    }
  ]
}
```

通过 user_ref 推送复选框消息，用户回复：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568731433118,
      "messaging": [
        {
          "sender": {
            "id": "2358598834233528"
          },
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568731432668,
          "message": {
            "mid": "RB5t5P1xkzfDgfwMSxXWdeCsiamKQfe6u6PafrkNoIm7fdlL_PQ6awhWlFdhFW5kV68lM_CDzBQicabS5Ca0Ew",
            "text": "Hi"
          },
          "prior_message": {
            "source": "checkbox_plugin",
            "identifier": "user-k0ny69go89"
          }
        }
      ]
    }
  ]
}
```



转发消息：
```json
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568728233326,
      "messaging": [
        {
          "sender": {
            "id": "2358598834233528"
          },
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568728232926,
          "message": {
            "mid": "AScylPFmNtGgffO1eDpMPeCsiamKQfe6u6PafrkNoIkNADO0_jyVAbBI8Ca836OKah-YYa4TTwvqMhWyi5TWrA",
            "attachments": [
              {
                "title": "Still searching for discount codes?",
                "url": "https://l.facebook.com/l.php?u=https%3A%2F%2Fwww.shopper.com%2Fjoin%2Fxiuying.xie&h=AT26oazvaw9ftiVxaX4NhtWgqdb8oTtgnzGdEjA4S3nssDx3UUt1U_v_miXmeLYAaxDYgl7GrC3HZvECc2sTwogaRw8Ct8U4vUfA11_66hHpQJeKi6s2c3wtYGewgkAL8JpyB_8z6O-zaAs&s=1",
                "type": "fallback",
                "payload": null
              }
            ]
          }
        }
      ]
    }
  ]
}
```



let us chat 插件：
```
{
  "object": "page",
  "entry": [
    {
      "id": "331544897511006",
      "time": 1568785768294,
      "messaging": [
        {
          "recipient": {
            "id": "331544897511006"
          },
          "timestamp": 1568785768294,
          "sender": {
            "id": "2358598834233528"
          },
          "optin": {
            "ref": "user_encode=f1a8a2eb06af69d696805d60b46924d2/ref=pc-messenger-points"
          }
        }
      ]
    }
  ]
}
```