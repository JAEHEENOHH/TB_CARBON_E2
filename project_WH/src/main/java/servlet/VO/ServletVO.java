package servlet.VO;

import org.apache.ibatis.type.Alias;

@Alias("ServletVO")
public class ServletVO {
	private String sidonm;

	public String getSidonm() {
		return sidonm;
	}

	public void setSidonm(String sidonm) {
		this.sidonm = sidonm;
	}
}
