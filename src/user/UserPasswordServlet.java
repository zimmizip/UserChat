package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UserPasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html);charset=UTF-8");
		String userID = request.getParameter("userID");
		String userEmail = request.getParameter("userEmail");
		UserDAO user = new UserDAO();
		if(userEmail == null || userEmail.equals("") || userID == null || userID.equals("")) {
			request.getSession().setAttribute("messageType", "오류메세지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력하세요.");
			response.sendRedirect("findIDPW.jsp");
			return;
		}
		String userPassword = user.findPassword(userID, userEmail);
		if(userPassword.equals("0")) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "정보를 잘못 입력 하셨습니다.");
			response.sendRedirect("findIDPW.jsp");
			return;
			
		} else {
			request.getSession().setAttribute("userPassword", userPassword);
			request.getSession().setAttribute("messageType", "성공 메세지");
			request.getSession().setAttribute("messageContent", "Password를 찾았습니다.");
			response.sendRedirect("Password.jsp");
			return;
		}
	}
}
