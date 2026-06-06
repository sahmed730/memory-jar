package com.memoryjar.memoryjarbackend.config;

import com.memoryjar.memoryjarbackend.service.MemoryDeliveryJob;
import org.quartz.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class QuartzConfig {

    @Bean
    public JobDetail memoryDeliveryJobDetail() {
        return JobBuilder.newJob(MemoryDeliveryJob.class)
                .withIdentity("memoryDeliveryJob")
                .storeDurably()
                .build();
    }

    @Bean
    public Trigger memoryDeliveryJobTrigger() {
        SimpleScheduleBuilder scheduleBuilder = SimpleScheduleBuilder.simpleSchedule()
                .withIntervalInMinutes(1)
                .repeatForever();

        return TriggerBuilder.newTrigger()
                .forJob(memoryDeliveryJobDetail())
                .withIdentity("memoryDeliveryTrigger")
                .withSchedule(scheduleBuilder)
                .build();
    }
}
