/*
ARTIGO: https://towardsdev.com/sql-window-functions-5e24dcde8a66
*/

-- ROW_NUMBER(): atribui um número exclusivo a cada linha em sua partição

-- Os dois primeiros funcionários que ingressaram na empresa de todos os departamentos
SELECT emp_id, emp_name, department, rn
FROM(
	SELECT *,
		ROW_NUMBER() OVER (PARTITION BY department ORDER BY emp_id) AS rn
	FROM employee
) subquery
WHERE subquery.rn <3

---------------------------------------------------------------------------------------------------------

-- RANK(): Define um ranqueamento para cada linha na partição, com registros duplicados recebendo o mesmo
-- ranqueamento e deixando espaços na sequencia.

-- Os três empregados mais bem pagos em cada departamento
SELECT emp_name, department, salary, rnk
FROM(
	SELECT *,
		RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
	FROM employee
) subquery
WHERE subquery.rnk <4

---------------------------------------------------------------------------------------------------------

-- DENSE_RANK(): Similaar ao RANK(), porém a diferença é que ele não trás espaço na sequência de ordem
SELECT *,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS d_rnk
FROM employee;

---------------------------------------------------------------------------------------------------------

-- LEAD(): Geralmente utilizado para obter o valor seguinte de qualquer linha. Possui 3 argumentos: 
-- expr: pode ser uma coluna ou uma função interna
-- N: valor positivo que determina o número de linhas que sucedem a linha atual
-- default: valor que será retornado caso nenhum dado retorne

-- Escreva uma consulta que cheque se o salário dos funcionários ultrapassa, seja igual ou inferior ao salário do 
-- funcionário subsequente.
SELECT emp_id, emp_name, department, salary,
    CASE
        WHEN salary > next_emp_salary THEN 'Maior que o salário do próximo funcionário'
        WHEN salary < next_emp_salary THEN 'Menor que o salário do próximo funcionário'
        WHEN salary = next_emp_salary THEN 'Igual ao salário do próximo funcionário'
    END AS next_salary_comparison
FROM(
    SELECT *,
        LEAD(salary) OVER(PARTITION BY department ORDER BY emp_id) AS next_emp_salary
    FROM employee
) subquery

---------------------------------------------------------------------------------------------------------

-- LAG(): Geralmente utilizado para obter o valor anterior de qualquer linha da partição

-- Determine se o salário do funcionário excede, é igual ou superior ao do funcionário anterior
SELECT emp_id, emp_name, department, salary,
	CASE
		WHEN salary > previous_salary THEN 'Maior que o salário do funcionário anterior'
		WHEN salary < previous_salary THEN 'Menor que o salário do funcionário anterior'
		WHEN salary = previous_salary THEN 'Igual ao salário do funcionário anterior'
	END AS salary_comparison
FROM(
	SELECT *,
		LAG(Salary) OVER(PARTITION BY department ORDER BY emp_id) AS previous_salary
	FROM employee
) subquery

---------------------------------------------------------------------------------------------------------

-- FIRST_VALUE(): Retorna o valor de uma expressão específica da primeira linha da janela. Aceita um único valor:
-- a coluna na qual queremos encontrar o primeiro valor.

-- Ache o produto mais caro em cada categoria
SELECT *,
	FIRST_VALUE(product_name) OVER(PARTITION BY product_category ORDER BY price DESC) AS most_expensive_product
FROM product

---------------------------------------------------------------------------------------------------------

-- LAST_VALUE(): Retorna o valor de uma expressão específica da ultima linha da janela. 

-- Ache o produto mais barato em cada categoria
SELECT *,
	LAST_VALUE(product_name) 
		OVER(PARTITION BY product_category ORDER BY price DESC
			RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS least_expensive_product
FROM product

---------------------------------------------------------------------------------------------------------

-- NTH_VALUE(): Retorna o valor de uma expressão específica da N linha da janela. 
-- Aceita dois parâmetros: expr (coluna) e N (posição que desejamos pesquisar)

-- Qual o segundo produto mais caro de cada categoria?
SELECT *,
	NTH_VALUE(product_name, 2)
		OVER(PARTITION BY product_category ORDER BY price DESC
			RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "2nd_most_exp_product"
FROM product

---------------------------------------------------------------------------------------------------------

-- NTILE(): Divide as partições em N grupos (buckets), atribui cada linha na partição seu número de bucket e retorna o número o número do bucket da linha atual em sua posição
-- Recebe o parâmetro N que é o número de grupos que desejamos dividir

-- Agrupe todos os aparelhos celulares em aparelho caros, mid range e baratos
SELECT product_name, price,
	CASE
		WHEN buckets = 1 THEN 'Expansive'
		WHEN buckets = 2 THEN 'Mid-range'
		ELSE 'Cheaper'
	END AS price_bucket
FROM(
	SELECT *,
		NTILE(3) OVER(ORDER BY price DESC) AS buckets
	FROM product
	WHERE product_category = 'Phone'
) subquery 