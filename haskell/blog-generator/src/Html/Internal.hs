module Html.Internal where

newtype Html = Html String

newtype HtmlStruct = HtmlStruct String

type Title = String

instance Semigroup HtmlStruct where
  (<>) c1 c2 =
    HtmlStruct (getHtmlStruct c1 <> getHtmlStruct c2)

render :: Html -> String
render (Html a) = a

getHtmlStruct :: HtmlStruct -> String
getHtmlStruct (HtmlStruct c) = c

escape :: String -> String
escape =
  let escapeChar c =
        case c of
          '<' -> "&lt;"
          '>' -> "&gt;"
          '&' -> "&amp;"
          '"' -> "&quot;"
          '\'' -> "&#39;"
          _ -> [c]
   in concatMap escapeChar

el :: String -> String -> String
el tag content =
  "<" <> tag <> ">" <> content <> "</" <> tag <> ">"

html_ :: Title -> HtmlStruct -> Html
html_ t (HtmlStruct c) =
  Html $
    el "html" $
      (el "head" . el "title" . escape) t
        <> el "body" c

p_ :: String -> HtmlStruct
p_ = HtmlStruct . el "p" . escape

h1_ :: String -> HtmlStruct
h1_ = HtmlStruct . el "h1" . escape

ul_ :: [HtmlStruct] -> HtmlStruct
ul_ = HtmlStruct . el "ul" . concatMap (el "li" . getHtmlStruct)

ol_ :: [HtmlStruct] -> HtmlStruct
ol_ = HtmlStruct . el "ol" . concatMap (el "li" . getHtmlStruct)

code_ :: String -> HtmlStruct
code_ = HtmlStruct . el "pre" . escape
