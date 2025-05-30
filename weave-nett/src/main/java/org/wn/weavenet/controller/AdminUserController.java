package org.wn.weavenet.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.wn.weavenet.dto.EmployeeAddRequest;
import org.wn.weavenet.dto.EmployeeDto;
import org.wn.weavenet.dto.UserRoleUpdateRequest;
import org.wn.weavenet.entity.Board;
import org.wn.weavenet.entity.Department;
import org.wn.weavenet.entity.Employee;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.enums.UserAuth;
import org.wn.weavenet.enums.UserRank;
import org.wn.weavenet.repository.BoardRepository;
import org.wn.weavenet.repository.DepartmentRepository;
import org.wn.weavenet.repository.EmployeeRepository;
import org.wn.weavenet.service.AdminUserService;
import org.wn.weavenet.service.BoardService;

@Controller
@RequestMapping("/api/admin")
public class AdminUserController {

    @Autowired
    private AdminUserService adminUserService;

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private DepartmentRepository departmentRepository;
    
    @Autowired
    private BoardService bs;
    
    @Autowired
    private BoardRepository br;

    @GetMapping("/user")
    public String getUserList(Model model, Long bNum) {
        List<User> users = adminUserService.getUserList();
        List<EmployeeDto> empDtos = new ArrayList<EmployeeDto>();

        for (User user : users) {
            if (UserAuth.SUPER_ADMIN.equals(user.getuAuth())) {
                continue;
            }

            Employee employee = employeeRepository.findByENum(user.geteNum());
            Department department = null;
            if (employee != null && employee.getDeptNum() != null) {
                department = departmentRepository.findById(employee.getDeptNum()).orElse(null);
            }

            EmployeeDto empDto = new EmployeeDto();
            if (employee != null) {
                empDto.seteName(employee.geteName());
            }
            empDto.setuNum(user.getuNum());
            empDto.setuStatus(user.getuStatus() != null ? user.getuStatus().name() : "");
            empDto.setDeptName(department != null ? department.getDeptName() : "");
            empDto.setuAuth(user.getuAuth() != null ? user.getuAuth().name() : "USER");
            empDto.setuRank(user.getuRank() != null ? user.getuRank().name() : "GENERAL");

            empDtos.add(empDto);
        }
        
        List<Board> boards = bs.getActiveBoards();
        
        model.addAttribute("empDtos", empDtos);

        List<String> userAuthList = Arrays.stream(UserAuth.values())
                                          .map(Enum::name)
                                          .collect(Collectors.toList());
        List<String> userRankList = Arrays.stream(UserRank.values())
                                          .map(Enum::name)
                                          .collect(Collectors.toList());

        model.addAttribute("userAuthList", userAuthList);
        model.addAttribute("userRankList", userRankList);
        model.addAttribute("allUserAuthValues", UserAuth.values());
        model.addAttribute("allUserRankValues", UserRank.values());
        model.addAttribute("boards", boards);

        return "pages/request_manage";
    }

    @GetMapping("/user/detail/{uNum}")
    public String getUserDetailForModal(@PathVariable Long uNum, Model model) {
        User user = adminUserService.findUserByUNum(uNum);
        System.out.println("상세정보 사용자 번호 : " + uNum);
        if (user == null) {
            model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
            System.out.println("[ERROR] 사용자 정보를 찾을 수 없습니다"); /** 굳이 구현 안함 */
//            return "/pages/fragment/userDetailError";
        }

        Employee employee = employeeRepository.findByENum(user.geteNum());
        Department department = null;
        if (employee != null && employee.getDeptNum() != null) {
            department = departmentRepository.findById(employee.getDeptNum()).orElse(null);
        }

        EmployeeDto empDetailDto = new EmployeeDto();
        if (employee != null) {
            empDetailDto.seteName(employee.geteName());
            empDetailDto.seteNum(employee.geteNum());
            empDetailDto.seteEmail(employee.geteEmail());
            empDetailDto.setDeptName(department != null ? department.getDeptName() : "N/A");
            empDetailDto.seteGrade(employee.geteGrade());
            empDetailDto.setePosition(employee.getePosition());
            empDetailDto.seteJoinDate(employee.geteJoinDate());
            empDetailDto.seteAddress(employee.geteAddress());
        }
        empDetailDto.setuNum(user.getuNum());
        empDetailDto.setuAuth(user.getuAuth() != null ? user.getuAuth().name() : "N/A");
        empDetailDto.setuRank(user.getuRank() != null ? user.getuRank().name() : "N/A");
        empDetailDto.setuStatus(user.getuStatus() != null ? user.getuStatus().name() : "N/A");

        model.addAttribute("empDto", empDetailDto);
        return "/pages/userDetail";
    }
    
