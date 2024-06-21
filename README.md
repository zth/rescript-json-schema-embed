```rescript
open RescriptSchema

module TestSchema = %generated.jsonSchema("./testschema.json")

let data = %raw(`{
  "Id": 1,
  "Title": "My first film",
  "Age": 17
}`)

switch data->S.parseWith(TestSchema.schema) {
| Ok(content) => Console.log(content)
| Error(err) => Console.error(err)
}
```
