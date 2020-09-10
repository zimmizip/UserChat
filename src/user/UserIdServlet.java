package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserIdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html);charset=UTF-8");
		String userName = request.getParameter("userName");
		String userEmail = request.getParameter("userEmail");
		UserDAO user = new UserDAO();
		if(userName == null || userName.equals("") || userEmail == null || userEmail.equals("")) {
			request.getSession().setAttribute("messageType", "오류메세지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요.");
			response.sendRedirect("findIDPW.jsp");
			return;
		}
		String userID = user.findID(userName, userEmail);
		if(userID.equals("0")) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "정보를 잘못 입력 하셨습니다.");
			response.sendRedirect("findIDPW.jsp");
			return;
			
		} else {
			request.getSession().setAttribute("userID", userID);
			request.getSession().setAttribute("messageType", "성공 메세지");
			request.getSession().setAttribute("messageContent", "ID를 찾았습니다.");
			response.sendRedirect("ID.jsp");
			return;
		}
	}
}
