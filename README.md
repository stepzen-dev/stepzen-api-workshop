## StepZen GraphQL API Workshop

Welcome! In this workshop you'll learn how to create a GraphQL based on the most popular data sources (REST, MySQL, Postgres, GraphQL) with [StepZen](https://stepzen.com).

For this workshop you can select different datasources from the _Getting Started_ section below. These datasources can be run locally with Docker or Node.js, and are prepopulated with data to get you started building GraphQL APIs with StepZen.

### Getting Started:

You need to install the [StepZen CLI](https://www.npmjs.com/package/stepzen), for which you need Node.js and NPM installed.

After installing the CLI you need create a *free* account [here](https://stepzen.com/?utm_source=https://github.com/&utm_medium=github&utm_content=graphql-galaxy-workshop)

If you want to start building a GraphQL on a [MySQL](./mysql/README.md) or [Postgres](./postgres/README.md), make sure to read the requirements for these data sources. You must have [Docker](https://www.docker.com/products/docker-desktop) and [ngrok](https://ngrok.com/download) installed on your machine.

### Assignments

1.  Choose one of the three prepolulated datasources we have prepared for you:

    - [MySQL](./mysql/README.md)
    - [Postgres](./postgres/README.md)
    - [REST](./rest/README.md)

    Add the datasource you selected to the configuration file were all the schemas are merged: `index.graphql`.

    <details>
    <summary>Solution:</summary>

    - For MySQL

    ```graphql
    schema @sdl(files: ["mysql/index.graphql"]) {
      query: Query
    }
    ```

    - For Postgres

    ```graphql
    schema @sdl(files: ["postgres/index.graphql"]) {
      query: Query
    }
    ```

    - For REST

    ```graphql
    schema @sdl(files: ["rest/index.graphql"]) {
      query: Query
    }
    ```

    </details>

2.  Check if the connection with your data source is working by running the query to get a list of books and their names.

    <details>
    <summary>Solution:</summary>

    ```graphql
    query {
      books {
        name
      }
    }
    ```

    </details>

    Tip: Are you getting an error? Have a look at the GraphQL schema that is visible in GraphiQL. Check if the datasource is configured correctly in `config.yaml` according to the READMEs for [MySQL](./mysql/README.md), [Postgres](./postgres/README.md) or [REST](./rest/README.md). If you've selected MySQL or Postgres as a data source, check if the tunnel with [ngrok](https://ngrok.com/) is running and the correct URL is added to `config.yaml`.

3.  With StepZen you can use custom directives, like `@materializer`, to combine data that is retrieved by different queries. The schema that was created for your selected data sources has queries to get `authors` and `books`, which return the types `Author` and `Book`. Connect the field `authorID` on type `Book` using the `@materializer` directive, so you can query the GraphQL API with the following operation:

    ```graphql
    query {
      book(id: 1) {
        name
        author {
          name
        }
      }
    }
    ```

    This query should return the book with `id` equal to `1`, including its author ("Agatha Christie").

    <details>
    <summary>Solution:</summary>

    Add the field `author` to type `Book` in the GraphQL schema for either MySQL, Postgres or REST. The `@materializer` will be configured to use the query `author` when the field `author` is requested by the `books` query. If so, it will take the field `authorID` and pass it to the `author` query as an argument.

    ```graphql
    ## [mysql/postgres/rest]/index.graphql

    type Book {
      id: ID!
      name: String!
      originalPublishingDate: Date!
      authorID: ID!
      author: Author
        @materializer(
          query: "author"
          arguments: [{ name: "id", field: "authorID" }]
        )
      isbn: String
    }
    ```

    </details>

4.  Let's connect another data source to the data you've explored in the first questions. We can enrich the data from our exisiting data source with data from a third-party, like [Google Books](https://developers.google.com/books/docs/v1/using). The Google Books API is a REST API that returns meta-data about almost every book. You can send a reqeuest to the following endpoint to get data for a book with the ISBN 9781407021102: [https://www.googleapis.com/books/v1/volumes?q=9788726586343&country=US](https://www.googleapis.com/books/v1/volumes?q=9781407021102&country=US).

    This request can also be added as a query to your GraphQL API. Therefore you can use the directive `@rest` to connect a REST data source in a new file, this will change the response of the REST API into a GraphQL response. All nested relationships in the returned JSON by the REST API will be respected. You need to create a new `.graphql` file to make this connection, and make sure to add it to `index.graphql` as well.

    After connecting the endpoint you should be able to use the following query to retrive a title, thumbnail and description for a book based on the ISBN:

    ```graphql
    query {
      googleBooks(isbn: "9788726586343") {
        items {
          volumeInfo {
            title
            description
            imageLinks {
              thumbnail
            }
          }
        }
      }
    }
    ```

    Tip: Have a look at the directory `./rest` in this project to see more examples of how the `@rest` directive should be configured.

     <details>
     <summary>Solution:</summary>

    Create a new file (in example) called `googleBooks.graphql`. In this file you need to add a query to get the results from the Google Books API, and you need to define the return types of the data. The response of this API is heavily nested, so you need to create multiple types to define all the fields that you want returned by this new query.

    ```graphql
    ## googleBook.graphql

    type ImageLinks {
      thumbnail: String
    }

    type VolumeInfo {
      title: String
      description: String
      imageLinks: ImageLinks
    }

    type GoogleBook {
      id: ID!
      volumeInfo: VolumeInfo
    }

    type GoogleBookResult {
      items: [GoogleBook]
    }

    type Query {
      googleBooks(isbn: String!): GoogleBookResult
        @rest(
          endpoint: "https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&country=US"
        )
    }
    ```

     </details>

    Tip: Open the Google Books API response in the online tool [JSON2SDL](https://www.json2sdl.com/) to automatically create GraphQL type definitions for the response of the Google Books API.

5.  The response of the query to get book information from the Google Books API with GraphQL is a bit hard to read. Let's refactor the GraphQL schema for this API to flatten the response. After the refactor you should be able to use the following query on the GraphQL API:

    ```graphql
    query {
      googleBooks(isbn: "9788726586343") {
        title
        description
        thumbnail
      }
    }
    ```

    You can use the helpers `resultroot` and `setters` that are available on the `@rest` directive for this.

    Tip: You can append `[]` to the field for `resultroot` to use a field that is returning an array.

    <details>
    <summary>Solution:</summary>

    The helper `resultroot` will take the field `volumeInfo` for every iteration of the `items` array. That way all the fields in `volumeInfo` become top level fields for this query. With `setters` the information for the field `thumbnail` inside the `imageLinks` path can be flattened.

    ```graphql
    ## googleBooks.graphql

    type GoogleBook {
      title: String
      description: String
      thumbnail: String
    }

    type Query {
      googleBooks(isbn: String!): [GoogleBook]
        @rest(
          endpoint: "https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn&country=US"
          resultroot: "items[].volumeInfo"
          setters: [{ field: "thumbnail", path: "imageLinks.thumbnail" }]
        )
    }
    ```

    </details>

6.  With the Google Books API added to the GraphQL API, the next step will be to connect the information from the `books` and `googleBooks` queries. The `Book` type returned from the prepopulated data source has a field called `isbn` which can be used to find meta-data for this book using the Google Books API. Combining types using queries can be done on two ways: with the `@materializer` directive that you used in question 3 or with the dierctive `@sequence` that lets you chain the results of multiple queries. Use this `@sequence` directive to add the following query to your schema:

    ```graphql
    query {
      getBooks {
        name
        description
        thumbnail
        isbn
      }
    }
    ```

    This new query called `getBooks` gets the fields `name` and `isbn` from the query `books`, and the fields `description` and `thumbnail` from `googleBooks`. The combined will result will be coming from both the prepopulated data source and the Google Books API. You can create this query in a new file (in example) called `collections.graphql` or in any of the `.graphql` files you worked in before.

    Tip: `@sequence` only returns the response of the last query in the sequence. Therefore the directive `@collect` needs to be used to collect the reponses from all the queries that are listed in the sequence. You need to create a new type that will be the response type of the collection and the `getBooks` query.

    <details>
    <summary>Solution:</summary>

    The directive `@sequence` needs to call the query `books` first followed by the query `googleBooks`. The query `books` returns a field called `isbn` which is also the name of the argument that is needed by the `googleBooks` query. This value will automatically be passed to this query. The `collect` query uses the `@collect` directive to get the fields `name` and `description` from the `books` query, and the fields `description` and `thumbnail` from the `googleBooks` query. The response type of the `collect` query is the same as for the `getBooks` query, but singular. As the results for every response are collected individually.

    ```graphql
    ## collections.graphql

    type BookResult {
      name: String
      description: String
      thumbnail: String
      isbn: String
    }

    type Query {
      collect(
        name: String
        description: String
        isbn: String
        thumbnail: String
      ): BookResult @connector(type: "echo")
      getBooks: [BookResult]
        @sequence(
          steps: [
            { query: "books" }
            { query: "googleBooks" }
            { query: "collect" }
          ]
        )
    }
    ```

    </details>

BONUS:
