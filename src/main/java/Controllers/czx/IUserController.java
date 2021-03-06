package Controllers.czx;

import Beans.czx.IRole;
import Beans.czx.IUser;
import Services.czx.IRoleService;
import Services.czx.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class IUserController {
    //依赖注入
    @Autowired
    private IUserService userService;
    @Autowired
    private IRoleService roleService;
    //查询所有状态的全体用户
    @RequestMapping(value="/findUserList.action")
    public String findUserList(String keywords, Integer userListRoleId, Model model){
        // 获取角色列表
        List<IRole> roleList = roleService.findRoleList();
        model.addAttribute("roleList", roleList);
        // 获取用户列表
        List<IUser> userList=userService.findUserList(keywords,userListRoleId);
        System.out.println("12342");
        model.addAttribute("userList", userList);
        System.out.println(userList);

        model.addAttribute("keywords", keywords);
        System.out.println(keywords);
        model.addAttribute("userListRoleId", userListRoleId);
        System.out.println(userListRoleId);
        return "czx/Iuser_list";
    }
    //转向添加用户
    @RequestMapping(value="/toAddUser.action")
    public String toAddUser(Model model){
        //获取角色列表，用于添加用户页面中的用户角色下拉列表
        List<IRole> roleList=roleService.findRoleList();
        model.addAttribute("roleList", roleList);
        return "czx/Iadd_user";
    }
    //判断登录账号是否已存在
    @RequestMapping(value = "/checkLoginName.action")
    @ResponseBody
    public IUser checkLoginName(@RequestBody IUser user, Model model) {
        IUser checkUser = userService.getUserByLoginName(user.getLoginName());
        if (checkUser!=null) {
            //登录账号已存在
            return checkUser;
        }else{
            checkUser=new IUser();
            checkUser.setUserId(0);
            return checkUser;
        }
    }
    //添加用户
    @RequestMapping(value = "/addUser.action", method = RequestMethod.POST)
    public String addUser(IUser user, Model model) {
        // 获取角色列表
        List<IRole> roleList = roleService.findRoleList();
        model.addAttribute("roleList", roleList);
        model.addAttribute("user", user);
        //检查登录账号是否已存在
        IUser checkUser = userService.getUserByLoginName(user.getLoginName());
        if (checkUser!=null) {
            // 登录账号已存在，重新转回添加用户页面
            model.addAttribute("checkUserLoginNameMsg", "登录账号已存在，请重新输入");
            return "czx/Iadd_user";
        }else{
            // 登录账号可用
            Date date = new Date();
            user.setRegisterTime(date);
            //默认设置用户为启用状态"2"
            user.setStatus("2");
            //调用UserService实例中的添加用户方法
            int rows = userService.addUser(user);
            if (rows > 0) {
                // 添加成功，转向用户列表页面
                return "redirect:findUserList.action";
            } else {
                // 添加失败，重新转回添加用户页面
                return "czx/Iadd_user";
            }
        }
    }
    // 转向修改用户页面
    @RequestMapping(value = "/toEditUser.action")
    public String toEditUser(Integer userId, Model model) {
        //通过userId获取用户
        IUser user = userService.getUserByUserId(userId);
        if (user != null) {
            model.addAttribute("user", user);
            // 获取角色列表
            List<IRole> roleList = roleService.findRoleList();
            model.addAttribute("roleList", roleList);
            return "czx/Iedit_user";
        }else{
            return "redirect:findUserList.action";
        }
    }
    //修改用户
    @RequestMapping(value = "/editUser.action", method = RequestMethod.POST)
    public String editUser(IUser user, Model model) {
        // 获取角色列表
        Date date = new Date();
        user.setRegisterTime(date);
        // 默认设置用户为启用状态"2"
        user.setStatus("2");
        int rows = userService.editUser(user);
        if (rows > 0) {
            // 添加成功，转向用户列表页面
            return "redirect:findUserList.action";
        } else {
            List<IRole> roleList = roleService.findRoleList();
            model.addAttribute("roleList", roleList);
            model.addAttribute("user", user);
            // 修改失败，转回修改用户页面
            return "czx/Iedit_user";
        }
    }
    //删除用户（前台页面中通过ajax方式调用此方法）
    @RequestMapping(value = "/delUser.action")
    @ResponseBody
    public IUser delUser(@RequestBody IUser user, Model model) {
        int rows = userService.delUser(user.getUserId());
        if (rows>0) {
            return user;
        }else{
            //此处设置userId为0，只是作为操作失败的标记用
            user.setUserId(0);
            return user;
        }
    }
    //禁用用户（更新status字段值 为'3'，前台页面中通过ajax方式调用此方法）
    @RequestMapping(value = "/disableUser.action")
    @ResponseBody
    public IUser disableUser(@RequestBody IUser user, Model model) {
        int rows = userService.setUserStatus(user);
        if (rows>0) {
            return user;
        }else{
            //此处设置userId为0，只是作为操作失败的标记用
            user.setUserId(0);
            return user;
        }
    }
    //启用用户（更新status字段值 为'2'，前台页面中通过ajax方式调用此方法）
    @RequestMapping(value = "/enableUser.action")
    @ResponseBody
    public IUser enableUser(@RequestBody IUser user, Model model) {
        int rows = userService.setUserStatus(user);
        if (rows>0) {
            return user;
        }else{
            //此处设置userId为0，只是作为操作失败的标记用
            user.setUserId(0);
            return user;
        }
    }
    //登录页跳转
    @RequestMapping(value="/loginpage.action")
    public String loginPage(HttpServletRequest request){
        return "czx/Ilogin";
    }
    //主页面跳转
    @RequestMapping(value="/mainpage.action")
    public String mainPage(HttpServletRequest request){
        return "czx/Ifirst";
    }
    //用户登录
    @RequestMapping(value="/login.action")
    public String login(String loginName, String password, Model model, HttpSession session){
        //通过用户名和密码查询用户
        IUser user=userService.findUser(loginName, password);
        if(user!=null){
            if (user.getStatus().equals("2")) {
                //用户被启用时，允许登录到后台
                session.setAttribute("login_user", user);
                return "czx/Imain";
            } else {
                //账号未启用或被禁用时，不允许登录到后台
                model.addAttribute("msg", "账号未启用或被禁用，请联系管理员！");
                return "czx/Ilogin";
            }
        }
        //账号或密码错误时，不允许登录到后台
        model.addAttribute("msg","账号或密码错误，请重新登录！");
        return "czx/Ilogin";
    }
    //退出登录
    @RequestMapping(value="/logout.action")
    public String logout(HttpSession session){
        //清空session
        session.invalidate();
        return "czx/Ilogin";
    }
}
