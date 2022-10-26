## StepZen GraphQL API Workshop

<img src="https://stepzen.com/images/stepzen-stickers.png" width="300">

Welcome! In this workshop, you'll learn how to create a GraphQL based on the most popular data sources (REST, MySQL, Postgres, GraphQL) with [StepZen](https://stepzen.com).

For this workshop, you can select different data sources from the _Getting Started_ section below. These data sources can be run locally with Docker or Node.js and are prepopulated with data to get you started building GraphQL APIs with StepZen.

### Getting Started:

You need to (globally) install the [StepZen CLI](https://www.npmjs.com/package/stepzen), for which you need Node.js and NPM installed:

```bash
npm i -g stepzen
```

After installing the CLI, you can create a _free_ account [here](https://stepzen.com/?utm_source=https://github.com/&utm_medium=github&utm_content=graphql-galaxy-workshop) or continue with a public GraphQL API endpoint.

If you want to start building a GraphQL on a [MySQL](./mysql/README.md) or [Postgres](./postgres/README.md), make sure to read the requirements for these data sources. You must have [Docker](https://www.docker.com/products/docker-desktop) and [ngrok](https://ngrok.com/download) installed on your machine.

### Assignments

1.  Choose one of the three prepopulated data sources we have prepared for you:

    - [MySQL](./mysql/README.md)
    - [Postgres](./postgres/README.md)

    Use the StepZen CLI to introspect the database and generate a GraphQL schema for it. You can start this GraphQL API using `stepzen start`.

    > IMPORTANT: Do not select the option to create relation types. We will take this steps manually to understand better how it works.

    <details>
    <summary>Solution:</summary>

    You can find the complete and working solution in the branch [ex-1](https://github.com/stepzen-dev/stepzen-api-workshop/tree/ex-1).

    - For MySQL

    ```bash
    stepzen import mysql
    ```

    - For Postgres

    ```bash
    stepzen import postgresql
    ```
    </details>

2.  Check the connection to your data source by running the query to get a list of orders and their customer and shipping cost.

    <details>
    <summary>Solution:</summary>

    You can find the complete and working solution in the branch [ex-2](https://github.com/stepzen-dev/stepzen-api-workshop/tree/ex-2).

    ```graphql
    query {
      getOrderList {
        customerId
        shippingCost
      }
    }
    ```

    </details>

    Tip: Are you getting an error? Have a look at the GraphQL schema that is visible in GraphiQL. Check if the data source is configured correctly in `config.yaml` according to the READMEs for [MySQL](./mysql/README.md), [Postgres](./postgres/README.md) or [REST](./rest/README.md). If you've selected MySQL or Postgres as a data source, check if the tunnel with [ngrok](https://ngrok.com/) is running and the correct URL is added to `config.yaml`.

3.  Next to importing the GraphQL schema, you can also use GraphQL SDL to create queries. Add a new query to get a customer by its id.

```graphql
query {
  getCustomerById(id: 1) {
    id
    email
    name
  }
}
```

This query should return the customer with `id` equal to `1`.

<details>
<summary>Solution:</summary>

You can find the complete and working solution in the branch [ex-3](https://github.com/stepzen-dev/stepzen-api-workshop/tree/ex-3).

- For MySQL

```graphql
  getCustomerById(id: Int!): [Customer]
    @dbquery(
      type: "mysql"
      query: """
      select * from `customer` where `id` = ?
      """
      configuration: "mysql_config"
    )
```

- For Postgres

```graphql
getCustomerById(id: Int!): [Customer]
  @dbquery(
    type: "postgresql"
    query: """
    select * from `customer` where `id` = $
    """
    configuration: "postgresql_config"
  )
```

</details>

4.  With StepZen, you can use custom directives, like `@materializer`, to combine data retrieved by different queries. The schema for your selected data sources has queries to get `customers` and `orders`, which return the types `Customer` and `Order`. Connect the field `customerId` on type `Order` to `Customer` using the `@materializer` directive so that you can query the GraphQL API with the following operation:

```graphql
  getOrderList {
    shippingCost
    customer {
      id
      email
      name
    }
  }
```

This query should return the list of orders, including its customer.

<details>
<summary>Solution:</summary>

You can find the complete and working solution in the branch [ex-4](https://github.com/stepzen-dev/stepzen-api-workshop/tree/ex-4).

Add the `customer` field to type `Order` in the GraphQL schema for either MySQL or Postgres or REST. The `@materializer` will be configured to use the `getCustomerById` query when the `getOrderList` query requests the `customer` field. If so, it will take the field `customerId` and pass it to the `getCustomerById` query as an argument.

```graphql
type Order {
  carrier: String!
  createdAt: Date!
  customerId: Int!
  customer: [Customer]
    @materializer(
      query: "getCustomerById"
      arguments: [{ name: "id", field: "customerId" }]
    )
  id: Int!
  shippingCost: Float
  trackingId: String!
}
```

</details>

5.  Let's connect another data source to the data you've explored in the first questions. In this workshop, you've worked with one of the prepopulated data sources given to you. But you can also combine them. For example, extend the data in the database with data from a REST API.

You can get the book meta data information from the Google Books REST API endpoint: [https://developers.google.com/books/docs/v1/getting_started](https://developers.google.com/books/docs/v1/getting_started)).

Tip: To get a book by its ISBN, you can use the following endpoint: `https://www.googleapis.com/books/v1/volumes?q=isbn:9780385513753`.

Tip: Types cannot be duplicated. If you (in example) want to combine MySQL with REST, you need to make sure that these are deleted from the other `.graphql` file they are present.

<details>
<summary>Solution:</summary>

```
stepzen import curl https://www.googleapis.com/books/v1/volumes?q=isbn:9780385513753
```

And connect to products using `@materializer`

</details>


6. Let's add pagination for the queries to get a list of products.

For MySQL: [pagination](https://stepzen.com/docs/quick-start/with-database-mysql#paginate-responses)
For PostgreSQL [pagination](https://stepzen.com/docs/quick-start/with-database-postgresql#paginate-responses)

<details>
<summary>Solution:</summary>


</details>


### Support

Thanks for joining this workshop! If you're looking for additional support, please head over to our [Discord](https://discord.com/invite/9k2VdPn2FR) or open an issue in this repository.
