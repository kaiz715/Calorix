package dev.zheng.calorixapi.dataprocessing;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.openai.client.OpenAIClient;
import com.openai.client.okhttp.OpenAIOkHttpClient;
import com.openai.core.JsonValue;
import com.openai.models.ChatModel;
import com.openai.models.ResponseFormatJsonSchema;
import com.openai.models.chat.completions.ChatCompletionContentPart;
import com.openai.models.chat.completions.ChatCompletionContentPartImage;
import com.openai.models.chat.completions.ChatCompletionContentPartText;
import com.openai.models.chat.completions.ChatCompletionCreateParams;
import com.fasterxml.jackson.databind.ObjectMapper;
import dev.zheng.calorixapi.dataprocessing.structures.NutritionInfo;


import java.util.Base64;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class OpenAI {

    private static OpenAIClient client = OpenAIOkHttpClient.fromEnv();

    private static ResponseFormatJsonSchema.JsonSchema.Schema schema = ResponseFormatJsonSchema.JsonSchema.Schema.builder()
            .putAdditionalProperty("type", JsonValue.from("object"))
            .putAdditionalProperty(
                    "properties", JsonValue.from(Map.of(
                            "name", Map.of(
                                    "type", "string",
                                    "description", "The name of the meal"),
                            "serving_size_g", Map.of(
                                    "type", "number",
                                    "description", "The number of grams of the meal per recommended serving"
                            ),
                            "servings", Map.of(
                                    "type", "number",
                                    "description", "The number of servings of the meal in the picture"
                            ),
                            "nutrition_values_per_100g", Map.of(
                                    "type", "object",
                                    "properties", Map.of(
                                            "calories_kcal", Map.of(
                                                    "type", "number",
                                                    "description", "The number of kilocalories in 100 grams of the meal"),
                                            "carb_g", Map.of(
                                                    "type", "number",
                                                    "description", "The number of grams of carbohydrates in 100 grams of the meal"),
                                            "protein_g", Map.of(
                                                    "type", "number",
                                                    "description", "The number of grams of proteins in 100 grams of the meal"),
                                            "fat_g", Map.of(
                                                    "type", "number",
                                                    "description", "The number of grams of fats in 100 grams of the meal")
                                    )
                            )

                    )))
            .build();

    public static NutritionInfo getNutritionFromImage(byte [] imageBytes) {

        String mealBase64Url = "data:image/jpeg;base64," + Base64.getEncoder().encodeToString(imageBytes);

        ChatCompletionContentPart mealContentPart =
                ChatCompletionContentPart.ofImageUrl(ChatCompletionContentPartImage.builder()
                        .imageUrl(ChatCompletionContentPartImage.ImageUrl.builder()
                                .url(mealBase64Url)
                                .detail(ChatCompletionContentPartImage.ImageUrl.Detail.AUTO)
                                .build()
                        )
                        .build());
        ChatCompletionContentPart questionContentPart =
                ChatCompletionContentPart.ofText(ChatCompletionContentPartText.builder()
                        .text("You are an expert nutritionist. You will be given a picture of a meal and should determine the size of the meal and the nutrition information for the meal and provide it in the provided structured format.")
                        .build());
        ChatCompletionCreateParams createParams = ChatCompletionCreateParams.builder()
                .model(ChatModel.GPT_4O)
                .maxCompletionTokens(2048)
                .responseFormat(ResponseFormatJsonSchema.builder()
                        .jsonSchema(ResponseFormatJsonSchema.JsonSchema.builder()
                                .name("Nutrition-Info")
                                .schema(schema)
                                .build())
                        .build())
                .addUserMessageOfArrayOfContentParts(List.of(questionContentPart, mealContentPart))
                .build();
        Optional<String> response = client.chat().completions().create(createParams).choices().getFirst().message().content();
        if (response.isEmpty()) { return null; }
        try {
            return new ObjectMapper().readValue(response.get(), NutritionInfo.class);
        } catch (JsonProcessingException err){
            System.out.println(err.getMessage());
            return null;
        }
    }

}
