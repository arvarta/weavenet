package org.wn.weavenet.interceptor; // 프로젝트 구조에 맞게 패키지명 변경

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.util.Arrays;
import java.util.List;

@Component 
public class LoginInterceptor implements HandlerInterceptor {

    private static final List<String> EXCLUDE_URLS = Arrays.asList(
            "/api/user",                // 로그인 페이지 GET
            "/api/user/login",          // 로그인 처리 POST
            "/api/users",               // 회원가입 페이지 GET
            "/api/users/signup",        // 회원가입 처리 POST
            "/api/user/join/success",   // 회원가입 성공 페이지 POST
            "/api/user/password",       // 비밀번호 찾기 페이지 GET & POST
            "/api/user/password/reset"  // 비밀번호 재설정 POST

    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String requestURI = request.getRequestURI();
        HttpSession session = request.getSession(false); 

        boolean isExcludeUrl = EXCLUDE_URLS.stream().anyMatch(excludeUrl -> requestURI.startsWith(request.getContextPath() + excludeUrl));

        if (isExcludeUrl) {
            return true; 
        }

        if (session == null || session.getAttribute("loginUser") == null) {
            System.out.println("[Interceptor] 세션에 저장된 로그인 유저를 찾을 수 없어 : " + requestURI);

            response.sendRedirect(request.getContextPath() + "/api/user?sessionExpired=true");
            return false; 
        }

        return true;
    }
}