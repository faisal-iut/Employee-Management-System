/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package transaction;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author fahim
 */
public class connection {
    
      
    static Connection  getconnection() {
 
		System.out.println("-------- Oracle JDBC Connection Testing ------");
 
		try {
 
			Class.forName("oracle.jdbc.driver.OracleDriver");
 
		} catch (ClassNotFoundException e) {
 
			System.out.println("Where is your Oracle JDBC Driver?");
			
 
		}
 
		System.out.println("Oracle JDBC Driver Registered!");
 
		Connection con = null;
 
		try {
 
			con = DriverManager.getConnection(
					"jdbc:oracle:thin:@localhost:1521:XE", "govt",
					"govt");
 
		} catch (SQLException e) {
 
			System.out.println("Connection Failed! Check output console");
			
 
		}
 
		if (con != null) {
			System.out.println("You made it, take control your database now!");
		} else {
			System.out.println("Failed to make connection!");
		}
        return con ;
	}
 
    
    
}
