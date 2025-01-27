module Markup
  ( Document,
    HtmlStruct (..),
  )
where

import Numeric.Natural

type Document =
  [HtmlStruct]

data HtmlStruct
  = Heading Natural String
  | Paragraph String
  | UnorderedList [String]
  | OrderedList [String]
  | CodeBlock [String]
  deriving (Show)
