package com.memoryjar.memoryjarbackend.service;

import lombok.extern.slf4j.Slf4j;
import org.quartz.DisallowConcurrentExecution;
import org.quartz.JobExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.quartz.QuartzJobBean;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Slf4j
@DisallowConcurrentExecution
public class MemoryDeliveryJob extends QuartzJobBean {

    @Autowired
    private MemoryService memoryService;

    @Override
    protected void executeInternal(JobExecutionContext context) {
        int processed = memoryService.deliverDueMemories();
        log.info("Memory delivery job processed {} due memories at {}", processed, LocalDateTime.now());
    }
}
