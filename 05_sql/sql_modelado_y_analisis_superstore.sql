/* ============================================================
   PROYECTO: Análisis de Ventas Retail - Superstore Dataset
   AUTOR: Carlos Hernández Godoy
   BASE DE DATOS: Superstore
   TABLA FUENTE: superstore_raw
   AÑO: 2025

   DESCRIPCIÓN:
      Este archivo contiene el análisis SQL del dataset Superstore,
      uno de los más utilizados en portafolios de analistas de datos.
      El objetivo es:
        - Entender la estructura de los datos.
        - Calcular KPIs clave de ventas y rentabilidad.
        - Analizar desempeño por región, productos y clientes.
        - Evaluar estacionalidad y tendencias.
        - Identificar pérdidas y outliers de negocio.

      Los resultados de este análisis se utilizarán para construir
      un modelo de datos y un dashboard en Power BI.
   ============================================================ */

USE Superstore;
GO


/* ============================================================
   TABLA DE CONTENIDO
   ------------------------------------------------------------
   1. Contexto y tabla fuente
   2. Exploración inicial de los datos
   3. KPIs generales de negocio
   4. Análisis por región, estado y ciudad
   5. Estacionalidad y tendencias
   6. Detección de pérdidas y outliers
   ============================================================ */


/* ============================================================
   1. CONTEXTO Y TABLA FUENTE
   ------------------------------------------------------------
   Tabla utilizada en este proyecto:
     - [superstore_raw]

   La tabla [superstore_raw] fue creada mediante el asistente
   de importación de SQL Server a partir del archivo CSV:
     - 01_data/superstore_raw.csv

   A continuación se documenta una posible definición lógica
   de una tabla de hechos de ventas. Este bloque es solo
   de documentación y NO es necesario ejecutarlo en este
   proyecto, ya que la tabla real ya existe.
   ============================================================ */

/*
CREATE TABLE superstore_sales (
    Row_ID INT,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(255),
    Segment VARCHAR(50),
    Country VARCHAR(100),
    City VARCHAR(100),
    State VARCHAR(100),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Product_Name VARCHAR(255),
    Sales DECIMAL(18,2),
    Quantity INT,
    Discount DECIMAL(5,2),
    Profit DECIMAL(18,2)
);

-- Ejemplo de carga (referencia, no se usó en este proyecto):

-- BULK INSERT superstore_sales
-- FROM 'C:\ruta\superstore_raw.csv'
-- WITH (
--     FORMAT='CSV',
--     FIRSTROW=2,
--     FIELDTERMINATOR=',',
--     ROWTERMINATOR='\n'
-- );
*/


/* ============================================================
   2. EXPLORACIÓN INICIAL DE LOS DATOS
   ------------------------------------------------------------
   Objetivo:
   - Validar que los datos se importaron correctamente.
   - Entender estructura básica y rangos de fechas.
   - Revisar categorías, subcategorías y regiones.
   Tabla utilizada: [superstore_raw]
   ============================================================ */

-- 2.1 Ver primeras filas
SELECT TOP 20 *
FROM superstore_raw;


-- 2.2 Conteo total de registros
SELECT COUNT(*) AS total_registros
FROM superstore_raw;


-- 2.3 Columnas y tipos de datos de la tabla
EXEC sp_help 'superstore_raw';


-- 2.4 Rangos de fechas de pedido
SELECT 
    MIN(Order_Date) AS fecha_min,
    MAX(Order_Date) AS fecha_max
FROM superstore_raw;


-- 2.5 Regiones y estados distintos
SELECT DISTINCT Region
FROM superstore_raw
ORDER BY Region;

SELECT DISTINCT State
FROM superstore_raw
ORDER BY State;


-- 2.6 Categorías y subcategorías
SELECT DISTINCT Category
FROM superstore_raw
ORDER BY Category;

SELECT DISTINCT Sub_Category
FROM superstore_raw
ORDER BY Sub_Category;



/* ============================================================
   3. KPIs GENERALES DE NEGOCIO
   ------------------------------------------------------------
   Objetivo:
   - Obtener una visión inicial del desempeño global.
   - Calcular:
       * Ventas totales
       * Utilidad total
       * Margen promedio
       * Unidades vendidas
       * Número de pedidos
       * Ticket promedio
       * Descuento promedio
   Tabla utilizada: [superstore_raw]
   ============================================================ */

