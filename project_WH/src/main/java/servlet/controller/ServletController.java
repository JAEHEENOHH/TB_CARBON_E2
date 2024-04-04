package servlet.controller; 

import java.util.HashMap; 
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.VO.SggDTO;
import servlet.service.ServletService;

@Controller
public class ServletController {
	   @Resource(name = "servletService")
	   private ServletService servletService;
   
   @RequestMapping(value = "/main.do", method = RequestMethod.GET)
   public String mainTest(ModelMap model, @RequestParam(name="sido", required = false, defaultValue = "") String sido) throws Exception {
      System.out.println("sevController.java - mainTest()");
      
      String str = servletService.addStringTest("START! ");
      model.addAttribute("resultStr", str);
      
      List<Map<String, Object>> sdlist = servletService.list();
      System.out.println(sdlist);
      model.addAttribute("sdlist", sdlist);
      model.addAttribute("sido", sido);
      System.out.println(sido);
      System.out.println("sido 통과");
      return "main/main";
   }
   
   @ResponseBody
   @RequestMapping(value = "/sgg.do", method = RequestMethod.POST)
   public Map<String, Object> sggTest(@RequestParam(name="sido", required = false, defaultValue = "" ) String sido) {
    
	  List<Map<String, Object>> sgglist = servletService.sgglist(sido);
      
      Map<String, Object> geom = servletService.selectGeom(sido);
      
      Map<String,Object> map = new HashMap<String, Object>();
      map.put("sgglist", sgglist);
      map.put("geom", geom);
      
      System.out.println(sido);
      return map;
   }
   
   @RequestMapping(value = "/bjd.do", method = RequestMethod.POST)
   public @ResponseBody Map<String, Object> bjdTest(@RequestParam(name="sgg", required = false, defaultValue = "" ) String sgg) {
      
      List<Map<String, Object>> bjdlist = servletService.bjdlist(sgg); 
      
      Map<String, Object> geom = servletService.selectB(sgg);
      
      Map<String,Object> map = new HashMap<String, Object>();
      map.put("bjdlist", bjdlist); 
      map.put("geom", geom); 
      
      System.out.println(sgg);
      System.out.println("bjd 통과");
      return map;
   }
   
   @RequestMapping(value = "/legend.do", method = RequestMethod.POST)
   @ResponseBody
   public Map<String, Object> legend(@RequestParam("legend") String legend) {
       Map<String, Object> response = new HashMap<>();
       System.out.println("재희 출력 화면" + response);
       return response;
   }
	
    @RequestMapping(value="/test.do")
    public String testPage() {
        return "main/test"; // test.jsp 파일을 찾아서 반환합니다.
    }
}


	