package org.wn.weavenet.config;

public class PagingUtil {

    public static PagingInfo create(int totalCount, int currentPage) {
        return new PagingInfo(totalCount, currentPage, 10, 10); // 기본 페이지당 10개, 블럭당 10개 페이지
    }

    public static PagingInfo create(int totalCount, int currentPage, int pageSize, int blockSize) {
        return new PagingInfo(totalCount, currentPage, pageSize, blockSize);
    }
}
