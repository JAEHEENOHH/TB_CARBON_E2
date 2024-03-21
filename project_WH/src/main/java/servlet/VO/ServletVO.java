package servlet.VO;

import org.apache.ibatis.type.Alias;

@Alias("ServletVO")
public class ServletVO {
	private String sidonm, sgg_nm, bjd_nm;


	public String getSidonm() {
		return sidonm;
	}

	public void setSidonm(String sidonm) {
		this.sidonm = sidonm;
	}

	public String getSgg_nm() {
		return sgg_nm;
	}

	public void setSgg_nm(String sgg_nm) {
		this.sgg_nm = sgg_nm;
	}

	public String getBjd_nm() {
		return bjd_nm;
	}

	public void setBjd_nm(String bjd_nm) {
		this.bjd_nm = bjd_nm;
	}
}
