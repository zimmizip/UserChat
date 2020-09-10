package chat;

public class ChatDTO {
	private int chatID;
	private String fromID;
	private String toID;
	private String chatTime;
	private String chatContent;
	
	public String getChatContent() {
		return chatContent;
	}
	public void setChatContent(String chatContent) {
		this.chatContent = chatContent;
	}
	public int getChatID() {
		return chatID;
	}
	public void setChatID(int chatID) {
		this.chatID = chatID;
	}
	public String getFromID() {
		return fromID;
	}
	public void setFromID(String fromID) {
		this.fromID = fromID;
	}
	public String getToID() {
		return toID;
	}
	public void setToID(String toID) {
		this.toID = toID;
	}
	public String getChatTime() {
		return chatTime;
	}
	public void setChatTime(String chatTime) {
		this.chatTime = chatTime;
	}
	@Override
	public String toString() {
		return "ChatDTO [chatID=" + chatID + ", fromID=" + fromID + ", toID=" + toID + ", chatTime=" + chatTime
				+ ", chatContent=" + chatContent + "]";
	}
	
}
