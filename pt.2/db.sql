--
-- PostgreSQL database dump
--

\restrict OdhMQvLZJZ6ZbKQc9CCmpzarPMLrAO67vJy3ZJSMS76xghl50ViU1UcRKU071BN

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2026-03-19 19:55:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 17089)
-- Name: contractors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contractors (
    id character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    inn character varying(12),
    address character varying(300),
    phone character varying(20),
    is_supplier boolean DEFAULT false,
    is_customer boolean DEFAULT false
);


ALTER TABLE public.contractors OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17191)
-- Name: customer_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_orders (
    id integer NOT NULL,
    order_number character varying(50) NOT NULL,
    order_date date DEFAULT CURRENT_DATE NOT NULL,
    customer_id character varying(20) NOT NULL
);


ALTER TABLE public.customer_orders OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 17190)
-- Name: customer_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customer_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_orders_id_seq OWNER TO postgres;

--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 230
-- Name: customer_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customer_orders_id_seq OWNED BY public.customer_orders.id;


--
-- TOC entry 225 (class 1259 OID 17138)
-- Name: material_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.material_prices (
    id integer NOT NULL,
    material_id character varying(20) NOT NULL,
    price numeric(10,2) NOT NULL,
    valid_from date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.material_prices OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17137)
-- Name: material_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.material_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.material_prices_id_seq OWNER TO postgres;

--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 224
-- Name: material_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.material_prices_id_seq OWNED BY public.material_prices.id;


--
-- TOC entry 221 (class 1259 OID 17110)
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.materials (
    id character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    unit character varying(20) NOT NULL
);


ALTER TABLE public.materials OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17210)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_id character varying(20) NOT NULL,
    quantity numeric(10,3) NOT NULL,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 17209)
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_id_seq OWNER TO postgres;

--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 232
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;


--
-- TOC entry 223 (class 1259 OID 17121)
-- Name: product_prices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_prices (
    id integer NOT NULL,
    product_id character varying(20) NOT NULL,
    price numeric(10,2) NOT NULL,
    valid_from date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.product_prices OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 17120)
-- Name: product_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_prices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.product_prices_id_seq OWNER TO postgres;

--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 222
-- Name: product_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_prices_id_seq OWNED BY public.product_prices.id;


--
-- TOC entry 235 (class 1259 OID 17232)
-- Name: production_tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.production_tasks (
    id integer NOT NULL,
    task_number character varying(50) NOT NULL,
    task_date date DEFAULT CURRENT_DATE NOT NULL,
    specification_id integer NOT NULL,
    planned_quantity numeric(10,3) NOT NULL
);


ALTER TABLE public.production_tasks OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 17231)
-- Name: production_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.production_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.production_tasks_id_seq OWNER TO postgres;

--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 234
-- Name: production_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.production_tasks_id_seq OWNED BY public.production_tasks.id;


--
-- TOC entry 220 (class 1259 OID 17100)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    unit character varying(20) NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17170)
-- Name: specification_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specification_items (
    id integer NOT NULL,
    specification_id integer NOT NULL,
    material_id character varying(20) NOT NULL,
    quantity numeric(10,5) NOT NULL
);


ALTER TABLE public.specification_items OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17169)
-- Name: specification_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specification_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specification_items_id_seq OWNER TO postgres;

--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 228
-- Name: specification_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specification_items_id_seq OWNED BY public.specification_items.id;


--
-- TOC entry 227 (class 1259 OID 17155)
-- Name: specifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specifications (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    product_id character varying(20) NOT NULL
);


ALTER TABLE public.specifications OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17154)
-- Name: specifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specifications_id_seq OWNER TO postgres;

--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 226
-- Name: specifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specifications_id_seq OWNED BY public.specifications.id;


--
-- TOC entry 4805 (class 2604 OID 17194)
-- Name: customer_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_orders ALTER COLUMN id SET DEFAULT nextval('public.customer_orders_id_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 17141)
-- Name: material_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_prices ALTER COLUMN id SET DEFAULT nextval('public.material_prices_id_seq'::regclass);


--
-- TOC entry 4807 (class 2604 OID 17213)
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);


