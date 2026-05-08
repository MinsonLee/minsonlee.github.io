- 深入 Laravel 核心 ：https://learnku.com/docs/laravel-core-concept/5.5


- How to pass array in where condition of Query with one 'Not Equal' Contion?
```php
$whereData = [
    ['name', 'test'],
    ['id', '<>', '5']
];

$users = DB::table('users')->where($whereData)->get(); 
```

Laravel 深入浅出指南：https://github.com/xiaohuilam/laravel/wiki?from=gitio