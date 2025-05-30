package org.wn.weavenet.config; // 패키지 이름은 실제 프로젝트에 맞게 유지

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.wn.weavenet.interceptor.LoginInterceptor;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${file.upload-dir.profile}")
    private String profileUploadPath; 

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        if (profileUploadPath == null || profileUploadPath.isEmpty()) {
            System.err.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            System.err.println("ERROR: '비어있음'");
            System.err.println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
            return; 
        }

        String resourceLocation = profileUploadPath.endsWith("/") ? profileUploadPath : profileUploadPath + "/";

        String finalResourceLocation = "file:" + resourceLocation;
        registry.addResourceHandler("/uploads/profile_images/**")
                .addResourceLocations(finalResourceLocation); 
    }
    
    @Autowired
    private LoginInterceptor loginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
                .addPathPatterns("/api/**") 
                .excludePathPatterns( 
                        "/api/user",                // 로그인 페이지 GET
                        "/api/user/login",          // 로그인 처리 POST
                        "/api/users",               // 회원가입 페이지 GET
                        "/api/users/signup",        // 회원가입 처리 POST
                        "/api/user/join/success",   // 회원가입 성공 페이지 POST
                        "/api/user/password",       // 비밀번호 찾기 페이지 GET & POST
                        "/api/user/password/reset", // 비밀번호 재설정 POST
                        "/css/**",                  // 정적 리소스 예외 처리
                        "/js/**",
                        "/img/**"
                );
    }
}