--
-- TOC entry 4799 (class 2604 OID 17124)
-- Name: product_prices id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices ALTER COLUMN id SET DEFAULT nextval('public.product_prices_id_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 17235)
-- Name: production_tasks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_tasks ALTER COLUMN id SET DEFAULT nextval('public.production_tasks_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 17173)
-- Name: specification_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specification_items ALTER COLUMN id SET DEFAULT nextval('public.specification_items_id_seq'::regclass);


--
-- TOC entry 4803 (class 2604 OID 17158)
-- Name: specifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifications ALTER COLUMN id SET DEFAULT nextval('public.specifications_id_seq'::regclass);


--
-- TOC entry 4994 (class 0 OID 17089)
-- Dependencies: 219
-- Data for Name: contractors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contractors (id, name, inn, address, phone, is_supplier, is_customer) FROM stdin;
000000001	ООО Поставка		г.Пятигорск	+79198634592	t	t
000000002	ООО Кинотеатр Квант	26320045123	г. Железноводск, ул. Мира, 123	+79884581555	t	f
000000008	ООО Новый JDTO	26320045111	г. Железноводсу	+79884581555	t	f
000000003	ООО Ромашка	4140784214	г. Омск, ул. Строителей, 294	+79882584546	f	t
000000009	ООО Ипподром	5874045632	г. Уфа, ул. Набережная,  37	+79627486389	t	t
000000010	ООО Ассоль	2629011278	г. Калуга, ул. Пушкина, 94	+79184572398	f	t
\.


--
-- TOC entry 5006 (class 0 OID 17191)
-- Dependencies: 231
-- Data for Name: customer_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_orders (id, order_number, order_date, customer_id) FROM stdin;
1	2	2025-06-06	000000010
\.


--
-- TOC entry 5000 (class 0 OID 17138)
-- Dependencies: 225
-- Data for Name: material_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.material_prices (id, material_id, price, valid_from) FROM stdin;
1	НФ-00000004	34.00	2025-01-01
2	НФ-00000005	45.00	2025-01-01
\.


--
-- TOC entry 4996 (class 0 OID 17110)
-- Dependencies: 221
-- Data for Name: materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.materials (id, name, unit) FROM stdin;
НФ-00000004	Молоко нормализованное	кг
НФ-00000005	Закваска сметанная	кг
\.


--
-- TOC entry 5008 (class 0 OID 17210)
-- Dependencies: 233
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (id, order_id, product_id, quantity, price) FROM stdin;
1	1	НФ-00000007	12.000	80.00
2	1	НФ-00000008	9.000	82.00
3	1	НФ-00000009	10.000	70.00
\.


--
-- TOC entry 4998 (class 0 OID 17121)
-- Dependencies: 223
-- Data for Name: product_prices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_prices (id, product_id, price, valid_from) FROM stdin;
1	НФ-00000006	89.00	2025-01-01
2	НФ-00000007	80.00	2025-01-01
3	НФ-00000008	82.00	2025-01-01
4	НФ-00000009	70.00	2025-01-01
5	НФ-00000010	76.00	2025-01-01
6	НФ-00000011	92.00	2025-01-01
\.


--
-- TOC entry 5010 (class 0 OID 17232)
-- Dependencies: 235
-- Data for Name: production_tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.production_tasks (id, task_number, task_date, specification_id, planned_quantity) FROM stdin;
1	1	2025-06-09	1	1.000
\.


--
-- TOC entry 4995 (class 0 OID 17100)
-- Dependencies: 220
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, name, unit) FROM stdin;
НФ-00000006	Сметана классическая 15% 540г.	шт
НФ-00000007	Кефир 2,5% 900г.	шт
НФ-00000008	Кефир 3,2% 900г.	шт
НФ-00000009	Молоко 2,5% 900г.	шт
НФ-00000010	Молоко 3,2% 900г.	шт
НФ-00000011	Сметана классическая 20% 540г.	шт
\.


--
-- TOC entry 5004 (class 0 OID 17170)
-- Dependencies: 229
-- Data for Name: specification_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specification_items (id, specification_id, material_id, quantity) FROM stdin;
1	1	НФ-00000004	0.90000
2	1	НФ-00000005	0.07000
\.


--
-- TOC entry 5002 (class 0 OID 17155)
-- Dependencies: 227
-- Data for Name: specifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.specifications (id, name, product_id) FROM stdin;
1	Основная Сметана 15%	НФ-00000006
\.


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 230
-- Name: customer_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_orders_id_seq', 1, true);


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 224
-- Name: material_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.material_prices_id_seq', 2, true);


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 232
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_id_seq', 3, true);


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 222
-- Name: product_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_prices_id_seq', 6, true);


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 234
-- Name: production_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.production_tasks_id_seq', 1, true);


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 228
-- Name: specification_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specification_items_id_seq', 2, true);


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 226
-- Name: specifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specifications_id_seq', 1, true);


--
-- TOC entry 4811 (class 2606 OID 17099)
-- Name: contractors contractors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractors
    ADD CONSTRAINT contractors_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 17203)
