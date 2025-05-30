package org.wn.weavenet.config;

public class PagingInfo {
    private int totalCount;
    private int currentPage;
    private int pageSize;
    private int totalPage;
    private int startRow;
    private int startPage;
    private int endPage;
    private int blockSize;

    public PagingInfo(int totalCount, int currentPage, int pageSize, int blockSize) {
        this.totalCount = totalCount;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.blockSize = blockSize;

        this.totalPage = (int) Math.ceil((double) totalCount / pageSize);
        this.startRow = (currentPage - 1) * pageSize;

        this.startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        this.endPage = Math.min(startPage + blockSize - 1, totalPage);
    }

    // getters

    public int getTotalCount() { 
    	return totalCount; 
    }
    
    public int getCurrentPage() { 
    	return currentPage; 
    }
    
    public int getPageSize() { 
    	return pageSize; 
    }
    
    public int getTotalPage() {
    	return totalPage; 
    }
    
    public int getStartRow() { 
    	return startRow; 
    }
    
    public int getStartPage() { 
    	return startPage; 
    }
    
    public int getEndPage() { 
    	return endPage; 
    }
    
    public int getBlockSize() { 
    	return blockSize; 
    }
}
