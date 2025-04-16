#define STB_IMAGE_IMPLEMENTATION 
#include "C:\\Users\\andre\\Documents\\COMPUTACION_PARALELA\\Librerias\\stb_image.h"

#include <iostream>
#include <cstdlib>
#include <cmath>

int main() {
    // Rutas fijas de tus imágenes a comparar
    const char* path_cpu = "C:\\Users\\andre\\Documents\\61CPU.jpg";
    const char* path_gpu = "C:\\Users\\andre\\Documents\\61Cuda.jpg";

    int w1, h1, ch1;
    int w2, h2, ch2;

    // Cargar imagen procesada por CPU
    unsigned char* img1 = stbi_load(path_cpu, &w1, &h1, &ch1, 3);
    if (!img1) {
        std::cerr << "Error cargando imagen CPU: " << path_cpu << "\n";
        return 1;
    }

    // Cargar imagen procesada por GPU
    unsigned char* img2 = stbi_load(path_gpu, &w2, &h2, &ch2, 3);
    if (!img2) {
        std::cerr << "Error cargando imagen GPU: " << path_gpu << "\n";
        stbi_image_free(img1); // Liberar la imagen anterior si falla esta
        return 1;
    }

    // Verificar que ambas imágenes tengan las mismas dimensiones
    if (w1 != w2 || h1 != h2) {
        std::cerr << "Las imágenes tienen diferentes dimensiones\n";
        stbi_image_free(img1);
        stbi_image_free(img2);
        return 1;
    }

    // Calcular el número total de píxeles
    int total_pixels = w1 * h1;
    int diff_pixels = 0;

    // Recorrer todos los píxeles (3 canales por píxel: R, G, B)
    for (int i = 0; i < total_pixels * 3; i += 3) {
        int r1 = img1[i], g1 = img1[i + 1], b1 = img1[i + 2];
        int r2 = img2[i], g2 = img2[i + 1], b2 = img2[i + 2];

        // Contar como diferente si al menos un canal es distinto
        if (r1 != r2 || g1 != g2 || b1 != b2) {
            diff_pixels++;
        }
    }

    // Calcular porcentaje de diferencia e igualdad
    float porcentaje_diferencia = (100.0f * diff_pixels) / total_pixels;
    float porcentaje_igualdad = 100.0f - porcentaje_diferencia;

    // Mostrar resultados según coincidencias
    if (diff_pixels == 0) {
        std::cout << "Las imágenes son completamente iguales.\n";
    }
    else {
        std::cout << "Las imágenes son diferentes.\n";
    }

    std::cout << "Porcentaje de igualdad: " << porcentaje_igualdad << "%\n";

    // Liberar memoria de imágenes cargadas
    stbi_image_free(img1);
    stbi_image_free(img2);

    return 0;
}
