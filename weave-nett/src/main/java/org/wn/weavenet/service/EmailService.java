package org.wn.weavenet.service;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.wn.weavenet.config.VerificationCodeGenerator;
import org.wn.weavenet.entity.User;
import org.wn.weavenet.repository.UserRepository;

@Service
public class EmailService {

    private static final long CODE_EXPIRE_SECONDS = 300;  // 5분
    private static final long AUTH_STATUS_EXPIRE_SECONDS = 600;  // 인증상태 TTL: 10분
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private StringRedisTemplate redisTemplate;

    // 인증번호 전송
    public void sendVerification(String toEmail) {
        String code = VerificationCodeGenerator.generateCode();
        redisTemplate.opsForValue().set("authCode:" + toEmail, code, CODE_EXPIRE_SECONDS, TimeUnit.SECONDS);
        sendEmail(toEmail, code);
        System.out.println("인증번호 전송 - 대상: " + toEmail + ", 인증코드: " + code);
    }

    // 메일 전송 로직
    private void sendEmail(String toEmail, String code) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[WeaveNet 회원가입 인증 코드]");
        message.setText("귀하의 인증 번호는 " + code + "입니다.\n5분 내로 인증 코드를 기입해주세요.");
        message.setFrom("your_email@gmail.com");
        mailSender.send(message);
    }

    // 인증코드 검증 및 성공 상태 저장
    public boolean verifyCode(String email, String inputCode) {
        String storedCode = redisTemplate.opsForValue().get("authCode:" + email);
        System.out.println("[DEBUG] Redis 저장된 인증코드: " + storedCode);
        System.out.println("[DEBUG] 입력된 인증코드: " + inputCode);

        if (storedCode != null && storedCode.equals(inputCode)) {
            redisTemplate.delete("authCode:" + email);
            redisTemplate.opsForValue().set("authSuccess:" + email, "true", AUTH_STATUS_EXPIRE_SECONDS, TimeUnit.SECONDS);
            System.out.println("[INFO] 인증 성공 - 인증코드 삭제 및 인증상태 저장");
            return true;
        }

        System.out.println("[WARN] 인증 실패 - 인증코드 불일치 또는 만료");
        return false;
    }

    // 인증 성공 여부 확인
    public boolean isEmailVerified(String email) {
        String result = redisTemplate.opsForValue().get("authSuccess:" + email);
        return "true".equals(result);
    }

    // 테스트용 일반 메일 발송 메서드 (보류 혹은 구현 예정)
    public void sendMail(String toEmail, String subject, String content) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject(subject);
        message.setText(content);
//        message.setFrom("w05256442@gmail.com");
        try {
        	mailSender.send(message);
        	System.out.println("이메일 발송 요청 성공 : 수신자 : " + toEmail);
        } catch (MailException e) {
        	System.out.println("이메일 발송 실패: 수산자={}, 오류={}" + toEmail + e.getMessage());
        }
    }

    // 인증 상태 초기화 (회원가입 완료 후)
    public void clearAuth(String email) {
        redisTemplate.delete("authSuccess:" + email);
        redisTemplate.delete("authCode:" + email);
        System.out.println("[INFO] 인증 상태 초기화 완료: " + email);
    }
    
    public boolean sendTemporaryPassword(String uEmail) {
        Optional<User> userOpt = userRepository.findByUEmail(uEmail);
        if (!userOpt.isPresent()) {
            return false;
        }

        User user = userOpt.get();
        String tempPassword = generateTempPassword();
        user.setuPassword(passwordEncoder.encode(tempPassword));
        userRepository.save(user);

        sendTempPasswordEmail(uEmail, tempPassword);
        System.out.println("[INFO] 임시 비밀번호 발송 완료 - 대상: " + uEmail);
        return true;
    }

    /** 임시 비밀번호 메일 내용 구성 및 발송 */
    private void sendTempPasswordEmail(String toEmail, String tempPassword) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("[WeaveNet 임시 비밀번호 안내]");
        message.setText("임시 비밀번호: " + tempPassword + "\n로그인 후 반드시 비밀번호를 변경해 주세요.");
        message.setFrom("w05256442@gmail.com");
        mailSender.send(message);
    }

    /** 임시 비밀번호 생성 (UUID 일부 사용) */
    private String generateTempPassword() {
        return UUID.randomUUID().toString().substring(0, 10); // 예: 10자리
    }
    
    /** 비밀번호 재설정 */
    public boolean resetPassword(String uEmail, String newPassword) {
        Optional<User> userOpt = userRepository.findByUEmail(uEmail);
        if (!userOpt.isPresent()) return false;

        User user = userOpt.get();
        user.setuPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        System.out.println("[INFO] 비밀번호 재설정 완료 - " + uEmail);
        return true;
    }
}