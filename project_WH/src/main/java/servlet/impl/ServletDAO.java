package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.VO.SggDTO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<Map<String, Object>> selectMap() {
		return selectList("servlet.sidonm");
	}
	
	public List<Map<String, Object>> selectListSgg(String sido) {
		return selectList("servlet.sggnm", sido);
	}
	
	
	public List<Map<String, Object>> selectListbjd(String sgg) {
		return selectList("servlet.bjdnm", sgg);
	}

	public void uploadFile(List<Map<String, Object>> list) {
	      System.out.println("------------------------");
	      System.out.println(list);
	      session.insert("servlet.fileUp", list);
	   }

	public List<SggDTO> selectSgg(String name) {
		return  session.selectOne("servlet.selectSgg", name);
	}

	public Map<String, Object> selectGeom(String sido) {
		return session.selectOne("servlet.selectGeom", sido);
	}

	public Map<String, Object> selectB(String name) {
		return session.selectOne("servlet.selectB", name);
	}
	
	
	

}
