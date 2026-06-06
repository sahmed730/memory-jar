package com.memoryjar.memoryjarbackend.controller;

import com.memoryjar.memoryjarbackend.service.MemoryNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(MemoryNotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(MemoryNotFoundException exception) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiError.of(HttpStatus.NOT_FOUND, exception.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(MethodArgumentNotValidException exception) {
        Map<String, String> fields = new LinkedHashMap<>();
        for (FieldError fieldError : exception.getBindingResult().getFieldErrors()) {
            fields.put(fieldError.getField(), fieldError.getDefaultMessage());
        }

        return ResponseEntity.badRequest()
                .body(ApiError.of(HttpStatus.BAD_REQUEST, "Request validation failed", fields));
    }

    public record ApiError(LocalDateTime timestamp, int status, String error, String message, Map<String, String> fields) {

        static ApiError of(HttpStatus status, String message) {
            return new ApiError(LocalDateTime.now(), status.value(), status.getReasonPhrase(), message, Map.of());
        }

        static ApiError of(HttpStatus status, String message, Map<String, String> fields) {
            return new ApiError(LocalDateTime.now(), status.value(), status.getReasonPhrase(), message, fields);
        }
    }
}
