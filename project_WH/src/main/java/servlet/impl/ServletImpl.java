package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService; 

@Service("servletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}
	
	@Override
	public List<Map<String, Object>> list() {
		return dao.selectMap();
	}

	@Override
	public List<Map<String, Object>> sgglist(String sido) {
		return dao.selectListSgg(sido);
	}

	@Override
	public List<Map<String, Object>> bjdlist(String sgg) {
		return dao.selectListbjd(sgg);
	}

	@Override
	   public void uploadFile(List<Map<String, Object>> list) {
	         dao.uploadFile(list);
	   }


}
