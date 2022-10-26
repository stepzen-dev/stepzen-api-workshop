GRANT ALL PRIVILEGES ON DATABASE introspection TO "testUserIntrospection";

CREATE TABLE "address" (
    id integer NOT NULL,
    street character(20),
    city character(20),
    postalcode character(10),
    countryregion character(20),
    stateprovince character(20)
);

CREATE TABLE "customer" (
    email character(50) NOT NULL,
    id integer NOT NULL,
    name character(50) NOT NULL
);

CREATE TABLE "customeraddress" (
    customerid integer NOT NULL,
    addressid integer NOT NULL
);

CREATE TABLE "lineitem" (
    orderid integer NOT NULL,
    productid integer NOT NULL,
    quantity integer
);

CREATE TABLE "order" (
    id integer NOT NULL,
    createdat date NOT NULL,
    shippingcost double precision,
    customerid integer NOT NULL,
    carrier character(20),
    trackingid character(30)
);

CREATE TABLE "product" (
    id integer NOT NULL,
    isbn character varying(255),
    title character varying(255),
    edition character varying(255)
);

GRANT ALL PRIVILEGES ON TABLE "address" TO "testUserIntrospection";

GRANT ALL PRIVILEGES ON TABLE "customer" TO "testUserIntrospection";

GRANT ALL PRIVILEGES ON TABLE "customeraddress" TO "testUserIntrospection";

GRANT ALL PRIVILEGES ON TABLE "lineitem" TO "testUserIntrospection";

GRANT ALL PRIVILEGES ON TABLE "order" TO "testUserIntrospection";

GRANT ALL PRIVILEGES ON TABLE "product" TO "testUserIntrospection";

ALTER TABLE
    ONLY "address"
ADD
    CONSTRAINT address_pkey PRIMARY KEY (id);

ALTER TABLE
    ONLY "customer"
ADD
    CONSTRAINT customer_email_key UNIQUE (email);

ALTER TABLE
    ONLY "customer"
ADD
    CONSTRAINT customer_pkey PRIMARY KEY (id);

ALTER TABLE
    ONLY "customeraddress"
ADD
    CONSTRAINT customeraddress_pkey PRIMARY KEY (customerid, addressid);

ALTER TABLE
    ONLY "order"
ADD
    CONSTRAINT order_pkey PRIMARY KEY (id);

ALTER TABLE
    ONLY "product"
ADD
    CONSTRAINT product_pkey PRIMARY KEY (id);

ALTER TABLE
    ONLY "customeraddress"
ADD
    CONSTRAINT customeraddress_addressid_fkey FOREIGN KEY (addressid) REFERENCES "address"(id);

ALTER TABLE
    ONLY "customeraddress"
ADD
    CONSTRAINT customeraddress_customerid_fkey FOREIGN KEY (customerid) REFERENCES "customer"(id);

ALTER TABLE
    ONLY "lineitem"
ADD
    CONSTRAINT lineitem_orderid_fkey FOREIGN KEY (orderid) REFERENCES "order"(id);

ALTER TABLE
    ONLY "lineitem"
ADD
    CONSTRAINT lineitem_productid_fkey FOREIGN KEY (productid) REFERENCES "product"(id);

ALTER TABLE
    ONLY "order"
ADD
    CONSTRAINT order_customerid_fkey FOREIGN KEY (customerid) REFERENCES "customer"(id);

INSERT INTO
    "address" (
        id,
        street,
        city,
        postalcode,
        countryregion,
        stateprovince
    )
VALUES
    (
        1,
        '999 Croissant Bl',
        'Boston',
        '02122',
        'US',
        'Massachussets'
    ),
    (
        2,
        '1111 Dell Way',
        'Round Rock',
        '78664',
        'US',
        'Texas'
    ),
    (
        3,
        '555 Silly Wy',
        'London',
        'EI 6AN',
        'UK',
        'Middlesex'
    ),
    (
        4,
        '777 Highlands Dr',
        'Edinburgh',
        'EH1 1DR',
        'UK',
        'Midlothian'
    ),
    (
        5,
        '111 Main St',
        'Miami',
        '33122',
        'US',
        'Florida'
    ),
    (
        6,
        '222 Side St',
        'San Francisco',
        '94016',
        'US',
        'California'
    ),
    (
        7,
        '444 Right Cir',
        'New York',
        '10025',
        'US',
        'New York'
    ),
    (
        8,
        '888 Rainy Ct',
        'Seattle',
        '98115',
        'US',
        'Washington'
    ),
    (
        9,
        '333 Left Ave',
        'Chicago',
        '60617',
        'US',
        'Illinois'
    ),
    (
        10,
        '666 Connaught Cir',
        'Delhi',
        '110001',
        'IN',
        'Delhi'
    );