    /** 사원 추가 기능 관련 메서드 */
    @PostMapping("/employees")
    public String addEmployee(@ModelAttribute EmployeeAddRequest employeeAddRequest, RedirectAttributes redirectAttributes) {
        try {
            Employee newEmployee = adminUserService.addEmployee(employeeAddRequest);
            redirectAttributes.addFlashAttribute("alertMsg", "사원 " + newEmployee.geteName() + "이(가) 성공적으로 추가되었습니다.");
        } catch (IllegalArgumentException e) {
            System.err.println("사원 추가 실패: " + e.getMessage());
            redirectAttributes.addFlashAttribute("alertMsg", "사원 추가 실패: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("사원 추가 중 오류 발생: " + e.getMessage());
            redirectAttributes.addFlashAttribute("alertMsg", "사원 추가 중 알 수 없는 오류가 발생했습니다.");
        }
        return "redirect:/api/admin/user";
    }
    
    @GetMapping("/departments") 
    @ResponseBody 
    public List<Department> getDepartments() {
        return departmentRepository.findAll();
    }
    
    @PostMapping("/user/{uNum}/role")
    public String updateRole(@PathVariable Long uNum, 
                             @ModelAttribute UserRoleUpdateRequest request, 
                             RedirectAttributes redirectAttributes) {
        if (request.getuAuth() == null || request.getuRank() == null) {
            redirectAttributes.addFlashAttribute("alertMsg", "권한과 등급을 모두 선택해주세요.");
            return "redirect:/api/admin/user";
        }
        
        try {
            adminUserService.updateUserRole(uNum, request);
//            redirectAttributes.addFlashAttribute("alertMsg", "사용자 역할이 성공적으로 업데이트되었습니다.");
        } catch (Exception e) {
            System.err.println("역할 업데이트 실패: " + e.getMessage());
            redirectAttributes.addFlashAttribute("alertMsg", "역할 업데이트 중 오류가 발생했습니다.");
        }
        return "redirect:/api/admin/user";
    }

    @PostMapping("/user/{uNum}")
    public String approveUser(@PathVariable Long uNum, RedirectAttributes redirectAttributes) {
        adminUserService.approveUser(uNum);
        return "redirect:/api/admin/user";
    }

    @PostMapping("/user/{uNum}/rejected")
    public String rejectUser(@PathVariable Long uNum, RedirectAttributes redirectAttributes) {
        adminUserService.permanentlyDeleteUser(uNum);
        redirectAttributes.addFlashAttribute("alertMsg", "사용자 가입이 거부되었습니다.");
        return "redirect:/api/admin/user";
    }

    @PostMapping("/user/{uNum}/delete")
    public String permanentlyDeleteUser(@PathVariable Long uNum, RedirectAttributes redirectAttributes) {
    	adminUserService.permanentlyDeleteUser(uNum);
    	redirectAttributes.addFlashAttribute("alertMsg", "사용자가 영구 삭제되었습니다.");
    	return "redirect:/api/admin/user";
    }
    
    @PostMapping("/user/{uNum}/inactive")
    public String deleteUser(@PathVariable Long uNum, RedirectAttributes redirectAttributes) {
        adminUserService.markUserAsDeleted(uNum);
        redirectAttributes.addFlashAttribute("alertMsg", "사용자가 삭제 처리되었습니다 (비활성).");
        return "redirect:/api/admin/user";
    }

    @PostMapping("/user/{uNum}/restore")
    public String restoreUser(@PathVariable Long uNum, RedirectAttributes redirectAttributes) {
        adminUserService.restoreUser(uNum);
//        redirectAttributes.addFlashAttribute("alertMsg", "사용자가 복구되었습니다.");
        return "redirect:/api/admin/user";
    }

}