-- 3.1 Resumen general de KPIs en una sola fila
SELECT
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,       -- margen sobre ventas
    SUM(Quantity) AS unidades_vendidas,
    COUNT(DISTINCT Order_ID) AS numero_pedidos,
    SUM(Sales) / NULLIF(COUNT(DISTINCT Order_ID), 0) AS ticket_promedio,
    AVG(Discount) AS descuento_promedio
FROM superstore_raw;


-- 3.2 Ventas y utilidad por año
SELECT
    YEAR(Order_Date) AS anio,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio
FROM superstore_raw
GROUP BY YEAR(Order_Date)
ORDER BY anio;


-- 3.3 Ventas por segmento de cliente
SELECT
    Segment,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    COUNT(DISTINCT Customer_ID) AS clientes_unicos
FROM superstore_raw
GROUP BY Segment
ORDER BY ventas_totales DESC;


-- 3.4 Ventas por categoría de producto
SELECT
    Category,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY Category
ORDER BY ventas_totales DESC;


-- 3.5 Descuento promedio por categoría
SELECT
    Category,
    AVG(Discount) AS descuento_promedio,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY Category
ORDER BY descuento_promedio DESC;


-- 3.6 Top 10 clientes por ventas
SELECT TOP 10
    Customer_ID,
    Customer_Name,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    COUNT(DISTINCT Order_ID) AS numero_pedidos
FROM superstore_raw
GROUP BY Customer_ID, Customer_Name
ORDER BY ventas_totales DESC;


-- 3.7 Top 10 productos por utilidad
SELECT TOP 10
    Product_ID,
    Product_Name,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY Product_ID, Product_Name
ORDER BY utilidad_total DESC;



/* ============================================================
   4. ANÁLISIS POR REGIÓN, ESTADO Y CIUDAD
   ------------------------------------------------------------
   Objetivo:
   - Identificar zonas con mayor contribución a ventas y utilidad.
   - Detectar estados que generan pérdidas.
   - Revisar patrones de descuento por ubicación.
   Tabla utilizada: [superstore_raw]
   ============================================================ */

-- 4.1 Ventas por región
SELECT
    Region,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY Region
ORDER BY ventas_totales DESC;


-- 4.2 Ventas por estado
SELECT
    State,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY State
ORDER BY ventas_totales DESC;


-- 4.3 Estados con utilidad negativa (pérdidas)
SELECT
    State,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY State
HAVING SUM(Profit) < 0
ORDER BY utilidad_total ASC;


-- 4.4 Ciudades con mayor pérdida acumulada
SELECT TOP 10
    City,
    State,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen_promedio
FROM superstore_raw
GROUP BY City, State
HAVING SUM(Profit) < 0
ORDER BY utilidad_total ASC;


-- 4.5 Descuento promedio por estado
SELECT
    State,
    AVG(Discount) AS descuento_promedio,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY State
ORDER BY descuento_promedio DESC;



/* ============================================================
   5. ESTACIONALIDAD Y TENDENCIAS
   ------------------------------------------------------------
   Objetivo:
   - Analizar el comportamiento temporal de las ventas.
   - Identificar patrones por año, mes y trimestre.
   - Calcular crecimiento mensual (MoM) y anual (YoY).
   Tabla utilizada: [superstore_raw]
   ============================================================ */

-- 5.1 Ventas por año
SELECT
    YEAR(Order_Date) AS anio,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY YEAR(Order_Date)
ORDER BY anio;


