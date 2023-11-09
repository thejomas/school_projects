#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <pthread.h>

#include "job_queue.h"

int job_queue_init(struct job_queue *job_queue, int capacity) {
  job_queue->size = 0;
  job_queue->capacity = capacity;
  job_queue->jobs = calloc(capacity, sizeof(void*));
  job_queue->head = 0;
  job_queue->tail = 0;
  job_queue->is_active = 1;
  assert(pthread_mutex_init(&(job_queue->mutex), NULL) == 0);
  assert(pthread_cond_init(&(job_queue->cond), NULL) == 0);
  return 0;
}

int job_queue_destroy(struct job_queue *job_queue) {
  assert(pthread_mutex_lock(&(job_queue->mutex)) == 0);
  
  while(job_queue->size != 0) {
    assert(pthread_cond_wait(&(job_queue->cond), &(job_queue->mutex)) == 0);
  }

  job_queue->is_active = 0;
  free(job_queue->jobs);
  assert(pthread_mutex_unlock(&(job_queue->mutex)) == 0);
  assert(pthread_cond_broadcast(&(job_queue->cond)) == 0);
  return 0;
}

int job_queue_push(struct job_queue *job_queue, void *data) {
  assert(pthread_mutex_lock(&(job_queue->mutex)) == 0);
  
  while(job_queue->size == job_queue->capacity && job_queue->is_active) {
    assert(pthread_cond_wait(&(job_queue->cond), &(job_queue->mutex)) == 0);
  }
  
  if (!job_queue->is_active) {
    assert(pthread_mutex_unlock(&(job_queue->mutex)) == 0);
    return -1;
  }
  
  job_queue->jobs[job_queue->tail] = data;
  job_queue->tail = (job_queue->tail + 1) % (job_queue->capacity);
  job_queue->size++;
  
  assert(pthread_mutex_unlock(&(job_queue->mutex)) == 0);
  assert(pthread_cond_broadcast(&(job_queue->cond)) == 0);
  return 0;
}

int job_queue_pop(struct job_queue *job_queue, void **data) {
  assert(pthread_mutex_lock(&(job_queue->mutex)) == 0);
  
  while(job_queue->size == 0 && job_queue->is_active) {
    assert(pthread_cond_wait(&(job_queue->cond), &(job_queue->mutex)) == 0);
  }
  
  if (!job_queue->is_active) {
    assert(pthread_mutex_unlock(&(job_queue->mutex)) == 0);
    return -1;
  }

  *data = job_queue->jobs[job_queue->head];
  job_queue->head = (job_queue->head + 1) % (job_queue->capacity);
  job_queue->size--;
  assert(pthread_mutex_unlock(&(job_queue->mutex)) == 0);
  assert(pthread_cond_broadcast(&(job_queue->cond)) == 0);

  return 0;
}
