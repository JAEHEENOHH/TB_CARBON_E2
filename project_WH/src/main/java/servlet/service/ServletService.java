package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.VO.SggDTO;

public interface ServletService {
	String addStringTest(String str) throws Exception;
	
	List<Map<String, Object>> list();

	List<Map<String, Object>> sgglist(String sido);

	List<Map<String, Object>> bjdlist(String sgg);

	void uploadFile(List<Map<String, Object>> list);

	List<SggDTO> selectSgg(String name);

	Map<String, Object> selectGeom(String sido);

	Map<String, Object> selectB(String sgg);

	
}