-- 5.2 Ventas por mes (agregado multi-año)
SELECT
    MONTH(Order_Date) AS mes,
    DATENAME(MONTH, Order_Date) AS nombre_mes,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY MONTH(Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY mes;


-- 5.3 Ventas por año y mes
SELECT
    YEAR(Order_Date) AS anio,
    MONTH(Order_Date) AS mes,
    DATENAME(MONTH, Order_Date) AS nombre_mes,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY YEAR(Order_Date), MONTH(Order_Date), DATENAME(MONTH, Order_Date)
ORDER BY anio, mes;


-- 5.4 Ventas por trimestre
SELECT
    YEAR(Order_Date) AS anio,
    DATEPART(QUARTER, Order_Date) AS trimestre,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY YEAR(Order_Date), DATEPART(QUARTER, Order_Date)
ORDER BY anio, trimestre;


-- 5.5 Crecimiento mensual (MoM) usando funciones ventana
WITH ventas_mensuales AS (
    SELECT
        YEAR(Order_Date) AS anio,
        MONTH(Order_Date) AS mes,
        SUM(Sales) AS ventas_totales
    FROM superstore_raw
    GROUP BY YEAR(Order_Date), MONTH(Order_Date)
)
SELECT
    anio,
    mes,
    ventas_totales,
    ventas_totales
        - LAG(ventas_totales, 1) OVER (ORDER BY anio, mes) AS crecimiento_absoluto,
    (ventas_totales
        - LAG(ventas_totales, 1) OVER (ORDER BY anio, mes))
        / NULLIF(LAG(ventas_totales, 1) OVER (ORDER BY anio, mes), 0) AS crecimiento_porcentual
FROM ventas_mensuales
ORDER BY anio, mes;


-- 5.6 Crecimiento anual (YoY)
WITH ventas_anuales AS (
    SELECT
        YEAR(Order_Date) AS anio,
        SUM(Sales) AS ventas_totales
    FROM superstore_raw
    GROUP BY YEAR(Order_Date)
)
SELECT
    anio,
    ventas_totales,
    ventas_totales
        - LAG(ventas_totales, 1) OVER (ORDER BY anio) AS crecimiento_absoluto,
    (ventas_totales
        - LAG(ventas_totales, 1) OVER (ORDER BY anio))
        / NULLIF(LAG(ventas_totales, 1) OVER (ORDER BY anio), 0) AS crecimiento_porcentual
FROM ventas_anuales
ORDER BY anio;



/* ============================================================
   6. DETECCIÓN DE PÉRDIDAS Y OUTLIERS
   ------------------------------------------------------------
   Objetivo:
   - Identificar productos, clientes y pedidos que generan pérdidas.
   - Detectar descuentos excesivos.
   - Encontrar pedidos con alta venta y baja utilidad.
   Tabla utilizada: [superstore_raw]
   ============================================================ */

-- 6.1 Pedidos con utilidad negativa
SELECT
    Order_ID,
    Order_Date,
    Customer_Name,
    Product_Name,
    Sales,
    Profit,
    Discount
FROM superstore_raw
WHERE Profit < 0
ORDER BY Profit ASC;


-- 6.2 Productos que generan más pérdida
SELECT TOP 15
    Product_ID,
    Product_Name,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY Product_ID, Product_Name
HAVING SUM(Profit) < 0
ORDER BY utilidad_total ASC;


-- 6.3 Subcategorías con pérdida acumulada
SELECT
    Category,
    Sub_Category,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen
FROM superstore_raw
GROUP BY Category, Sub_Category
HAVING SUM(Profit) < 0
ORDER BY utilidad_total ASC;


-- 6.4 Clientes que generan pérdidas netas
SELECT
    Customer_ID,
    Customer_Name,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total,
    SUM(Profit) / NULLIF(SUM(Sales), 0) AS margen,
    SUM(Quantity) AS unidades_vendidas
FROM superstore_raw
GROUP BY Customer_ID, Customer_Name
HAVING SUM(Profit) < 0
ORDER BY utilidad_total ASC;


-- 6.5 Estados con descuentos peligrosos (mayores al 25% promedio)
SELECT
    State,
    AVG(Discount) AS descuento_promedio,
    SUM(Sales) AS ventas_totales,
    SUM(Profit) AS utilidad_total
FROM superstore_raw
GROUP BY State
HAVING AVG(Discount) > 0.25
ORDER BY descuento_promedio DESC;


-- 6.6 Pedidos con descuento excesivo (>= 30%) y su impacto en utilidad
SELECT
    Order_ID,
    Customer_Name,
    Product_Name,
    Sales,
    Profit,
    Discount
FROM superstore_raw
WHERE Discount > 0.30   -- 30% o más
ORDER BY Profit ASC;


-- 6.7 Pedidos con alta venta pero baja utilidad
SELECT
    Order_ID,
    Product_Name,
    Sales,
    Profit,
    Discount,
    (Profit / NULLIF(Sales, 0)) AS margen
FROM superstore_raw
WHERE Sales > 200       -- ventas altas
  AND Profit < 10       -- margen muy bajo
ORDER BY Sales DESC;


/* ============================================================
   FIN DEL ARCHIVO
   ------------------------------------------------------------
   Notas:
   - Este análisis SQL sirve como base para:
       * El modelado en Power BI (tablas de hechos y dimensiones).
       * La creación de medidas DAX.
       * La construcción de un dashboard ejecutivo
         con foco en ventas, rentabilidad y pérdidas.
   ============================================================ */
