package io.github.bardiakz.authservice;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Configuration
@Profile("!docker")
public class EnvConfig {

    @Bean
    public Dotenv dotenv() {
        return Dotenv.load();
    }
}
