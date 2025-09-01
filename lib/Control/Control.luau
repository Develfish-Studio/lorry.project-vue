--!strict

local EditorJS = require('./EditorJS')
local Search = require('./Search')
local Select = require('./Select')
local Symbol = require('./Symbol')
local UploadS3 = require('./UploadS3')

export type AnyEditableControl =
  | EditorJS.EditorJS
  | Search.Search
  | Select.Select
  | UploadS3.UploadS3

export type AnyControl =
  | AnyEditableControl
  | Symbol.Symbol

export type UnwrappedEditable =
  | EditorJS.UnwrappedEditor
  | Search.UnwrappedSearch
  | Select.UnwrappedSelect
  | UploadS3.UnwrappedUpload

return {
  EditorJS = EditorJS,
  Search = Search,
  Select = Select,
  Symbol = Symbol,
  UploadS3 = UploadS3,
}
