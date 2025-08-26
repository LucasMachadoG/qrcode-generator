package com.lucasgmachado.qrcode.generator.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lucasgmachado.qrcode.generator.dtos.QrCodeGenerateRequest;
import com.lucasgmachado.qrcode.generator.dtos.QrCodeGenerateResponse;
import com.lucasgmachado.qrcode.generator.services.QrCodeGeneratorService;

@RestController
@RequestMapping("/qrcode")
public class QrCodeController {

  private final QrCodeGeneratorService qrCodeGeneratorService;

  public QrCodeController(QrCodeGeneratorService qrCodeService) {
    this.qrCodeGeneratorService = qrCodeService;
  }

  @PostMapping
  public ResponseEntity<QrCodeGenerateResponse> generate(@RequestBody QrCodeGenerateRequest request){
    try {
      QrCodeGenerateResponse response = this.qrCodeGeneratorService.generateAndUploadQrCode(request.text());
      return ResponseEntity.ok(response);
    } catch (Exception e) {
      System.out.println(e);
      return ResponseEntity.internalServerError().build();
    }
  }
}
