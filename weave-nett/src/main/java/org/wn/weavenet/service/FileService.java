package org.wn.weavenet.service;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.slf4j.Logger; // 로깅을 위해 추가
import org.slf4j.LoggerFactory; // 로깅을 위해 추가
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 트랜잭션 추가
import org.springframework.web.multipart.MultipartFile;
import org.wn.weavenet.entity.Pile;
import org.wn.weavenet.entity.Post;
import org.wn.weavenet.repository.FilesRepository;

@Service
public class FileService {

    private static final Logger logger = LoggerFactory.getLogger(FileService.class); // 로거 선언

    @Autowired
    private FilesRepository filesRepository;

    @Value("${file.upload-dir}")
    private String uploadDir;

    @Transactional // 여러 파일 저장 시 트랜잭션 관리
    public List<Pile> storeFiles(List<MultipartFile> multipartFiles, Post post) throws IOException {
        List<Pile> storedFileList = new ArrayList<>();
        File uploadPathFile = new File(uploadDir);

        if (!uploadPathFile.exists()) {
            uploadPathFile.mkdirs();
        }

        if (multipartFiles == null) { // multipartFiles가 null일 경우 처리
             return storedFileList;
        }

        for (MultipartFile file : multipartFiles) {
            if (file == null || file.isEmpty()) {
                continue;
            }
            String originalFileName = file.getOriginalFilename();
            if (originalFileName == null || originalFileName.trim().isEmpty()) {
                continue;
            }

            String storedFileName = createStoredFileName(originalFileName);
            String filePathString = uploadDir + File.separator + storedFileName;

            Path targetLocation = Paths.get(filePathString);
            java.nio.file.Files.copy(file.getInputStream(), targetLocation);

            Pile fileEntity = new Pile();
            fileEntity.setfName(originalFileName);
            fileEntity.setfSize((Long) file.getSize()); // Pile의 fSize가 int인 경우
            fileEntity.setpNum(post.getpNum());
            fileEntity.setStoredFileName(storedFileName);

            storedFileList.add(filesRepository.save(fileEntity));
        }
        return storedFileList;
    }

    @Transactional // 파일 삭제 시 트랜잭션 관리
    public void deleteFile(Long fileId) {
        Optional<Pile> pileOptional = filesRepository.findById(fileId);
        if (pileOptional.isPresent()) {
            Pile pile = pileOptional.get();
            try {
                Path filePath = Paths.get(uploadDir).resolve(pile.getStoredFileName()).normalize();
                java.nio.file.Files.deleteIfExists(filePath);
                logger.info("Successfully deleted physical file: {}", pile.getStoredFileName());
            } catch (IOException e) {
                logger.error("Failed to delete physical file: {} - {}", pile.getStoredFileName(), e.getMessage());
                // 물리적 파일 삭제 실패해도 DB 레코드는 삭제 시도 (또는 정책에 따라 다름)
            }
            filesRepository.deleteById(fileId);
            logger.info("Successfully deleted file record from DB: ID {}", fileId);
        } else {
            logger.warn("File record not found in DB for ID: {}", fileId);
        }
    }


    public List<Pile> getFilesByPost(Long pNum) {
        return filesRepository.findByPNum(pNum);
    }

    public Optional<Pile> getFileById(Long fileId) {
        return filesRepository.findById(fileId);
    }

    public Resource loadFileAsResource(String storedFileName) throws MalformedURLException {
        Path filePath = Paths.get(uploadDir).resolve(storedFileName).normalize();
        Resource resource = new UrlResource(filePath.toUri());
        if (resource.exists() && resource.isReadable()) {
            return resource;
        } else {
            throw new RuntimeException("파일을 찾을 수 없거나 읽을 수 없습니다: " + storedFileName);
        }
    }

    private String createStoredFileName(String originalFileName) {
        String ext = extractExt(originalFileName);
        String uuid = UUID.randomUUID().toString();
        return uuid + (ext.isEmpty() ? "" : "." + ext);
    }

    private String extractExt(String originalFileName) {
        try {
            int pos = originalFileName.lastIndexOf(".");
            if (pos == -1 || pos == originalFileName.length() - 1) {
                return "";
            }
            return originalFileName.substring(pos + 1);
        } catch (Exception e) {
            return "";
        }
    }
}