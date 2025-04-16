#include "os.h"

typedef struct MallocBlock {
    size_t size;              // 4 字节（RV32）
    struct MallocBlock *next; // 4 字节
    int free;                 // 4 字节
}MallocBlock;

#define BLOCK_SIZE sizeof(MallocBlock)

MallocBlock *freelist = NULL; //维护的空闲链表
void *malloc_heap = NULL; //记录malloc开始的空间


void malloc_init(){
    malloc_heap = page_alloc(16); //分配16页
    freelist = malloc_heap;
    freelist->size = PAGE_SIZE * 16 - BLOCK_SIZE; //这里的size是实际能够分配的大小，除去了header的大小
    freelist->free = 1;
    freelist->next = NULL;
    printf("malloc init success\n");
    printf("malloc_heap: %p\n", malloc_heap);
    printf("freelist: %p\n", freelist);
}

void print_freelist() {
    printf("=== freelist dump ===\n");
    MallocBlock *curr = freelist;
    int i = 0;
    while (curr) {
        printf("Block %d @header %p | BLOCK_SIZE: %d  Address: %p  Size: %d  Free: %d  Next: %p\n",
            i++, curr, BLOCK_SIZE, (void *)((char *)curr + BLOCK_SIZE), curr->size, curr->free, curr->next);        
        curr = curr->next;
    }
    printf("=====================\n");
}

void *malloc(size_t size){
    MallocBlock *curr = freelist;
    while(curr){ //因为是链表形式的，所以每次都要从头开始找，直到找到合适的块
        if (curr->free)
        {
            if(curr->size >= size){
                if (curr->size - size >= BLOCK_SIZE + 4) //如果还有剩余空间（注意！这里的剩余空间需要包含一个header和一个字节（因为malloc的精度是一个字节）的大小） 
                { 
                    MallocBlock *new = (MallocBlock *)((char *)curr + BLOCK_SIZE + size);
                    //这里进行字节转化是因为curr是一个指向MallocBlock的指针，不这么做它加上size会直接跳过相应的块而不是字节
                    new->size = curr->size - size - BLOCK_SIZE;
                    new->free = 1;
                    new->next = curr->next;
                    curr->next = new;
                    printf("split block\n");
                    printf("new block: %p\n", curr->next);
                }
                curr->free = 0;
                curr->size = size;
                print_freelist();
                return (void *)((char *)curr + BLOCK_SIZE); //返回的时候返回实际分配的地址的开始，而不是返回header的地址
            }
        }
        curr = curr->next;
    }
    printf("malloc failed\n");
    return NULL;
}

void merge(){
    MallocBlock *curr = freelist;
    while(curr->next){
        if (curr->free && curr->next->free)
        {
            curr->size += curr->next->size + BLOCK_SIZE;
            curr->next = curr->next->next;
        }
        curr = curr->next;
    }
}

void free(void *ptr){
    MallocBlock *block = (MallocBlock *)((char *)ptr - BLOCK_SIZE);
    block->free = 1;
    merge();
}



void test_malloc(){
    printf("malloc test\n");
    void *ptr1 = malloc(10);
    printf("ptr1: %p\n", ptr1);
    void *ptr2 = malloc(20);
    printf("ptr2: %p\n", ptr2);
    void *ptr3 = malloc(30);
    printf("ptr3: %p\n", ptr3);
    free(ptr1);
    print_freelist();
    free(ptr2);
    print_freelist();
}