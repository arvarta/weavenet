package org.wn.weavenet.dto;

import org.springframework.data.domain.Page;

public class PagingInfo {
    private int currentPage;
    private int startPage;
    private int endPage;
    private int totalPage;

    public PagingInfo(Page<?> page) {
        this.currentPage = page.getNumber() + 1;  // 0부터 시작하므로 +1
        this.totalPage = page.getTotalPages();

        int blockSize = 10; // 한번에 보여줄 페이지 번호 개수
        this.startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        this.endPage = Math.min(startPage + blockSize - 1, totalPage);
    }

    // Getter들
    public int getCurrentPage() { return currentPage; }
    public int getStartPage() { return startPage; }
    public int getEndPage() { return endPage; }
    public int getTotalPage() { return totalPage; }
}
