package coma.spring.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import coma.spring.dao.MsgDAO;
import coma.spring.dto.MsgDTO;



@Service
public class MsgService {
	@Autowired
	private MsgDAO msgdao;

	//받은쪽지함
	public List<MsgDTO> selectBySender(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = msgdao.selectBySender(cpage,msg_receiver);
		return dto;
	}
	//보낸쪽지함
	public List<MsgDTO> selectByReceiver(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = msgdao.selectByReceiver(cpage,msg_receiver);
		return dto;
	}
	//관리자쪽지함
	public List<MsgDTO> selectByAdmin(int cpage,String msg_receiver) throws Exception{
		List<MsgDTO> dto = msgdao.selectByAdmin(cpage,msg_receiver);
		return dto;
	}
	//쪽지 보기
	public MsgDTO selectBySeq(int msg_seq)throws Exception{
		MsgDTO msgdto = msgdao.selectBySeq(msg_seq);
		return msgdto;
	}
	//쪽지보내기
	public int insert(MsgDTO msgdto)throws Exception {
		return msgdao.insert(msgdto);
		
	}
	//전체쪽지 보내기
	public int msgNotice(MsgDTO mdto)throws Exception{
		return msgdao.msgNotice(mdto); 
	}
	
	//가입축하쪽지
	public int insertWelcome(String msg_receiver)throws Exception{
		int result = msgdao.insertWelcome(msg_receiver);
		return result;
	}
	//쪽지읽음처리
	public int updateView(int msg_seq)throws Exception{
		int result = msgdao.updateView(msg_seq);
		return result;
	}
	//받은사람삭제
	public int receiver_del(String[] checkList)throws Exception{

		List<String> list = new ArrayList<String>();
		for(int a=0;a<checkList.length;a++) {
			list.add(checkList[a]);
		}
		return msgdao.receiver_del(list);
	}
	//보낸사람삭제
	public int sender_del(String[] checkList)throws Exception{
		List<String> list = new ArrayList<String>();
		for(int a=0;a<checkList.length;a++) {
			list.add(checkList[a]);
		}
		return msgdao.sender_del(list);
	}
	//새로운쪽지
	public int newmsg(String msg_receiver)throws Exception{
		int result = msgdao.newmsg(msg_receiver);
		return result;
	}
	public int newMsgByAdmin(String msg_receiver)throws Exception{
		int result = msgdao.newMsgByAdmin(msg_receiver);
		return result;
	}
	public int newMsgByNick(String msg_receiver)throws Exception{
		int result = msgdao.newMsgByNick(msg_receiver);
		return result;
	}

	//관리자 쪽지함 네비
	public String Adminnavi (int cpage,String msg_receiver) throws Exception{
		String navi = msgdao.getAdminPageNav(cpage,msg_receiver);
		return navi;
	}
	//네비
	public String Sendnavi (int cpage,String msg_receiver) throws Exception{
		String navi = msgdao.getSenderPageNav(cpage,msg_receiver);
		return navi;
	}
	//네비
	public String Receivenavi (int cpage,String msg_receiver) throws Exception{
		String navi = msgdao.getReceiverPageNav(cpage,msg_receiver);
		return navi;
	}
}
