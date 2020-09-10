package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		String userPassword = request.getParameter("userPassword");
		if(userID == null || userID.equals("") || userPassword == null || userPassword.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력해주세요.");
			response.sendRedirect("main.jsp");
			return;
		}
		int result = new UserDAO().login(userID, userPassword);
		int userGender = new UserDAO().findGender(userID);
		String userProfile = new UserDAO().checkProfile(userID);
		if(result == 1) {
			request.getSession().setAttribute("userID", userID);
			if(userGender == 1) {
				request.getSession().setAttribute("userGender", "남자");
			} else {
				request.getSession().setAttribute("userGender", "여자");
			}
			if(userProfile.equals("")) {
				request.getSession().setAttribute("messageType", "오류 메세지");
				request.getSession().setAttribute("messageContent", "환영합니다. 프로필을 작성해주세요.");
				response.sendRedirect("/UserChat/user/profileUpdate.jsp");
			} else {
				request.getSession().setAttribute("userProfile", userProfile);
				request.getSession().setAttribute("messageType", "성공 메세지");
				request.getSession().setAttribute("messageContent", "로그인에 성공했습니다.");
				response.sendRedirect("index.jsp");
			}
		}
		else if(result == 2) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "비밀번호를 다시 확인해주세요.");
			response.sendRedirect("main.jsp");
		}
		else if(result == 0) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "아이디가 존재하지 않습니다.");
			response.sendRedirect("main.jsp");
		}
		else if(result == -1) {
			request.getSession().setAttribute("messageType", "오류 메세지");
			request.getSession().setAttribute("messageContent", "데이터베이스 오류가 발생하였습니다.");
			response.sendRedirect("main.jsp");
		}
	}
}
