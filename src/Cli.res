@@directive("#!/usr/bin/env node")

let emitter = RescriptEmbedLang.make(
  ~extensionPattern=Generic("jsonSchema"),
  ~setup=async _ => (),
  ~generate=async ({content, path}) => {
    let rescriptSchemaContent = if path->String.startsWith("https://") {
      switch await Fetch.fetch(content->String.trim, {}) {
      | exception Exn.Error(e) => Error(e->Exn.message->Option.getOr("Unknown error"))
      | response =>
        switch await response->Fetch.Response.json {
        | exception Exn.Error(e) => Error(e->Exn.message->Option.getOr("Unknown error"))
        | response =>
          Ok(
            Obj.magic(response)
            ->JSONSchema.toRescriptSchema
            ->RescriptSchema.S.inline,
          )
        }
      }
    } else {
      open NodeJs

      switch Fs.readFileSyncWith(
        Path.resolve([Path.dirname(path), content->String.trim]),
        {encoding: "utf-8"},
      ) {
      | exception Exn.Error(e) => Error(e->Exn.message->Option.getOr("Unknown error"))
      | content =>
        switch JSON.parseExn(content->Buffer.toString) {
        | exception Exn.Error(e) => Error(e->Exn.message->Option.getOr("Unknown error"))
        | json =>
          Ok(
            Obj.magic(json)
            ->JSONSchema.toRescriptSchema
            ->RescriptSchema.S.inline,
          )
        }
      }
    }

    switch rescriptSchemaContent {
    | Error(e) => Error(e)
    | Ok(content) =>
      Ok({
        RescriptEmbedLang.NoModuleName({
          content: "open RescriptSchema\nlet schema = " ++ content,
        })
      })
    }
  },
  ~cliHelpText="CLI help text here",
)

await RescriptEmbedLang.runCli(emitter)
