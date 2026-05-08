1. 获取 cut 最后一列字段

如

```shell
lms@lms:/tmp$ ls -ahl | grep ' 0 4月'
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk05ff418f824c7b374288480c11baa8d2b88885
-rw-------  1 lms  lms     0 4月  16 06:58 juju-mk066c2b99837d71cbdef4e1fa1163074562ba17
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk0745224eb86970670f63c512f66fb1cc76d1aa
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk1c861be118df98f9f7aa39ee1e445df77e412b
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk2dbf58ad1b8e88ae4a05d58d35b48586fba066
-rw-------  1 lms  lms     0 4月  16 07:25 juju-mk339e9b4a9d284506150c54f0a8a20a78d5c9ea
-rw-------  1 lms  lms     0 4月  16 06:58 juju-mk3e974b9f3b40d05d50dd4d90a40431e7469c74
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk50d3cd9104a5e83bbd9815d5150d8f5f75871c
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk656e6f3b6217f7e499db23aa0d0451487ff423
-rw-------  1 lms  lms     0 4月  16 07:03 juju-mk6597cc905c180000a2d8d4c4db4d07b60f71bb
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk6e293f607ff1260c95a2a14669979bab3dccad
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk72dc3de3b07d69ffd54ba734fc1213fba00254
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mk88ec34d4dc6feb466f46342c15d857f9fc3fbb
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mka2a4a1b6140182b91feaf522fd74702ae92e85
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mkaeff493bfba2721283b68aaca20019dfde86cd
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mkb21a5060f26b9e97499f123cd1913532d883ee
-rw-------  1 lms  lms     0 4月  16 07:06 juju-mkb5f7c057dd12c483eb0836ff5a75657b71fe51
-rw-------  1 lms  lms     0 4月  16 07:00 juju-mkca280c7309ce6e504cbeac70cc213dc3dbbb7d
-rw-------  1 lms  lms     0 4月  16 07:01 juju-mkf7735900b7a5497416b1f45a802530652ff867
```

利用字符串反转 `rev`，将最后一列变为第一列

`ls -ahl | grep ' 0 4月' | rev | cut -f1 -d' ' | rev`