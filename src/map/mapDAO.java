package map;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import user.Util;

public class mapDAO {

	public mapDAO() {}
	
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
	
	public Vector<mapDTO> showAddress(String userid,String gender){			//동네 주변의 이성의 주소 정보를 가지고 있는 모든 행을 가지고 옴(주소의 substring(1,10)이 동일할 경우)
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		Vector<mapDTO> vlist=new Vector<mapDTO>();
		sql="select U.USERID,U.ADDRESS,U.LAT,U.LNG,C.USERPROFILE from USER_ADDRESS U,C_USER C where U.USERID=C.USERID and c.USERGENDER=? and substr(address,1,10)=(select substr(address,1,10) from user_address where userid=?)"; 
		try {
			pstmt=conn.prepareStatement(sql);
			if(gender.equals("남자")) {
				pstmt.setString(1, "여자");
			}else {
				pstmt.setString(1, "남자");
			}
			pstmt.setString(2, userid);
			rs=pstmt.executeQuery();
			while(rs.next()) {	
				mapDTO bean=new mapDTO();
				bean.setAddress(rs.getString("address"));
				bean.setUserid(rs.getString("userid"));
				bean.setProfile(rs.getString("userprofile"));
				bean.setLat(rs.getDouble("lat"));
				bean.setLng(rs.getDouble("lng"));
				vlist.add(bean);
			}		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return vlist;
	}
	
	public mapDTO getInfo(String userid){			//로그인 회원의 정보
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		mapDTO bean=new mapDTO();
		sql="select U.USERID,U.ADDRESS,U.LAT,U.LNG,C.USERPROFILE from USER_ADDRESS U,C_USER C where U.USERID=C.USERID and c.userid=?"; 
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			if(rs.next()) {	
				bean.setAddress(rs.getString("address"));
				bean.setUserid(rs.getString("userid"));
				bean.setProfile(rs.getString("userprofile"));
				bean.setLat(rs.getDouble("lat"));
				bean.setLng(rs.getDouble("lng"));
			}		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return bean;
	}
	
	public boolean checkid(String userid){		//주소를 이미 입력하였는지 확인(이미 입력하였을 경우 주소 입력 페이지 건너뛰고 바로 map 으로 이동)
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		mapDTO bean=new mapDTO();
		sql="select  * from user_address where userid=?"; 
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return false;
	}
	
	public void insertAddress(String id,String address,String profile){			//주소 입력 후 db에 저장
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		sql="insert into user_address values(?,?,?,0,0)";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, address);
			pstmt.setString(3, profile);
			rs=pstmt.executeQuery();
			if(rs.getRow()!=0) {
				System.out.println("업데이트 완료");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
	}
	
	public void insertLatLng(String userid,double lat,double lng){		//map1에서 입력한 주소의 위도와 경도 입력
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		sql="update user_address set lat=?,lng=? where userid=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setDouble(1, lat);
			pstmt.setDouble(2, lng);
			pstmt.setString(3, userid);
			rs=pstmt.executeQuery();			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
	}
	
	public String showid(String address){			//주변의 가까운 이성의 정보를 보여줌
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		String result="";
		sql="select userid from user_address where address=?";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, address);
			rs=pstmt.executeQuery();
			if(rs.next()) {	
				result=rs.getString("userid");
			}				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return result;
	}
	
	public double distance(mapDTO bean, mapDTO comparebean) {		// map1에서 입력받아온 위도 경도
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		double result=0;
		sql="SELECT calc_distance(?, ?, ?,?) AS DISTANCE" + 
				" FROM dual";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setDouble(1, bean.getLat());
			pstmt.setDouble(2, bean.getLng());
			pstmt.setDouble(3, comparebean.getLat());
			pstmt.setDouble(4, comparebean.getLng());
			rs=pstmt.executeQuery();
			if(rs.next()) {	
				result=rs.getDouble("distance");
			}				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return result;
	}
}
