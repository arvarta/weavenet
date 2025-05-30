package org.wn.weavenet.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.wn.weavenet.service.EmailService;
import org.wn.weavenet.service.EmployeeService;
import org.wn.weavenet.service.UserService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/api")
public class EmailSenderController {

    @Autowired
    private UserService userService;

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private EmailService emailService;

    /** 사원번호로 이메일 불러오기 */
    @GetMapping("/users/email")
    @ResponseBody
    public String getEmailByEmployeeNumber(@RequestParam("number") String eNum) {
        String eEmail = employeeService.findEEmailByENum(eNum);
        return (eEmail != null) ? eEmail : "";
    }

    /** 이메일 인증 코드 발송 */
    @PostMapping("/users/email/send")
    @ResponseBody
    public Map<String, Object> sendVerificationEmail(@RequestParam String eNum, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            String eEmail = employeeService.findEEmailByENum(eNum);
            if (eEmail == null) {
                response.put("success", false);
                response.put("message", "해당 사원번호에 해당하는 이메일이 없습니다.");
                return response;
            }

            emailService.sendVerification(eEmail);
            session.setAttribute("signupEmail", eEmail);

            response.put("success", true);
            response.put("message", "인증 코드가 이메일로 발송되었습니다.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "이메일 전송 중 오류 발생");
        }
        return response;
    }

    /** 이메일 인증 코드 검증 및 인증상태 저장 */
    @GetMapping("/users/email/verify")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyEmailCode(
            @RequestParam String eEmail,
            @RequestParam String code,
            HttpSession session) {

        boolean isVerified = emailService.verifyCode(eEmail, code);
        Map<String, Object> response = new HashMap<>();
        response.put("verified", isVerified);

        if (isVerified) {
            // 인증 성공 -> Redis에 상태 저장 완료됨 (EmailService 내부)
            session.setAttribute("emailVerified", true);
            session.setAttribute("signupEmail", eEmail);
            response.put("message", "이메일 인증 성공");
        } else {
            response.put("message", "이메일 인증 실패 (코드 불일치 또는 만료)");
        }

        return ResponseEntity.ok(response);
    }

    @GetMapping("/users/email/exists") 
    @ResponseBody
    public Map<String, Object> checkEmailExists(@RequestParam String email) {
        Map<String, Object> response = new HashMap<>();
        boolean emailExists = userService.existsByEmail(email); 

        response.put("exists", emailExists);
        if (emailExists) {
            response.put("message", "이미 가입된 이메일입니다. 로그인 페이지로 이동하시겠습니까?");
        } else {
            response.put("message", "사용 가능한 이메일입니다. 인증을 진행해주세요.");
        }
        return response;
    }
}
