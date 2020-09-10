package chart;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import user.Util;
public class ChartDAO {
	
	public ChartDAO() {}
	
	public static Connection getConnection() {
		Connection conn = null;
		try {
			String JDBC_Driver = "oracle.jdbc.driver.OracleDriver";
			String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
			String dbID = "scott";
			String dbPassword = "1111";
			Class.forName(JDBC_Driver);
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return conn;
	}
 	
 	//남녀성비
 	public String[] countGender() {
 		Connection conn = getConnection();
 		PreparedStatement pstmt = null;
 		ResultSet rs = null;
 		String sql = null;
 		String[] gender = new String[2];
 		sql = "select count(decode(substr(userGender,1,1),'남',1)), " + 
 				"count(decode(substr(userGender,1,1),'여',1))" + 
 				"from c_user";
 		try {
 			pstmt = conn.prepareStatement(sql);
 			rs = pstmt.executeQuery();
 			if(rs.next()) {
 				gender[0] = rs.getString(1);
 				gender[1] = rs.getString(2);
 			}
 		}catch(Exception e) {
 			e.printStackTrace();
 		}finally {
 			Util.close(conn, pstmt, rs);
 		}
 		return gender;
 	}
 	
 	
 	
 	//연령별 select
 	public String[] countAge() {
 		Connection conn = getConnection();
 		PreparedStatement pstmt = null;
 		ResultSet rs = null;
 		String sql = null;
 		String[] age = new String[5];
 		sql = "select count(decode(substr(userage,1,1), 1, 1)) ," + 
 				"count(decode(substr(userage,1,1), 2, 1)) ," + 
 				"count(decode(substr(userage,1,1), 3, 1)) ,"+
 				"count(decode(substr(userage,1,1), 4, 1)) ,"+
 				"count(decode(substr(userage,1,1), 5, 1))" 
 				+ "from c_user";
 		try {
 			pstmt = conn.prepareStatement(sql);
 			//pstmt.setString(1, userAge);
 			rs = pstmt.executeQuery();
 			
 			if(rs.next()) {
 				age[0] = rs.getString(1);
 				age[1] = rs.getString(2);
 				age[2] = rs.getString(3);
 				age[3] = rs.getString(4);
 				age[4] = rs.getString(5);
 				
 			}
 			
 		}catch(Exception e) {
 			e.printStackTrace();
 		}finally {
 			Util.close(conn, pstmt, rs);
 		}
 		return age;
 		
 		
 	}
}
