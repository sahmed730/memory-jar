package com.memoryjar.memoryjarbackend.service;

public class MemoryNotFoundException extends RuntimeException {

    public MemoryNotFoundException(Long id) {
        super("Memory " + id + " was not found");
    }
}
