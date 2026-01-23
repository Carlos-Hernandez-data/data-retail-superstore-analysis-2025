# Análisis de Ventas y Rentabilidad — Retail (Superstore)

**Autor:** Carlos Hernández Godoy  
**Perfil:** Data Analyst | Ingeniero Industrial  
**Año:** 2025  

## Contexto del proyecto
Este proyecto analiza el desempeño de ventas de un negocio retail utilizando el **Superstore Dataset**, un dataset de referencia en práctica y portafolios de analítica.

El objetivo es evaluar **ventas, rentabilidad y comportamiento temporal**, identificando:
- qué categorías y segmentos impulsan el negocio,
- dónde se generan pérdidas,
- y cómo evolucionan las ventas en el tiempo.

El enfoque combina **SQL**, **modelado de datos**, **DAX** y **Power BI**, replicando un flujo de trabajo real de un analista moderno apoyado en IA para acelerar análisis y validar hipótesis.

## Objetivos del análisis
- Analizar ventas y utilidad a nivel global.
- Comparar volumen vs. rentabilidad por categoría y segmento de cliente.
- Detectar subcategorías, productos o regiones con pérdidas.
- Evaluar tendencias, estacionalidad y crecimiento interanual.
- Construir un dashboard ejecutivo claro y orientado a decisiones.

## Entregables
- Script SQL de modelado y análisis (`05_sql/sql_modelado_y_analisis_superstore.sql`)
- Dashboard Power BI (`04_pbix/superstore-retail-dashboard.pbix`)
- Medidas DAX documentadas (`02_dax/medidas_dax_superstore.txt`)

## Estructura del repositorio
```
data-retail-superstore-analysis-2025/
├── 01_data/ (superstore_raw.csv)
├── 02_dax/ (medidas_dax_superstore.txt)
├── 03_img/ (resumen_ejecutivo_dashboard.png)
├── 04_pbix/ (superstore-retail-dashboard.pbix)
├── 05_sql/ (sql_modelado_y_analisis_superstore.sql)
└── 06_README.md
```
## Datos utilizados
- **Fuente:** Superstore Dataset (Kaggle)  
- **Periodo:** 2014 – 2017  
- **Variables principales:** ventas, utilidad, descuento, cantidad; categoría/subcategoría; segmento; región/estado/ciudad; fechas de orden y envío.

## Tecnologías y herramientas
### SQL Server
- Exploración de datos y KPIs de negocio
- Análisis geográfico
- Estacionalidad y tendencias
- Detección de pérdidas y outliers

### Power BI
- Power Query para limpieza
- Modelo estrella (Star Schema)
- Medidas DAX
- Dashboard ejecutivo

### IA (ChatGPT)
- Generación de hipótesis y validación de enfoques
- Estructuración del análisis
- Mejora de documentación y storytelling

## Modelado de datos
Se construyó un **modelo estrella**, separando hechos y dimensiones:
- **Hechos:** `FACT_Superstore`
- **Dimensiones:** `DIM_Calendar`, `DIM_Product`, `DIM_Customer`, `DIM_Geography`

Este enfoque permite análisis de tiempo (YTD/YoY), filtros eficientes y un modelo mantenible.

## Métricas clave (DAX)
- Ventas Totales, Utilidad Total, Margen %
- Nº de Clientes, Ticket Promedio
- Ventas YTD, Ventas LY, Variaciones interanuales

(Ver `02_dax/medidas_dax_superstore.txt`)

## Dashboard — Resumen Ejecutivo
El dashboard final consta de una sola página llamada **“Resumen Ejecutivo”**, diseñada para lectura rápida:
- KPIs de alto nivel
- Ventas vs. utilidad por categoría
- Rentabilidad por segmento
- Evolución temporal de ventas
- Segmentadores por año, región y categoría

Captura en `03_img/resumen_ejecutivo_dashboard.png`.

## Principales insights
- Existen subcategorías con alto volumen pero baja o negativa rentabilidad.
- El segmento con mayor venta no siempre es el más rentable.
- Se observan patrones de estacionalidad a lo largo del año.
- Algunas pérdidas se concentran en regiones con descuentos elevados.

## Conclusión
Este proyecto demuestra un flujo completo: **exploración en SQL → modelado → medidas DAX → dashboard ejecutivo**, comunicando hallazgos de forma clara y orientada a negocio.

## Contacto
Carlos Hernández Godoy  
Analista de Datos | SQL + Power BI | Ingeniero Industrial  
**Correo:** carloshernandez.data@gmail.com
