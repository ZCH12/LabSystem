package org.cms.db;

import java.sql.*;

public class Database {
    Connection connection;

    public Database() {
        String driverName = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
        String dbURL = "jdbc:sqlserver://127.0.0.1;databaseName=CMS_db;integratedSecurity=false;";
        String userName = "sa";
        String userPwd = "88888888";
        try {
            Class.forName(driverName);
            connection = DriverManager.getConnection(dbURL, userName, userPwd);
            System.out.println("连接数据库成功");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.print("连接失败");
        }
    }
}
