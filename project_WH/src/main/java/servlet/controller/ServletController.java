package servlet.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import servlet.VO.ServletVO;
import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String mainTest(ModelMap model,  @RequestParam(name="loc", required = false, defaultValue = "") String loc, @RequestParam(name="loc1", required = false, defaultValue = "") String loc1,@RequestParam(name="loc2", required = false, defaultValue = "") String loc2) throws Exception  {
//		System.out.println("sevController.java - mainTest()");
//		
//		String str = servletService.addStringTest("START! ");
//		model.addAttribute("resultStr", str);
		
		List<ServletVO> list = servletService.list();
		model.addAttribute("list",list);
		if(loc.length()>1) {
			loc = "sd_nm='"+loc+"'";
		} 
		model.addAttribute("loc",loc);
		
		List<ServletVO> list1 = servletService.list1();
		model.addAttribute("list1",list1);
		if(loc.length()>1) {
			loc1 = "sgg_nm='"+loc1+"'";
		} 
		model.addAttribute("loc1",loc1);
		
		List<ServletVO> list2 = servletService.list2(loc1);
		model.addAttribute("list2",list2);
		if(loc.length()>1) {
			loc2 = "bjd_nm='"+loc2+"'";
		} 
		model.addAttribute("loc2",loc2);
		
		return "main/main";
	}
	
	@RequestMapping(value = "/test.do")
	public String test() {
		return "main/test";
	}

}
