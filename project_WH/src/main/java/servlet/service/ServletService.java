package servlet.service;

import java.util.List;

import servlet.VO.ServletVO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletVO> list();
}
