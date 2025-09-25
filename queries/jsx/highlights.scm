; extends

;; Highlight capitalized JSX identifiers as types
(jsx_opening_element
  ((identifier) @type
    (#lua-match? @type "^[A-Z]")))

(jsx_closing_element
  ((identifier) @type
    (#lua-match? @type "^[A-Z]")))

(jsx_self_closing_element
  ((identifier) @type
    (#lua-match? @type "^[A-Z]")))

;; Handle dot-operator member expressions: <My.Component>
(jsx_opening_element
  (member_expression
    (identifier) @tag.builtin
    (property_identifier) @type))

(jsx_closing_element
  (member_expression
    (identifier) @tag.builtin
    (property_identifier) @type))

(jsx_self_closing_element
  (member_expression
    (identifier) @tag.builtin
    (property_identifier) @type))

