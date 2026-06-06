package com.memoryjar.memoryjarbackend.controller;

import com.memoryjar.memoryjarbackend.model.Memory;
import com.memoryjar.memoryjarbackend.service.MemoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/memories")
@RequiredArgsConstructor
public class MemoryController {

    private final MemoryService memoryService;

    @PostMapping
    public ResponseEntity<Memory> createMemory(@Valid @RequestBody Memory memory) {
        return ResponseEntity.status(HttpStatus.CREATED).body(memoryService.createMemory(memory));
    }

    @GetMapping
    public ResponseEntity<List<Memory>> getAllMemories() {
        return ResponseEntity.ok(memoryService.getAllMemories());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Memory> getMemoryById(@PathVariable Long id) {
        return memoryService.getMemoryById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMemory(@PathVariable Long id) {
        memoryService.deleteMemory(id);
        return ResponseEntity.noContent().build();
    }
}
