#include "os.h"

typedef struct MallocBlock {
    size_t size; //大小
    int free; //是否空闲
    struct MallocBlock *next; //下一块
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

void *malloc(size_t size){
    MallocBlock *curr = freelist;
    while(curr){ //因为是链表形式的，所以每次都要从头开始找，直到找到合适的块
        if (curr->free)
        {
            if(curr->size >= size){
                if (curr->size - size >= BLOCK_SIZE + 8) //如果还有剩余空间（注意！这里的剩余空间需要包含一个header和一个字节（因为malloc的精度是一个字节）的大小） 
                { 
                    MallocBlock *new = (MallocBlock *)((char *)curr + BLOCK_SIZE + size);
                    //这里进行字节转化是因为curr是一个指向MallocBlock的指针，不这么做它加上size会直接跳过相应的块而不是字节
                    new->size = curr->size - size - BLOCK_SIZE;
                    new->free = 1;
                    new->next = NULL;
                    curr->next = new;
                }
                curr->free = 0;
                curr->size = size;
                return (void *)(curr + BLOCK_SIZE); //返回的时候返回实际分配的地址的开始，而不是返回header的地址
            }
        }
        curr = curr->next;
    }
    printf("malloc failed\n");
    return NULL;
}

void free(void *ptr){
    MallocBlock *curr = freelist;
    MallocBlock *prev = NULL;
    while(curr){
        if (curr->next == (MallocBlock *)ptr - BLOCK_SIZE)
        {
            prev = curr;
            prev->next = curr->next->next;
            curr->next->free = 1;
            curr->next->next = NULL;
            break;
        }
        
    }
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
}