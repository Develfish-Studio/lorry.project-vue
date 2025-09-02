local Project = require('@lorry.project/lib/Project')

export type AnyControl =
  & Project.IHaveProject
  & Project.IHaveName

export type AnyEditable = AnyControl & {}

export type UnwrappedEditable = {}

export type Search = AnyEditable & {
  unwrap_search: (self: Search) -> UnwrappedEditable,
}

export type Select = AnyEditable & {
  unwrap_select: (self: Select) -> UnwrappedEditable,
}

export type EditorJS = AnyEditable & {
  unwrap_editor: (self: EditorJS) -> UnwrappedEditable,
}

export type UploadS3 = AnyEditable & {
  unwrap_upload: (self: UploadS3) -> UnwrappedEditable,
}

return {}