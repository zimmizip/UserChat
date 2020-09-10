package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Vector;

import board.BoardDTO;

public class UserDAO {

	public UserDAO() {}
	
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
	
	public int login(String userID, String userPassword) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("userPassword").equals(userPassword)) {
					return 1; 
				}
				return 2;
			}
			else {
				return 0;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return -1; 
	}
	
	public int findGender(String userID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select userGender from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString("userGender").equals("남자")) {
					return 1; 
				}
				else {
					return 2;
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return 1;
	}
	
	public int registerCheck(String userID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next() || userID.equals("")) {
				return 0; 
			}
			else {
				return 1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return -1;
	}
	
	public int register(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail, String userProfile, String userContent, int userGood) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "insert into C_user values(?,?,?,?,?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			pstmt.setString(3, userName);
			pstmt.setInt(4, Integer.parseInt(userAge));
			pstmt.setString(5, userGender);
			pstmt.setString(6, userEmail);
			pstmt.setString(7, userProfile);
			pstmt.setString(8, userContent);
			pstmt.setInt(9, userGood);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public UserDTO getUser(String userID) {
		Connection conn = getConnection();
		UserDTO user = new UserDTO();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user.setUserID(userID);
				user.setUserPassword(rs.getString("userPassword"));
				user.setUserName(rs.getString("userName"));
				user.setUserAge(rs.getInt("userAge"));
				user.setUserGender(rs.getString("userGender"));
				user.setUserEmail(rs.getString("userEmail"));
				user.setUserProfile(rs.getString("userProfile"));
				user.setUserContent(rs.getString("userContent"));
				user.setUserGood(rs.getInt("userGood"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return user;
	}
	
	public int update(String userID, String userPassword, String userName, String userAge, String userGender, String userEmail) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update C_user set userPassword = ?, userName = ?, userAge = ?, userGender = ?, userEmail = ? where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userPassword);
			pstmt.setString(2, userName);
			pstmt.setInt(3, Integer.parseInt(userAge));
			pstmt.setString(4, userGender);
			pstmt.setString(5, userEmail);
			pstmt.setString(6, userID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public int profile(String userID, String userProfile, String userContent) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update C_user set userProfile = ?, userContent = ? where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userProfile);
			pstmt.setString(2, userContent);
			pstmt.setString(3, userID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public String getProfile(String userID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select userProfile from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next() || userID.equals("")) {
				if(rs.getString("userProfile").equals("")) {
					return "http://localhost:8089/UserChat/images/icon.png";
				}
				return "http://localhost:8089/UserChat/upload/" + rs.getString("userProfile");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return "http://localhost:8089/UserChat/images/icon.png";
	}
	
	public String checkProfile(String userID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select userProfile from C_user where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next() || userID.equals("")) {
				if(rs.getString("userProfile").equals("")) {
					return "";
				}
				return "http://localhost:8089/UserChat/upload/" + rs.getString("userProfile");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return "";
	}
	
	// 내가 좋아요 누른 사람 or 나를 좋아요 누른 사람 의 리스트가 존재하는지 존재안하는지 체크하기 위한 메소드
	public boolean FromHeart(String id,String button) {
	  Connection conn = getConnection();
      PreparedStatement pstmt=null;
      boolean result=false;
      String strQuery="";
      try {
    	if(button.equals("내가 좋아요 누른 사람")) {  
    		 strQuery="select * from heart where ID=?";
    	}else {	//나를 좋아요 누른 사람 버튼을 눌렀을 경우
    		 strQuery="select * from heart where toID=?";    	
    	}
    	pstmt=conn.prepareStatement(strQuery);
    	pstmt.setString(1, id);
    	if(pstmt.executeUpdate()!=0) {
    	  result=true;   
    	}
	  }catch(Exception e) {
	  e.printStackTrace();
      }finally {
    	  Util.close(conn, pstmt);
      }
      
      return result;
	}
	//호감있는 상대방의 상세 정보를 보기 위한 페이지
	public UserDTO userInfo(String memberid)  {
	  Connection conn = getConnection();
      PreparedStatement pstmt=null;
      ResultSet rs=null;
      UserDTO bean= new UserDTO();
      
      try {
         String strQuery="select * from C_USER where userid=? ";
         pstmt=conn.prepareStatement(strQuery);               
         pstmt.setString(1,memberid);  
         rs=pstmt.executeQuery();
         while(rs.next()) {
				bean.setUserID(rs.getString("userid"));
				bean.setUserName(rs.getString("username"));
				bean.setUserProfile(rs.getString("userprofile"));
				bean.setUserAge(rs.getInt("userage"));
				bean.setUserEmail(rs.getString("useremail"));	
				bean.setUserGender(rs.getString("usergender"));
			}
      }catch(Exception e){
    	  e.printStackTrace();	    
      }finally{   
            Util.close(conn,pstmt);      
      }
      return bean;
   }
	//로그인한 아이디와 내가 보고자 하는 사람의 정보를 들어가 내가 이사람에게 호감을 표시했는지 아닌지 체크
	public boolean checkid(String id,String userid) {
		Connection conn = getConnection();
	      PreparedStatement pstmt=null;
	      boolean result=false;
	      ResultSet rs=null;
	      String strQuery="";
	      try {
		      strQuery="select toID from heart where ID=?";	//로그인한 아이디가 이미 상대방에게 호감을 표시했는지 확인
		      pstmt=conn.prepareStatement(strQuery);
		      pstmt.setString(1, id);
		      rs=pstmt.executeQuery();	
		      while(rs.next()) {
					if(rs.getString("toID").equals(userid)) {		//내가 호감을 표시한 상대가 userid(상대방)일 경우 true 리턴
						return true;
					}else {
						result=false;
					}
				}
	    	 }catch(Exception e) {
	    	  e.printStackTrace();
	      }finally {
	    	  Util.close(conn, pstmt);
	      }
	      
	      return result;
	}
	//좋아요 취소 버튼을 누를 경우 삭제 메소드
	public void deleteHeart(String id,String userid) {
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		try {
	         String strQuery="delete heart where ID=? and toID=?";
	         pstmt=conn.prepareStatement(strQuery);               
	         pstmt.setString(1,id);  
	         pstmt.setString(2, userid);
	         pstmt.executeUpdate();
			}catch(Exception e){
	    	  e.printStackTrace();
	      }finally{   
	            Util.close(conn,pstmt);      
	      }
	}
	//좋아요 버튼을 누를 경우 삽입 메소드	
	public void sendHeart(String id,String userid) {
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		try {
	         String strQuery="insert into heart values(?,?) ";
	         pstmt=conn.prepareStatement(strQuery);               
	         pstmt.setString(1,id);  
	         pstmt.setString(2, userid);
	         pstmt.executeUpdate();
			}catch(Exception e){
	    	  e.printStackTrace();
	      }finally{   
	            Util.close(conn,pstmt);      
	      }
	}
	
	public Vector<UserDTO> fromheartList(String id,String button){
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String strQuery="";
		Vector<UserDTO> hlist=new Vector<UserDTO>();
		try {
				if(button.equals("내가 좋아요 누른 사람")) { 
					strQuery="select c.* from heart h, c_user c where h.toID=c.userid and h.ID=?";
				}else if(button.equals("나를 좋아요 누른 사람")) {	//나를 좋아요 누른 사람의 경우
					strQuery="select c.* from heart h, c_user c where h.ID=c.userid and h.toID=?";
				}else {	//서로 좋아요를 누를 경우 c.userid만 받아옴
					strQuery="select c.userid from heart h, c_user c where h.ID=c.userid and h.toID=?";
				}
				pstmt=conn.prepareStatement(strQuery);
				pstmt.setString(1, id);
				rs=pstmt.executeQuery();			
			while(rs.next()) {
				UserDTO bean=new UserDTO();		
				bean.setUserID(rs.getString("userid"));
				if(button.equals("서로 좋아요")) {	//서로 좋아요를 누를 경우
					hlist.add(eachlist(bean.getUserID(),id));		//eachlist : bean.getUserID()가 나를 좋아요 표시를 했는지 확인하기 위한 메소드				
				}else {
				bean.setUserName(rs.getString("username"));
				bean.setUserProfile(rs.getString("userprofile"));
				bean.setUserAge(rs.getInt("userage"));
				bean.setUserEmail(rs.getString("useremail"));		
					hlist.addElement(bean);
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			Util.close(conn, pstmt,rs);
			
		}
		return hlist;
	}
	
	public UserDTO eachlist(String getid,String id){
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String strQuery="";
		UserDTO user=new UserDTO();
		try {
				strQuery="select c.* from heart h, c_user c where h.ID=c.userid and h.toID=?";		//위에서 받아온 getid		
				pstmt=conn.prepareStatement(strQuery);
				pstmt.setString(1, getid);
				rs=pstmt.executeQuery();			
			if(rs.next()) {		
				user.setUserID(rs.getString("userid"));
				if(user.getUserID().equals(id)) {	//getid의 쿼리문의 userid와 id가 일치할 경우
					UserDTO u=new UserDAO().userInfo(getid);
					user.setUserID(u.getUserID());
					user.setUserName(u.getUserName());
					user.setUserProfile(u.getUserProfile());
					user.setUserAge(u.getUserAge());
					user.setUserEmail(u.getUserEmail());	
				}	
			}		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			Util.close(conn, pstmt,rs);
			
		}
		return user;
	}
	
	public String findID(String userName, String userEmail) {
		Connection conn = getConnection();
		String userID = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from C_user where userName = ? and userEmail = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userName);
			pstmt.setString(2, userEmail);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				userID = rs.getString("userID");
			}
			else {
				return "0";
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return userID;
	}
	
	public String findPassword(String userID, String userEmail) {
		Connection conn = getConnection();
		String userPassword = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from C_user where userID = ? and userEmail = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, userEmail);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				userPassword = rs.getString("userPassword");
			}
			else {
				return "0";
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return userPassword;
	}
	
	public int delete(String userID, String userPassword) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "delete from C_user where userID = ? and userPassword = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, userPassword);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public ArrayList<UserDTO> getGenderList(String userGender) {
		Connection conn = getConnection();
		ArrayList<UserDTO> userList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select userID, userProfile, userContent, userGood from C_user where userGender != ? and userProfile != 'null'";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userGender);
			rs = pstmt.executeQuery();
			userList = new ArrayList<UserDTO>();
			while(rs.next()) {
				UserDTO user = new UserDTO();
				user.setUserID(rs.getString("userID"));
				user.setUserProfile(rs.getString("userProfile"));
				user.setUserContent(rs.getString("userContent"));
				user.setUserGood(rs.getInt("userGood"));
				userList.add(user);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		Collections.shuffle(userList);
		return userList;
	}
	
	public ArrayList<UserDTO> getTopList(String userGender) {
		Connection conn = getConnection();
		ArrayList<UserDTO> topList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select userID, userProfile, userContent, userGood from (select userID, userProfile, userContent, userGood,  userGender from C_user order by userGood desc) where rownum <= 4 and userGender != ? and userGood != 0";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userGender);
			rs = pstmt.executeQuery();
			topList = new ArrayList<UserDTO>();
			while(rs.next()) {
				UserDTO user = new UserDTO();
				user.setUserID(rs.getString("userID"));
				user.setUserProfile(rs.getString("userProfile"));
				user.setUserContent(rs.getString("userContent"));
				topList.add(user);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return topList;
	}
	
	//좋아요 버튼을 누를 경우 삽입 메소드	
	public int sendGood(String userID, String toID) {
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		try {
	         String strQuery="insert into heart values(?,?) ";
	         pstmt=conn.prepareStatement(strQuery);               
	         pstmt.setString(1,userID);  
	         pstmt.setString(2, toID);
	        return pstmt.executeUpdate();
			}catch(Exception e){
	    	  e.printStackTrace();
	      }finally{   
	            Util.close(conn,pstmt);      
	      }
		return -1;
	}
	
	public int deleteGood(String userID, String toID) {
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		try {
	         String strQuery="delete heart where ID=? and toID=?";
	         pstmt=conn.prepareStatement(strQuery);               
	         pstmt.setString(1,userID);  
	         pstmt.setString(2, toID);
	        return pstmt.executeUpdate();
			}catch(Exception e){
	    	  e.printStackTrace();
	      }finally{   
	            Util.close(conn,pstmt);      
	      }
		return -1;
	}
	
	public String findGood(String userID, String toID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String checkGood = "no";
		String sql = "select * from heart where ID = ? and toID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, toID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				checkGood = "yes";
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			Util.close(conn, pstmt, rs);
		}
		return checkGood;
	}
	
	public int addGood(String toID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update C_user set userGood = userGood + 1 where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, toID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public int minusGood(String toID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update C_user set userGood = userGood - 1 where userID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, toID);
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
}