INSERT INTO
    customer (email, id, name)
VALUES
    ('lucas.bill@example.com', 1, 'Lucas Bill'),
    ('mandy.jones@example.com   ', 2, 'Mandy Jones'),
    ('salim.ali@example.com ', 3, 'Salim Ali '),
    ('jane.xiu@example.com  ', 4, 'Jane Xiu  '),
    ('john.doe@example.com  ', 5, 'John Doe  '),
    ('jane.smith@example.com', 6, 'Jane Smith'),
    (
        'sandeep.bhushan@example.com',
        7,
        'Sandeep Bhushan'
    ),
    ('george.han@example.com', 8, 'George Han'),
    ('asha.kumari@example.com   ', 9, 'Asha Kumari'),
    ('salma.khan@example.com', 10, 'Salma Khan');

INSERT INTO
    "customeraddress" (customerid, addressid)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

INSERT INTO
    "order" (
        id,
        createdat,
        shippingcost,
        customerid,
        carrier,
        trackingid
    )
VALUES
    (1, '2020-08-05', 3, 4, NULL, NULL),
    (2, '2020-08-02', 3, 6, NULL, NULL),
    (3, '2020-08-04', 1, 10, NULL, NULL),
    (4, '2020-08-03', 2, 8, NULL, NULL),
    (5, '2020-08-10', 2, 10, NULL, NULL),
    (6, '2020-08-01', 3, 3, NULL, NULL),
    (7, '2020-08-02', 1, 4, NULL, NULL),
    (8, '2020-08-04', 3, 2, NULL, NULL),
    (9, '2020-08-07', 3, 8, NULL, NULL),
    (10, '2020-08-09', 1, 9, NULL, NULL),
    (11, '2020-08-07', 2, 7, NULL, NULL),
    (12, '2020-08-03', 3, 9, NULL, NULL),
    (13, '2020-08-06', 3, 5, NULL, NULL),
    (14, '2020-08-01', 2, 2, NULL, NULL),
    (15, '2020-08-05', 1, 3, NULL, NULL),
    (16, '2020-08-02', 2, 5, NULL, NULL),
    (17, '2020-08-03', 1, 7, NULL, NULL),
    (18, '2020-08-06', 1, 6, NULL, NULL),
    (19, '2020-08-04', 2, 1, NULL, NULL),
    (20, '2020-08-01', 1, 1, NULL, NULL);

INSERT INTO
    "product" (id, isbn, title, edition)