-- Name: customer_orders customer_orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_order_number_key UNIQUE (order_number);


--
-- TOC entry 4831 (class 2606 OID 17201)
-- Name: customer_orders customer_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT customer_orders_pkey PRIMARY KEY (id);


--
-- TOC entry 4823 (class 2606 OID 17148)
-- Name: material_prices material_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_prices
    ADD CONSTRAINT material_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4817 (class 2606 OID 17119)
-- Name: materials materials_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_name_key UNIQUE (name);


--
-- TOC entry 4819 (class 2606 OID 17117)
-- Name: materials materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 17220)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4821 (class 2606 OID 17131)
-- Name: product_prices product_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices
    ADD CONSTRAINT product_prices_pkey PRIMARY KEY (id);


--
-- TOC entry 4835 (class 2606 OID 17243)
-- Name: production_tasks production_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_tasks
    ADD CONSTRAINT production_tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 17245)
-- Name: production_tasks production_tasks_task_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_tasks
    ADD CONSTRAINT production_tasks_task_number_key UNIQUE (task_number);


--
-- TOC entry 4813 (class 2606 OID 17109)
-- Name: products products_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_name_key UNIQUE (name);


--
-- TOC entry 4815 (class 2606 OID 17107)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4827 (class 2606 OID 17179)
-- Name: specification_items specification_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specification_items
    ADD CONSTRAINT specification_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4825 (class 2606 OID 17163)
-- Name: specifications specifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifications
    ADD CONSTRAINT specifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4839 (class 2606 OID 17149)
-- Name: material_prices fk_material_prices_material; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.material_prices
    ADD CONSTRAINT fk_material_prices_material FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE CASCADE;


--
-- TOC entry 4844 (class 2606 OID 17221)
-- Name: order_items fk_order_items_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_order FOREIGN KEY (order_id) REFERENCES public.customer_orders(id) ON DELETE CASCADE;


--
-- TOC entry 4845 (class 2606 OID 17226)
-- Name: order_items fk_order_items_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_order_items_product FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE RESTRICT;


--
-- TOC entry 4843 (class 2606 OID 17204)
-- Name: customer_orders fk_orders_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_orders
    ADD CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES public.contractors(id) ON DELETE RESTRICT;


--
-- TOC entry 4838 (class 2606 OID 17132)
-- Name: product_prices fk_product_prices_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_prices
    ADD CONSTRAINT fk_product_prices_product FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4846 (class 2606 OID 17246)
-- Name: production_tasks fk_production_spec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.production_tasks
    ADD CONSTRAINT fk_production_spec FOREIGN KEY (specification_id) REFERENCES public.specifications(id) ON DELETE RESTRICT;


--
-- TOC entry 4841 (class 2606 OID 17185)
-- Name: specification_items fk_spec_items_material; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specification_items
    ADD CONSTRAINT fk_spec_items_material FOREIGN KEY (material_id) REFERENCES public.materials(id) ON DELETE RESTRICT;


--
-- TOC entry 4842 (class 2606 OID 17180)
-- Name: specification_items fk_spec_items_spec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specification_items
    ADD CONSTRAINT fk_spec_items_spec FOREIGN KEY (specification_id) REFERENCES public.specifications(id) ON DELETE CASCADE;


--
-- TOC entry 4840 (class 2606 OID 17164)
-- Name: specifications fk_specifications_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specifications
    ADD CONSTRAINT fk_specifications_product FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


-- Completed on 2026-03-19 19:56:00

--
-- PostgreSQL database dump complete
--

\unrestrict OdhMQvLZJZ6ZbKQc9CCmpzarPMLrAO67vJy3ZJSMS76xghl50ViU1UcRKU071BN

