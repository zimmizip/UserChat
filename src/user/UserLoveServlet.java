package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserLoveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userID = request.getParameter("userID");
		String toID = request.getParameter("toID");
		if(userID == null || userID.equals("") || toID == null || toID.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "상대를 찾을수 없습니다.");
			response.sendRedirect("selectUser.jsp");
			return;
		}
		
		String checkGood = new UserDAO().findGood(userID, toID);
		if(checkGood.equals("yes")) {
			int delete = new UserDAO().deleteGood(userID, toID);
			if(delete == 1) {
				new UserDAO().minusGood(toID);
				request.getSession().setAttribute("messageType", "성공 메세지");
				request.getSession().setAttribute("messageContent", "좋아요 취소 ㅠㅠ");
				response.sendRedirect("selectUser.jsp?toID=" + toID);
			} else {
				request.getSession().setAttribute("messageType", "오류 메시지");
				request.getSession().setAttribute("messageContent", "상대를 찾을수 없습니다.");
				response.sendRedirect("selectUser.jsp?toID=" + toID);
				return;
			}
		} else {
			int send = new UserDAO().sendGood(userID, toID);
			if(send == 1) {
				new UserDAO().addGood(toID);
				request.getSession().setAttribute("messageType", "성공 메세지");
				request.getSession().setAttribute("messageContent", "좋아요!");
				response.sendRedirect("selectUser.jsp?toID=" + toID);
			} else {
				request.getSession().setAttribute("messageType", "오류 메시지");
				request.getSession().setAttribute("messageContent", "상대를 찾을수 없습니다.");
				response.sendRedirect("selectUser.jsp?toID=" + toID);
				return;
			}
		}
	}

}
