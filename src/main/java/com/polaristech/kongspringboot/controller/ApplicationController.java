package com.polaristech.kongspringboot.controller;

import com.polaristech.kongspringboot.pojo.Order;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;


@RestController
@RequestMapping("/api")
public class ApplicationController {

    @GetMapping("/public")
    public ResponseEntity<String> getPublicString() {
        return ResponseEntity.ok("It is public.\n");
    }

    @GetMapping("/private")
    public ResponseEntity<Order> getPrivateString(HttpServletRequest request) {
//        String username = request.getHeader("X-Credential-Username");

        RestTemplate rest = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();

        System.setProperty("sun.net.http.allowRestrictedHeaders", "true");
        headers.add("Host", "kong.springboot2");

//        return rest.exchange("http://kong-springboot2.kong-api.svc:8090/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
//        return rest.exchange("http://localhost:8000/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
        return rest.exchange("http://kong-proxy.kong-api.svc.cluster.local:80/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
//        return rest.exchange("http://localhost:8000/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
//        return rest.exchange("http://localhost:8090/api/order", HttpMethod.GET, new HttpEntity<Object>(headers), Order.class);
    }

}