VALUES
    (
        49,
        '9780552149518',
        'Da Vinci Code,The',
        'Paperback'
    ),
    (
        64,
        '9780747532743',
        'Harry Potter and the Philosophers Stone',
        'Paperback'
    ),
    (
        18,
        '9780747538486',
        'Harry Potter and the Chamber of Secrets',
        'Paperback'
    ),
    (
        43,
        '9780552150736',
        'Angels and Demons',
        'Paperback'
    ),
    (
        55,
        '9780747551003',
        'Harry Potter and the Order of the Phoenix',
        'Hardback'
    ),
    (
        15,
        '9780747591054',
        'Harry Potter and the Deathly Hallows',
        'Hardback'
    ),
    (
        61,
        '9780747546290',
        'Harry Potter and the Prisoner of Azkaban',
        'Paperback'
    ),
    (21, '9781904233657', 'Twilight', 'Paperback'),
    (
        1,
        '9780747550990',
        'Harry Potter and the Goblet of Fire',
        'Paperback'
    ),
    (
        51,
        '9780552151764',
        'Deception Point',
        'Paperback'
    ),
    (
        42,
        '9781904233886',
        'New Moon',
        'Hardback'
    ),
    (
        34,
        '9780330457729',
        'Lovely Bones,The',
        'Paperback'
    ),
    (
        9,
        '9780552151696',
        'Digital Fortress',
        'Hardback'
    ),
    (
        36,
        '9781904233916',
        'Eclipse',
        'Paperback'
    ),
    (
        53,
        '9781847245458',
        'Girl with the Dragon Tattoo,The:Millennium Trilogy',
        'Hardback'
    ),
    (
        63,
        '9780747566533',
        'Kite Runner,The',
        'Hardback'
    ),
    (
        11,
        '9780099464464',
        'Time Travelers Wife,The',
        'Paperback'
    ),
    (
        50,
        '9780141017891',
        'World According to Clarkson,The',
        'Paperback'
    ),
    (
        39,
        '9780099429791',
        'Atonement',
        'Paperback'
    ),
    (
        38,
        '9780593054277',
        'Lost Symbol,The',
        'Paperback'
    ),
    (
        37,
        '9780552997041',
        'Short History of Nearly Everything,A',
        'Paperback'
    ),
    (
        19,
        '9781905654284',
        'Breaking Dawn',
        'Paperback'
    ),
    (
        76,
        '9780747546245',
        'Harry Potter and the Goblet of Fire',
        'Paperback'
    ),
    (
        70,
        '9780747591061',
        'Harry Potter and the Deathly Hallows',
        'Paperback'
    ),
    (
        69,
        '9781849163422',
        'Girl Who Played With Fire,The:Millennium Trilogy',
        'Paperback'
    ),
    (
        2,
        '9780752837505',
        'Child Called It,A',
        'Paperback'
    ),
    (
        29,
        '9780349116754',
        'No.1 Ladies Detective Agency,',
        'Paperback'
    ),
    (
        20,
        '9780718147655',
        'You are What You Eat:The Plan That Will Change Your Life',
        'Paperback'
    ),
    (
        74,
        '9780006512134',
        'Man and Boy',
        'Paperback'
    ),
    (
        27,
        '9780099387916',
        'Birdsong',
        'Paperback'
    ),
    (
        72,
        '9780752877327',
        'Labyrinth',
        'Paperback'
    ),
    (
        54,
        '9780755309511',
        'Island,The',
        'Paperback'
    ),
    (
        77,
        '9781841953922',
        'Life of Pi',
        'Paperback'
    ),
    (
        86,
        '9780747599876',
        'Tales of Beedle the Bard,The',
        'Paperback'
    ),
    (
        12,
        '9780749397548',
        'Captain Corellis Mandolin',
        'Paperback'
    ),
    (
        60,
        '9780563384304',
        'Delias How to Cook:(Bk.1) ',
        'Paperback'
    ),
    (
        84,
        '9780330507417',
        'Gruffalo,The',
        'Paperback'
    ),
    (
        82,
        '9781861976123',
        'Eats, Shoots and Leaves:The Zero Tolerance Approach to Punctuation',
        'Hardback'
    ),
    (
        47,
        '9780590660549',
        'Northern Lights:His Dark Materials S.',
        'Hardback'
    ),
    (
        32,
        '9780755331420',
        'Interpretation of Murder,The',
        'Paperback'
    ),
    (
        83,
        '9781849162746',
        'Girl Who Kicked the Hornets Nest,The:Millennium Trilogy',
        'Paperback'
    ),
    (
        30,
        '9780330367356',
        'Bridget Jones: The Edge of Reason',
        'Paperback'
    ),
    (
        56,
        '9780141020525',
        'Short History of Tractors in Ukrainian,A',
        'Paperback'
    ),
    (
        8,
        '9780722532935',
        'Alchemist,The:A Fable About Following Your Dream',
        'Hardback'
    ),
    (
        14,
        '9780552996006',
        'Notes from a Small Island',
        'Paperback'
    ),
    (
        3,
        '9780099487821',
        'Boy in the Striped Pyjamas,The',
        'Paperback'
    ),
    (
        80,
        '9780718154776',
        'Jamies 30-minute Meals',
        'Hardback'
    ),
    (
        48,
        '9780099457169',
        'Broker,The',
        'Paperback'
    ),
    (
        57,
        '9780330332774',
        'Bridget Joness Diary:A Novel',
        'Paperback'
    ),
    (
        33,
        '9780241003008',
        'Very Hungry Caterpillar,The:The Very Hungry Caterpillar',
        'Hardback'
    ),
    (
        4,
        '9780747582977',
        'Thousand Splendid Suns,A',
        'Hardback'
    ),
    (
        35,
        '9781846051616',
        'Sound of Laughter,The',
        'Paperback'
    ),
    (
        22,
        '9780718147709',
        'Jamies Italy',
        'Paperback'
    ),
    (
        65,
        '9780755307500',
        'Small Island',
        'Hardback'
    ),
    (
        45,
        '9780141030142',
        'Memory Keepers Daughter,The',
        'Paperback'
    ),
    (
        5,
        '9780007110926',
        'Billy Connolly',
        'Paperback'
    ),
    (
        13,
        '9780330448444',
        'House at Riverton,The',
        'Hardback'
    ),
    (
        6,
        '9780747561071',
        'Harry Potter and the Order of the Phoenix',
        'Paperback'
    ),
    (
        79,
        '9780701181840',
        'Nigella Express',
        'Paperback'
    ),
    (
        62,
        '9780099771517',
        'Memoirs of a Geisha',
        'Paperback'
    ),
    (
        68,
        '9780563384311',
        'Delias How to Cook:(Bk.2) ',
        'Paperback'
    ),
    (
        73,
        '9780590112895',
        'Subtle Knife,The:His Dark Materials S.',
        'Paperback'
    ),
    (
        25,
        '9780718148621',
        'Jamies Ministry of Food:Anyone Can Learn to Cook in 24 Hours',
        'Paperback'
    ),
    (
        71,
        '9780701181840',
        'Nigella Express',
        'Paperback'
    ),
    (
        67,
        '9780755307500',
        'Small Island',
        'Hardback'
    ),
    (
        24,
        '9780099487821',
        'Boy in the Striped Pyjamas,The',
        'Paperback'
    ),
    (
        26,
        '9780747591061',
        'Harry Potter and the Deathly Hallows',
        'Paperback'
    ),
    (
        75,
        '9780007110926',
        'Billy Connolly',
        'Paperback'
    ),
    (
        81,
        '9780007156108',
        'Devil Wears Prada,The',
        'Hardback'
    ),
    (
        59,
        '9781861976123',
        'Eats, Shoots and Leaves:The Zero Tolerance Approach to Punctuation',
        'Hardback'
    ),
    (
        17,
        '9780099487821',
        'Boy in the Striped Pyjamas,The',
        'Paperback'
    ),
    (
        10,
        '9780330448444',
        'House at Riverton,The',
        'Hardback'
    ),
    (
        16,
        '9780722532935',
        'Alchemist,The:A Fable About Following Your Dream',
        'Hardback'
    ),
    (
        66,
        '9780099487821',
        'Boy in the Striped Pyjamas,The',
        'Paperback'
    ),
    (
        41,
        '9780747591061',
        'Harry Potter and the Deathly Hallows',
        'Paperback'
    ),
    (
        78,
        '9780755307500',
        'Small Island',
        'Hardback'
    ),
    (
        46,
        '9780718148621',
        'Jamies Ministry of Food:Anyone Can Learn to Cook in 24 Hours',
        'Paperback'
    ),
    (
        58,
        '9780722532935',
        'Alchemist,The:A Fable About Following Your Dream',
        'Hardback'
    ),
    (
        40,
        '9780330448444',
        'House at Riverton,The',
        'Hardback'
    ),
    (
        52,
        '9780007110926',
        'Billy Connolly',
        'Paperback'
    ),
    (
        28,
        '9780747591061',
        'Harry Potter and the Deathly Hallows',
        'Paperback'
    ),
    (
        23,
        '9780755307500',
        'Small Island',
        'Hardback'
    ),
    (
        44,
        '9780007110926',
        'Billy Connolly',
        'Paperback'
    ),
    (
        85,
        '9780718148621',
        'Jamies Ministry of Food:Anyone Can Learn to Cook in 24 Hours',
        'Paperback'
    ),
    (
        7,
        '9780007156108',
        'Devil Wears Prada,The',
        'Hardback'
    ),
    (
        31,
        '9780099487821',
        'Boy in the Striped Pyjamas,The',
        'Paperback'
    );

INSERT INTO
    lineitem (orderid, productid, quantity)
VALUES
    (12, 24, 1),
    (19, 38, 1),
    (17, 33, 1),
    (16, 31, 1),
    (9, 17, 1),
    (5, 10, 1),
    (9, 18, 1),
    (20, 39, 1),
    (11, 22, 1),
    (14, 27, 1),
    (1, 1, 1),
    (17, 34, 1),
    (4, 8, 1),
    (13, 25, 1),
    (8, 16, 1),
    (3, 5, 1),
    (14, 28, 1),
    (3, 6, 1),
    (10, 20, 1),
    (4, 7, 1),
    (15, 29, 1),
    (15, 30, 1),
    (11, 21, 1),
    (6, 11, 1),
    (13, 26, 1),
    (7, 13, 1),
    (1, 2, 1),
    (19, 37, 1),
    (7, 14, 1),
    (2, 3, 1),
    (2, 4, 1),
    (20, 40, 1),
    (6, 12, 1),
    (8, 15, 1),
    (10, 19, 1),
    (5, 9, 1),
    (12, 23, 1),
    (18, 36, 1),
    (18, 35, 1),
    (16, 32, 1);