# Golang 中的数据库操作

[TOC]

- 标准库：[`database/sql`](http://go-database-sql.org/) 用于对 SQL 数据的访问，提供了一系列接口方法，用于操作关系数据库，但其并不提供连接数据库的能力。
- MySQL 包：[`github.com/go-sql-driver/mysql`](https://github.com/go-sql-driver/mysql/) 连接 MySQL 数据驱动。

对于数据库操作来说，开发者不应该直接使用导入的驱动包所提供的方法，而应该**使用 sql.DB 对象提供的统一的方法**。**因此在导入 MySQL 驱动时，使用了匿名导入包的方式**。在导入一个数据库驱动后，该驱动会自动初始化并注册到 `Golang` 的 `database/sql` 上下文中，这样就可以通过 `database/sql` 包提供的方法来访问数据库了。

```golang
import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql" // 匿名导入 mysql 包
)
```

如果需要其他类型的数据库驱动，可以去 [`https://github.com/golang/go/wiki/SQLDrivers`](https://github.com/golang/go/wiki/SQLDrivers) 找对应的驱动包。

## 连接数据库 sql.Open

> 参考于：https://github.com/go-sql-driver/mysql/wiki/Examples

```golang
// Open opens a database specified by its database driver name and a
// driver-specific data source name, usually consisting of at least a
// database name and connection information.
//
// Most users will open a database via a driver-specific connection
// helper function that returns a *DB. No database drivers are included
// in the Go standard library. See https://golang.org/s/sqldrivers for
// a list of third-party drivers.
//
// Open may just validate its arguments without creating a connection
// to the database. To verify that the data source name is valid, call
// Ping.
//
// The returned DB is safe for concurrent use by multiple goroutines
// and maintains its own pool of idle connections. Thus, the Open
// function should be called just once. It is rarely necessary to
// close a DB.
func Open(driverName, dataSourceName string) (*DB, error) {
	driversMu.RLock()
	driveri, ok := drivers[driverName]
	driversMu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("sql: unknown driver %q (forgotten import?)", driverName)
	}

	if driverCtx, ok := driveri.(driver.DriverContext); ok {
		connector, err := driverCtx.OpenConnector(dataSourceName)
		if err != nil {
			return nil, err
		}
		return OpenDB(connector), nil
	}

	return OpenDB(dsnConnector{dsn: dataSourceName, driver: driveri}), nil
}
```

从 `sql.Open` 的源码可以看出：
1. `sql.Open("mysql", ""<username>:<passwd>@tcp(<IP Or Domain>:<port>)/<Database>?charset=utf8"")`，**只是进行参数的验证**。若成功返回的是一个 `sql.DB` 资源句柄，而：**sql.DB 不是一个具体的连接**。
2. 当调用 `database/sql` 包中的 `Open()` 方法后，`database/sql` 包在后台管理着一个连接池，只有当用户真正使用的时候才会创建具体的连接。
3. 因此：即使方法中的 `dataSourceName` 参数所包含的数据库用户名、密码、端口、IP 等信息错误，`sql.Open()` 是不会返回错误信息的。
4. 若需要 DSN(Database Source Name) 是否有效，可以调用 `db.Ping()` 进行验证

```golang
// Ping verifies a connection to the database is still alive,
// establishing a connection if necessary.
func (db *DB) Ping() error {
	return db.PingContext(context.Background())
}
```

Demo 案例如下：

```golang
package main

import (
	"database/sql"
	_ "github.com/go-sql-driver/mysql"
)


type MysqlConn struct {
	Dsn string // 数据库驱动连接字符（database source name 即：dsn）
	Db *sql.DB // 引入标准库的 sql 包
}

func main() {
    var connErr error
	mysqlConn := MysqlConn{
		Dsn: "root:<passwd>@tcp(127.0.0.1:3306)/test?charset=utf8",
	}
	if mysqlConn.Db, connErr = sql.Open("mysql", mysqlConn.Dsn); connErr != nil {
		panic(connErr)
		return
	}
	defer mysqlConn.Db.Close() // 利用延缓函数设置资源关闭

	// Open doesn't open a connection. Validate DSN data:
	err := mysqlConn.Db.Ping()
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
}
```

## CURD 操作
