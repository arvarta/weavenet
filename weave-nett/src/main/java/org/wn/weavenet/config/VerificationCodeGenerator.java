package org.wn.weavenet.config;

import java.security.SecureRandom;

public class VerificationCodeGenerator {
	private static final String CHARACTERS = "0SQD1FWG2FEG3HRJ4KTL5ZYX6CUV7BIB8NOM9P0A";
	private static final int CODE_LENGTH = 6;
	private static final SecureRandom random = new SecureRandom();
	
	public static String generateCode() {
		StringBuilder code = new StringBuilder(CODE_LENGTH);
		for(int i = 0; i < CODE_LENGTH; i++) {
			code.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
		}
		return code.toString();
	}
}
