package dev.zheng.calorixapi.controllers;

import dev.zheng.calorixapi.dataprocessing.structures.NutritionInfo;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

import static dev.zheng.calorixapi.dataprocessing.OpenAI.getNutritionFromImage;

@RestController
@RequestMapping("/services")
public class Services {
    public Services() {}

    @GetMapping("/test")
    public String test() {
        return "ok";
    }

    @PostMapping("/getImageNutrition")
    public NutritionInfo getImageNutrition(@RequestParam("image") MultipartFile image) throws IOException {
        return getNutritionFromImage(image.getBytes());
    }

    @PostMapping("/getDescriptionNutrition")
    public String getDescriptionNutrition() {
        return "ok";
    }

    @PostMapping("/getBarcodeNutrition")
    public String getBarcodeNutrition() {
        return "ok";
    }
}
