// @sourceHash 530453ee99a060883eb5f9eb868fa0ee

module M1 = {
  open RescriptSchema
  let schema = S.object(s =>
    {
      "Id": s.field("Id", S.float),
      "Title": s.field("Title", S.string),
      "Tags": s.field("Tags", S.option(S.array(S.string))->S.Option.getOr(%raw(`[]`))),
      "Age": s.field("Age", S.option(S.int->S.describe("Use rating instead"))),
    }
  )
}