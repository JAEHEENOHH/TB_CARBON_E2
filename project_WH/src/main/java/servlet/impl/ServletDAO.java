package servlet.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.VO.ServletVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<ServletVO> list() {
		return selectList("servlet.sidonm");
	}

	public List<ServletVO> list1() {
		return selectList("servlet.sgg_nm");
	}

	public List<ServletVO> list2(String loc1) {
		return selectList("servlet.sgg_nm");
	}
}
