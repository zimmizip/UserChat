package datec;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import com.sun.source.util.TaskEvent.Kind;

import user.Util;


public class datecMgr {
	public datecMgr() {}
	
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
   
   //전체 total 리스트로 가져오기
   public Vector<datecBean> getdatecList(String dlocation) {         
      Connection conn = getConnection();
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      Vector<datecBean> vlist = new Vector<datecBean>();
   
         try {
            String sql = "select * from datec where dlocation=? ";
            pstmt = conn.prepareStatement(sql);   
            pstmt.setString(1, dlocation);
            rs = pstmt.executeQuery();   
            System.out.println(rs.getRow());
            while (rs.next()) {                                    
               datecBean bean = new datecBean();
               bean.setDname (rs.getString("dname"));
               bean.setDexplan(rs.getString("dexplan"));
               bean.setDphoto(rs.getString("dphoto"));
               bean.setDtel(rs.getString("dtel"));
               bean.setDmenu(rs.getString("dmenu"));
               bean.setDprice(rs.getString("dprice"));
               bean.setDlocation(rs.getString("dlocation"));
               bean.setDaddress(rs.getString("daddress"));
               bean.setDtime(rs.getString("dtime"));
               bean.setDtype(rs.getString("dtype"));
               vlist.addElement(bean);
            }
         } catch(Exception ex) {
            ex.printStackTrace();
         }finally {
            Util.close(conn, pstmt, rs);
         }
         return vlist;
         }
   
   // 필터,검색 결과 리스트로 가져오기
    public Vector<datecBean> getkindList(String dlocation, String dkind, String category, String sentence) {         
         Connection conn = getConnection();
         PreparedStatement pstmt = null;
         ResultSet rs = null;
         Vector<datecBean> vlist = new Vector<datecBean>();
         String sql="";
         System.out.println(category);
         System.out.println(sentence);
         System.out.println(dkind);
         System.out.println(dlocation);
            try {
			if (category.equals("") || category == null) { 								/* 검색필터가 null 일때 */
				if (dkind.equals("total")) { 											/* dkind total일때 */			
               sql = "select * from datec where dlocation=?";							
               pstmt = conn.prepareStatement(sql);   
               pstmt.setString(1, dlocation);
               }
				else { 																	/* dkind (play,food,cafe)일때 */
               sql = "select * from datec where dlocation=? and dtype=? ";			
               pstmt = conn.prepareStatement(sql);   
               pstmt.setString(1, dlocation );
               pstmt.setString(2, dkind );
               }
			} else { 																	/* 검색했을경우 => category,sentence가 있는 경우 */
               sql="select * from datec where " + category +" like ?" ;
               pstmt=conn.prepareStatement(sql);
               pstmt.setString(1, "%" + sentence  + "%");
            }
               rs = pstmt.executeQuery();   
               
               System.out.println(sql);
               while (rs.next()) {                                    
                  datecBean bean = new datecBean();
                  bean.setDname (rs.getString("dname"));
                  bean.setDexplan(rs.getString("dexplan"));
                  bean.setDphoto(rs.getString("dphoto"));
                  bean.setDtel(rs.getString("dtel"));
                  bean.setDmenu(rs.getString("dmenu"));
                  bean.setDprice(rs.getString("dprice"));
                  bean.setDlocation(rs.getString("dlocation"));
                  bean.setDaddress(rs.getString("daddress"));
                  bean.setDtime(rs.getString("dtime"));
                  bean.setDtype(rs.getString("dtype"));
                  vlist.addElement(bean);
               }
            } catch(Exception ex) {
               System.out.println("Exception" + ex);
               ex.printStackTrace();
            }finally {
               if(rs!=null) try { rs.close();} catch(SQLException e) {}
               if(pstmt!=null) try { pstmt.close();} catch(SQLException e) {}
               if(conn!=null) try { conn.close();} catch(SQLException e) {}
            }
            return vlist;
            }
      
    //찜하기 목록 불러오기
   public Vector<datecBean> myplaceList(String userID){
      Connection conn=getConnection();
      PreparedStatement pstmt=null;
      ResultSet rs=null;
      String strQuery="";
      Vector<datecBean> plist=new Vector<datecBean>();
      try {
            strQuery="select dc.* from datec dc, datecgood dg where id=? and dg.dname=dc.dname";
            pstmt=conn.prepareStatement(strQuery);
            pstmt.setString(1, userID);
            rs=pstmt.executeQuery();
         while(rs.next()) {
            datecBean bean=new datecBean();
            bean.setDname(rs.getString("dname"));
            bean.setDexplan(rs.getString("dexplan"));
            bean.setDphoto(rs.getString("dphoto"));
            bean.setDtel(rs.getString("dtel"));
            bean.setDmenu(rs.getString("dmenu"));
            bean.setDprice(rs.getString("dprice"));
            bean.setDlocation(rs.getString("dlocation"));
            bean.setDaddress(rs.getString("daddress"));
            bean.setDtime(rs.getString("dtime"));
            bean.setDtype(rs.getString("dtype"));
            plist.addElement(bean);
         }
      }catch(Exception e){
         e.printStackTrace();
      }finally{
         Util.close(conn, pstmt,rs);
         
      }
      return plist;
   }
   
   
   
   //찜하기 DB추가
   public Boolean insertgood(String id, String place) {
      Connection conn = getConnection();
      PreparedStatement pstmt = null;
      Boolean result = false;
         try {
            String strQuery = "insert into datecgood values(?,?)";
            pstmt = conn.prepareStatement(strQuery);   
               pstmt.setString(1, id); 
               pstmt.setString(2, place);
            if(pstmt.executeUpdate()==1)          
               result = true;
            } catch(Exception e) {
               e.printStackTrace();
            } finally{
                    Util.close(conn,pstmt);
                 }return result;
            }
   
   
 //찜하기 DB삭제
   public Boolean deletegood(String id, String place) {
      Connection conn = getConnection();
      PreparedStatement pstmt = null;
      Boolean result = false;
         try {
            String strQuery = "delete from datecgood where id=? and dname=?";
            pstmt = conn.prepareStatement(strQuery);   
               pstmt.setString(1, id); 
               pstmt.setString(2, place);
            if(pstmt.executeUpdate()==1)          
               result = true;
            } catch(Exception e) {
               e.printStackTrace();
            } finally{
                    Util.close(conn,pstmt);
                 }return result;
            }
   
   //찜하기 DB에 데이터있는지 확인
   public boolean goodcheck(String id, String place){
	      Connection conn=getConnection();
	      PreparedStatement pstmt=null;
	      ResultSet rs=null;
	      boolean result = false;
	      System.out.println(1);
	      System.out.println(id);
	      System.out.println(place);
	      try {
	    	  System.out.println(2);
	            String strQuery="select * from datecgood where id=? and dname=?";
	            pstmt=conn.prepareStatement(strQuery);
	            pstmt.setString(1, id);
	            pstmt.setString(2, place);
	            rs = pstmt.executeQuery();
	            if(rs.next())  {        
	                result = true; 
	            }
	      }catch(Exception e){
	         e.printStackTrace();
	      }finally{
	         Util.close(conn, pstmt,rs);     
	      }System.out.println(3);
	      System.out.println(result);
	      return result;
	   }
   
      
}