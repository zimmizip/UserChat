package board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import user.Util;

public class BoardDAO {

	public BoardDAO() {}
	
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
	
	public int write(String userID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "insert into board values(?, nvl((select MAX(boardID) + 1 from board), 1), ?, ?, sysdate, 0, ?, ?, nvl((select MAX(boardGroup) + 1 from board), 0), 0, 0, 1)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, boardTitle);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, boardFile);
			pstmt.setString(5, boardRealFile);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public BoardDTO getBoard(String boardID) {
		Connection conn = getConnection();
		BoardDTO board = new BoardDTO();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from board where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 16));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardAvailable(rs.getInt("boardAvailable"));
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return board;
	}
	
	public ArrayList<BoardDTO> getList(String pageNumber) {
		Connection conn = getConnection();
		ArrayList<BoardDTO> boardList = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from board where boardGroup > (select max(boardGroup) from board) - ? and boardGroup <= (select max(boardGroup) from board) - ? order by boardGroup DESC, boardSequence ASC";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			pstmt.setInt(2, (Integer.parseInt(pageNumber) - 1) * 10);
			rs = pstmt.executeQuery();
			boardList = new ArrayList<BoardDTO>();
			while(rs.next()) {
				BoardDTO board = new BoardDTO();
				board.setUserID(rs.getString("userID"));
				board.setBoardID(rs.getInt("boardID"));
				board.setBoardTitle(rs.getString("boardTitle").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				board.setBoardContent(rs.getString("boardContent").replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>"));
				board.setBoardDate(rs.getString("boardDate").substring(0, 16));
				board.setBoardHit(rs.getInt("boardHit"));
				board.setBoardFile(rs.getString("boardFile"));
				board.setBoardRealFile(rs.getString("boardRealFile"));
				board.setBoardGroup(rs.getInt("boardGroup"));
				board.setBoardSequence(rs.getInt("boardSequence"));
				board.setBoardLevel(rs.getInt("boardLevel"));
				board.setBoardAvailable(rs.getInt("boardAvailable"));
				boardList.add(board);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return boardList;
	}
	
	public int hit(String boardID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update board set boardHit = boardHit + 1 where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardID);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public String getFile(String boardID) {
		Connection conn = getConnection();
		BoardDTO board = new BoardDTO();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select boardFile from board where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString("boardFile");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return "";
	}
	
	public String getRealFile(String boardID) {
		Connection conn = getConnection();
		BoardDTO board = new BoardDTO();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select boardRealFile from board where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString("boardRealFile");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return "";
	}
	
	public int update(String boardID, String boardTitle, String boardContent, String boardFile, String boardRealFile) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update board set boardTitle = ?, boardContent = ?, boardFile = ?, boardRealFile = ? where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardTitle);
			pstmt.setString(2, boardContent);
			pstmt.setString(3, boardFile);
			pstmt.setString(4, boardRealFile);
			pstmt.setInt(5, Integer.parseInt(boardID));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public int delete(String boardID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update board set boardAvailable = 0 where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(boardID));
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public int reply(String userID, String boardTitle, String boardContent, String boardFile, String boardRealFile, BoardDTO parent) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "insert into board values(?, nvl((select MAX(boardID) + 1 from board), 1), ?, ?, sysdate, 0, ?, ?, ?, ?, ?, 1)";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, boardTitle);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, boardFile);
			pstmt.setString(5, boardRealFile);
			pstmt.setInt(6, parent.getBoardGroup());
			pstmt.setInt(7, parent.getBoardSequence() + 1);
			pstmt.setInt(8, parent.getBoardLevel() + 1);
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public int replyUpdate(BoardDTO parent) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		String sql = "update board set boardSequence = boardSequence + 1 where boardGroup = ? and boardSequence > ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, parent.getBoardGroup());
			pstmt.setInt(2, parent.getBoardSequence());
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt);
		}
		return -1;
	}
	
	public boolean nextPage(String pageNumber) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select * from board where boardGroup >= ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(pageNumber) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return false;
	}
	
	public int targetPage(String pageNumber) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select count(boardGroup) from board where boardGroup > ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, (Integer.parseInt(pageNumber) - 1) * 10);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) / 10;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return 0;
	}
	
	public String getfile(String boardID) {
		Connection conn = getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "select boardFile from board where boardID = ?";
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, boardID);
			rs = pstmt.executeQuery();
			if(rs.next() || boardID.equals("")) {
				if(rs.getString("userProfile").equals("")) {
					return "";
				}
				return "http://localhost:8089/UserChat/upload/" + rs.getString("boardFile");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			Util.close(conn, pstmt, rs);
		}
		return "";
	}
}
