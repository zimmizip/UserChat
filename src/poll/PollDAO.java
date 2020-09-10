package poll;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Vector;

import org.apache.tomcat.jni.Poll;

import user.Util;

public class PollDAO {

	public PollDAO() {}
	
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
	
	public Vector<PollListDTO> getAllList(){
		Connection conn = getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		Vector<PollListDTO> vlist=new Vector<PollListDTO>();
		sql="select * from tblPollList order by num desc";
		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				PollListDTO plBean=new PollListDTO();
				plBean.setNum(rs.getInt("num"));
				plBean.setQuestion(rs.getString("question"));
				vlist.add(plBean);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return vlist;
	}
	
	
	public int getMaxNum() {
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		int maxnum=0;
		sql="select nvl(max(num),0) from tblPollList";
		try {
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				maxnum=rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return maxnum;
		}
	
	public PollListDTO getList(int num) {		//문항 번호(질문)를 가져오는 메소드
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		PollListDTO plBean=new PollListDTO();
		int maxnum=0;
		try {
			if(num==0) 
				sql="select * from tblPollList order by num desc";
			else
				sql="select * from tblPollList where num="+num;
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				plBean.setQuestion(rs.getString("question"));
				plBean.setType(rs.getInt("type"));
				plBean.setActive(rs.getInt("active"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return plBean;
		}

	public Vector<String> getItem(int num) {	//질문의 보기를 가져오는 메소드
	Connection conn=getConnection();
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String sql="";
	Vector<String> vlist=new Vector<String>();
	int maxnum=0;
	try {
		if(num==0) 
			num=getMaxNum()-1;
		sql="select item from tblPollItem where listnum=?";
		pstmt=conn.prepareStatement(sql);
		pstmt.setInt(1, num);
		rs=pstmt.executeQuery();
		while(rs.next()) {
		vlist.add(rs.getString(1));
		}
	}catch(Exception e) {
		e.printStackTrace();
	}finally {
		Util.close(conn, pstmt,rs);
	}
	return vlist;
	}
	
	
	public boolean insertUserPoll(String id,int num,String[] itemnum) {	//사용자의 응답 정보 저장
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		String sql="";
		boolean flag=false;
		try {
			sql="insert into UserPoll values(?,?,?)";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			if(num==0) num=getMaxNum();
			for(int i=0;i<itemnum.length;i++) {
				if(itemnum[i]==null || itemnum[i].equals("")) break;

				pstmt.setInt(2, num);
				pstmt.setString(3, itemnum[i]);
				int j=pstmt.executeUpdate();
				if(j>0)flag=true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return flag;
	}
	
	public Vector<PollItemDTO> typelist(String id) {		//사용자의 입력 정보 리스트
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		Vector<PollItemDTO> idlist=new Vector<PollItemDTO>();
		try {
			sql="select id,listnum,itemnum from userpoll u, tblpolllist t where u.listnum=t.num and u.id=? order by listnum";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				PollItemDTO idBean=new PollItemDTO();
				idBean.setListnum(rs.getInt("listnum"));
				idBean.setItemnum(rs.getInt("itemnum"));
				idlist.add(idBean);
			}
		
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return idlist;
	}
	public int[] showitem(Vector<PollItemDTO> typelist) {		//각 문항마다 응답한 정보를 배열에 담음
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		int[] result=new int[typelist.size()];
		try {
			sql="select itemnum,item from tblpollitem where listnum=? and itemnum=?  ";		//사용자의 심리테스트 결과에서 문제 번호와 정답 번호를 조건에 넣음
			for(int i=0;i<typelist.size();i++) {		//문제의 개수만큼 for문을 돌려서 result에 정답번호를 저장
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, typelist.get(i).getListnum());
				pstmt.setInt(2, typelist.get(i).getItemnum());
				rs=pstmt.executeQuery();
				if(rs.next()) {
					result[i]=rs.getInt("itemnum")+1;	//정답 번호를 가져와서 result에 저장(+1을 하는 이유는 정답이 DB에 들어갈 때 0,1,2,3으로 들어가기 때문)
				}
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}	
		return result;
	}
	
	public boolean testCheck(String userid) {	//사용자가 심리테스트에 참여를 했는지 체크
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		boolean result=false;
		try {
			sql="select * from userpoll where id=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userid);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				result=true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return result;
	}
	
	public Vector<ExplainDTO> mytestlist(String id){		//사용자가 응답에 대한 해석
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		Vector<ExplainDTO> vlist=new Vector<ExplainDTO>();
		try {
			sql="select u.listnum,u.itemnum,p.item answer,t.question,e.explain,e.content "
					+ " from explain e,userpoll u ,tblpolllist t, tblpollitem p "
					+ " where t.num=u.listnum and u.listnum=e.listnum and u.itemnum=e.itemnum "
					+ " and p.listnum=t.num and p.itemnum=u.itemnum and  id=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs=pstmt.executeQuery();
			while(rs.next()) {
				ExplainDTO bean=new ExplainDTO();
				bean.setListnum(rs.getInt("listnum"));
				bean.setItemnum(rs.getInt("itemnum"));
				bean.setQuestion(rs.getString("question"));
				bean.setExplain(rs.getString("explain"));
				bean.setContent(rs.getString("content"));
				bean.setAnswer(rs.getString("answer"));
				vlist.add(bean);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return vlist;
	}
	
	public ExplainDTO comparelist(int num,String userid){		//각 문항마다 응답이 다른 문항
		Connection conn=getConnection();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String sql="";
		ExplainDTO bean=new ExplainDTO();
		try {
			sql="select  p.item answer , u.id,t.question,e.* from explain e,tblpollitem p, userpoll u, tblpolllist t " 
					+ " where t.num=u.listnum and e.listnum=p.listnum and e.itemnum=u.itemnum and p.itemnum=u.itemnum "
					+ " and p.itemnum=u.itemnum and p.listnum=u.listnum and p.listnum=? and id=?"; 
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, userid);
			rs=pstmt.executeQuery();
				if(rs.next()) {
					bean.setListnum(rs.getInt("listnum"));
					bean.setItemnum(rs.getInt("itemnum"));
					bean.setQuestion(rs.getString("question"));
					bean.setAnswer(rs.getString("answer"));
					bean.setExplain(rs.getString("explain"));
					bean.setContent(rs.getString("content"));
				}
				
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt,rs);
		}
		return bean;
	}
}

